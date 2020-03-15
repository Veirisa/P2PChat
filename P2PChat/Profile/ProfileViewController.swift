//
//  ProfileViewController.swift
//  P2PChat
//
//  Created by Анна Родионова on 21.02.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate, ProfileDataManagerDelegate {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var changeAvatarButton: UIButton!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var cancelEditingButton: UIButton!
    @IBOutlet weak var saveGCDButton: UIButton!
    @IBOutlet weak var saveOperationButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let gcdDataManager = GCDProfileDataManager()
    let operationDataManager = OperationProfileDataManager()
    var dataManager: ProfileDataManager?
    
    var fullNameTaskExecuted = false
    var descriptionTaskExecuted = false
    var avatarTaskExecuted = false
    var isSuccessExecution = true
    
    var currentFullName = "-"
    var currentDescription = "-"
    var currentAvatar = UIImage(named: "PlaceholderUser")
    
    var imagePicker = UIImagePickerController();
    
    // MARK: Update navigation bar
    
    @objc private func closeProfile() {
        dismiss(animated: true, completion: nil)
    }
    
    private func updateNavigationBar() {
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
        setButtonLayoutCharacteristics(saveGCDButton)
        setButtonLayoutCharacteristics(saveOperationButton)
    }
    
    // MARK: Set current values
    
    private func setCurrentValues() {
        fullNameTextField.text = currentFullName
        descriptionTextView.text = currentDescription
        avatarImageView.image = currentAvatar
    }
    
    // MARK: Set editing characteristics
    
    private func setEditingModeCharacteristics() {
        fullNameTextField.isUserInteractionEnabled = true
        descriptionTextView.isUserInteractionEnabled = true
        changeAvatarButton.isEnabled = true
        cancelEditingButton.isHidden = false
        saveGCDButton.isHidden = false
        saveOperationButton.isHidden = false
        editButton.isHidden = true
        deactivateSaveButton()
    }
    
    private func setNonEditingModeCharacteristics() {
        fullNameTextField.isUserInteractionEnabled = false
        descriptionTextView.isUserInteractionEnabled = false
        changeAvatarButton.isEnabled = false
        cancelEditingButton.isHidden = true
        saveGCDButton.isHidden = true
        saveOperationButton.isHidden = true
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
        saveGCDButton.isEnabled = true;
        saveOperationButton.isEnabled = true;
    }
    
    private func deactivateSaveButton() {
        saveGCDButton.isEnabled = false;
        saveOperationButton.isEnabled = false;
    }
    
    private func tryActivateSaveButton() {
        if (!fullNameTaskExecuted && !descriptionTaskExecuted && !avatarTaskExecuted) {
            if (currentFullName != fullNameTextField.text
                || currentDescription != descriptionTextView.text
                || currentAvatar != avatarImageView.image) {
                activateSaveButton()
                return
            }
        }
        deactivateSaveButton()
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateNavigationBar()
        setLayoutCharacteristics()
        setCurrentValues()
        setNonEditingModeCharacteristics()
        activityIndicator.hidesWhenStopped = true
        imagePicker.delegate = self
        gcdDataManager.delegate = self
        operationDataManager.delegate = self
        dataManager = gcdDataManager
        readData()
    }
    
    // MARK: Manage data (ProfileDataManagerDelegate)
    
    private func tryFinishReading() {
        if (!fullNameTaskExecuted && !descriptionTaskExecuted && !avatarTaskExecuted) {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.setCurrentValues()
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func didReadData(fullName: String?) {
        fullNameTaskExecuted = false
        if let fullName = fullName {
            currentFullName = fullName
        }
        tryFinishReading()
    }
     
    func didReadData(description: String?) {
        descriptionTaskExecuted = false
        if let description = description {
            currentDescription = description
        }
        tryFinishReading()
    }
     
    func didReadData(avatar: UIImage?) {
        avatarTaskExecuted = false
        if let avatar = avatar {
            currentAvatar = avatar
        }
        tryFinishReading()
    }
    
    private func tryFinishWriting() {
        if (!fullNameTaskExecuted && !descriptionTaskExecuted && !avatarTaskExecuted) {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.tryActivateSaveButton()
                self.activityIndicator.stopAnimating()
                self.showSavingStatusAlert(self.isSuccessExecution)
            }
        }
    }
     
    func didWriteData(fullName: String, status: Bool) {
        fullNameTaskExecuted = false
        if status {
            currentFullName = fullName
        } else {
            isSuccessExecution = false
        }
        tryFinishWriting()
    }
     
    func didWriteData(description: String, status: Bool) {
        descriptionTaskExecuted = false
        if status {
            currentDescription = description
        } else {
            isSuccessExecution = false
        }
        tryFinishWriting()
    }
     
    func didWriteData(avatar: UIImage, status: Bool) {
        avatarTaskExecuted = false
        if status {
            currentAvatar = avatar
        } else {
            isSuccessExecution = false
        }
        tryFinishWriting()
    }
    
    // MARK: Manage data
    
    private func readData() {
        guard let dataManager = dataManager else { return }
        activityIndicator.startAnimating()
        fullNameTaskExecuted = true
        dataManager.readFullName()
        descriptionTaskExecuted = true
        dataManager.readDescription()
        avatarTaskExecuted = true
        dataManager.readImage()
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
    
    private func writeData() {
        guard let dataManager = dataManager else { return }
        deactivateSaveButton()
        activityIndicator.startAnimating()
        if (currentFullName != fullNameTextField.text) {
            if let newFullName = fullNameTextField.text {
                fullNameTaskExecuted = true
                dataManager.writeData(fullName: newFullName)
            }
        }
        if (currentDescription != descriptionTextView.text) {
            if let newDescription = descriptionTextView.text {
                descriptionTaskExecuted = true
                dataManager.writeData(description: newDescription)
            }
        }
        if (currentAvatar != avatarImageView.image) {
            if let newAvatar = avatarImageView.image {
                avatarTaskExecuted = true
                dataManager.writeData(avatar: newAvatar)
            }
        }
    }
    
    @IBAction func saveDataGCDAction(_ sender: UIButton) {
        dataManager = gcdDataManager
        writeData()
    }
    
    @IBAction func saveDataOperationAction(_ sender: UIButton) {
        dataManager = operationDataManager
        writeData()
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
        print("Choose profile image")
        let changeAvatarAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        changeAvatarAlert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { [weak self] _ in
            changeAvatarAlert.dismiss(animated: true, completion: nil)
            self?.openGallery()
        }))
        changeAvatarAlert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in
            changeAvatarAlert.dismiss(animated: true, completion: nil)
            self?.openCamera()
        }))
        changeAvatarAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(changeAvatarAlert, animated: true, completion: nil)
    }
}
