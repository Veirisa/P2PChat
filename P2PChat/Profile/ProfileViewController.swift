//
//  ProfileViewController.swift
//  P2PChat
//
//  Created by Анна Родионова on 21.02.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var changeAvatarButton: UIButton!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    var imagePicker = UIImagePickerController();
    
    // MARK: Update navigation bar
    
    @objc private func closeProfile() {
        dismiss(animated: true, completion: nil)
    }
    
    private func updateNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(closeProfile))
    }
    
    // MARK: Set layout characteristics
    
    private func setLayoutCharacteristics() {
        changeAvatarButton.layer.cornerRadius = changeAvatarButton.frame.size.width / 2
        changeAvatarButton.clipsToBounds = true
        avatarImageView.layer.cornerRadius = changeAvatarButton.layer.cornerRadius
        avatarImageView.clipsToBounds = true
        descriptionLabel.textColor = .darkGray
        editButton.layer.borderColor = UIColor.black.cgColor
        editButton.layer.borderWidth = 1
        editButton.layer.cornerRadius = 10
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateNavigationBar()
        setLayoutCharacteristics()
        imagePicker.delegate = self
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
            cameraExceptionAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(cameraExceptionAlert, animated: true, completion: nil)
        }
    }
    
    private func setAvatar(_ image: UIImage) {
        avatarImageView.image = image
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else { return }
        setAvatar(image)
    }
    
    @IBAction func changeAvatar(_ sender: UIButton) {
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
