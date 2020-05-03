//
//  ProfileViewController.swift
//  P2PChat
//
//  Created by Анна Родионова on 21.02.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import UIKit

class ProfileViewController: P2PViewController, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate, ProfileDataManagerDelegate, NetworkProfilePictureViewControllerDelegate {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var changeAvatarButton: UIButton!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var cancelEditingButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let profileDataManager = ProfileDataManagerImpl()
    private var isWritingExecuted = false
    
    private var imagePicker = UIImagePickerController();
    
    // MARK: Init navigation bar
    
    @objc private func closeProfile() {
        dismiss(animated: true, completion: nil)
    }
    
    private func initNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(closeProfile))
    }
    
    // MARK: Set layout characteristics
    
    private func setButtonLayoutCharacteristics(_ button: UIButton) {
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
    }
    
    private func setLayoutCharacteristics() {
        changeAvatarButton.layer.cornerRadius = changeAvatarButton.frame.size.width / 2
        changeAvatarButton.clipsToBounds = true
        avatarImageView.layer.cornerRadius = changeAvatarButton.layer.cornerRadius
        avatarImageView.clipsToBounds = true
        descriptionTextView.textColor = .darkGray
        setButtonLayoutCharacteristics(editButton)
        setButtonLayoutCharacteristics(cancelEditingButton)
        setButtonLayoutCharacteristics(saveButton)
    }
    
    // MARK: Set current values
    
    private func setCurrentValues() {
        let profile = ProfileModel.shared
        fullNameTextField.text = profile.fullName
        descriptionTextView.text = profile.description
        avatarImageView.image = profile.avatar
    }
    
    // MARK: Set editing characteristics
    
    private func setEditingModeCharacteristics() {
        fullNameTextField.isUserInteractionEnabled = true
        descriptionTextView.isUserInteractionEnabled = true
        changeAvatarButton.isEnabled = true
        cancelEditingButton.isHidden = false
        saveButton.isHidden = false
        editButton.isHidden = true
        deactivateSaveButton()
    }
    
    private func setNonEditingModeCharacteristics() {
        fullNameTextField.isUserInteractionEnabled = false
        descriptionTextView.isUserInteractionEnabled = false
        changeAvatarButton.isEnabled = false
        cancelEditingButton.isHidden = true
        saveButton.isHidden = true
        editButton.isHidden = false
        setCurrentValues()
    }
    
    @IBAction func enterEditingMode(_ sender: UIButton) {
        setEditingModeCharacteristics()
    }
    
    @IBAction func enterNonEditingMode(_ sender: UIButton) {
        setNonEditingModeCharacteristics()
    }
    
    // MARK: Save button activation
    
    private func activateSaveButton() {
        saveButton.isEnabled = true
    }
    
    private func deactivateSaveButton() {
        saveButton.isEnabled = false
    }
    
    private func tryActivateSaveButton() {
        let profile = ProfileModel.shared
        if (!isWritingExecuted) {
            if (profile.fullName != fullNameTextField.text
                || profile.description != descriptionTextView.text
                || profile.avatar != avatarImageView.image) {
                activateSaveButton()
                return
            }
        }
        deactivateSaveButton()
    }
    
    // MARK: Manage data
    
    func profileDidReaded() {
        DispatchQueue.main.async { [weak self] in
            self?.setCurrentValues()
        }
    }
    
    func profileDidWrited(status: Bool) {
        isWritingExecuted = false
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tryActivateSaveButton()
            self.activityIndicator.stopAnimating()
            self.showSavingStatusAlert(status)
        }
    }
    
    private func showSavingStatusAlert(_ isSuccess: Bool) {
        if isSuccess {
            let successSavingAlert = UIAlertController(title: "Success", message: "Profile has been saved.", preferredStyle: .alert)
            successSavingAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            present(successSavingAlert, animated: true, completion: nil)
        } else {
            let exceptionSavingAlert = UIAlertController(title: "Error", message: "Profile hasn't been fully saved. You can try to save again.", preferredStyle: .alert)
            exceptionSavingAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            exceptionSavingAlert.addAction(UIAlertAction(title: "Repeat", style: .default, handler: { [weak self] _ in self?.writeData() }))
            present(exceptionSavingAlert, animated: true, completion: nil)
        }
    }
    
    func writeData() {
        deactivateSaveButton()
        activityIndicator.startAnimating()
        let fullName = fullNameTextField.text
        let description = descriptionTextView.text
        let avatar = avatarImageView.image
        profileDataManager.writeProfile(fullName: fullName, description: description, avatar: avatar)
    }
    
    @IBAction func saveProfileAction(_ sender: UIButton) {
        writeData()
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigationBar()
        setLayoutCharacteristics()
        setCurrentValues()
        setNonEditingModeCharacteristics()
        activityIndicator.hidesWhenStopped = true
        imagePicker.delegate = self
        profileDataManager.delegate = self
    }
    
    // MARK: Change full name (TextField)
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        tryActivateSaveButton()
    }
    
    // MARK: Change description (TextView)
    
    func textViewDidEndEditing(_ textView: UITextView) {
        tryActivateSaveButton()
    }
    
    // MARK: Change avatar
    
    private func openGallery() {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        } else {
            let cameraExceptionAlert = UIAlertController(title: "Error", message: "Your device does not have a camera.", preferredStyle: .alert)
            cameraExceptionAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            present(cameraExceptionAlert, animated: true, completion: nil)
        }
    }
    
    private func openNetworkLoader() {
        let profilePictureStoryboard = UIStoryboard(name: "NetworkProfilePicture", bundle: nil)
        if let navController = profilePictureStoryboard.instantiateInitialViewController() as? UINavigationController,
            let profilePictureViewController = navController.topViewController as? NetworkProfilePictureViewController
        {
            profilePictureViewController.delegate = self;
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true, completion: nil)
        }
    }
    
    private func setAvatar(_ image: UIImage) {
        avatarImageView.image = image
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else { return }
        avatarImageView.image = image
        tryActivateSaveButton()
    }
    
    @IBAction func changeAvatarAction(_ sender: UIButton) {
        let changeAvatarAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        changeAvatarAlert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { [weak self] _ in
            changeAvatarAlert.dismiss(animated: true, completion: nil)
            self?.openGallery()
        }))
        changeAvatarAlert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in
            changeAvatarAlert.dismiss(animated: true, completion: nil)
            self?.openCamera()
        }))
        changeAvatarAlert.addAction(UIAlertAction(title: "Network", style: .default, handler: { [weak self] _ in
            changeAvatarAlert.dismiss(animated: true, completion: nil)
            self?.openNetworkLoader()
        }))
        changeAvatarAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(changeAvatarAlert, animated: true, completion: nil)
    }

    func pictureDidChoosed(_ image: UIImage) {
        avatarImageView.image = image
        tryActivateSaveButton()
    }
}
