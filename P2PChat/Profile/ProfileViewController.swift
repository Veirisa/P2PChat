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
    
    /*
     * Fatal error: Unexpectedly found nil while implicitly unwrapping an Optional value: file
     * Причина ошибки - на данный момент editButton еще не инициализирована (т. е. является nil),
     * т. к. storyboard еще не загружен.
     */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // print("Кнопка редактирования - frame (\(#function)): \(editButton.frame)")
    }
    
    /*
     * K моменту вызова viewDidLoad storyboard был загружен, и мы видим frame,
     * соответсвующий устройству, выбранному в storyboard (iPhoneSE).
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        print("Кнопка редактирования - frame (\(#function)): \(editButton.frame)")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLayoutCharacteristics()
    }
    
    /*
     * К моменту вызова viewDidAppear уже выполнился layoutSubviews у view, являющегося корневым в
     * storyboard, в котором frame изменился в соответствии с выбранным симулятором (iPhone 8 Plus).
     * В момент вызова viewDidLoad этого еще не произошло, поэтому frame отличается.
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setLayoutCharacteristics()
        print("Кнопка редактирования - frame (\(#function)): \(editButton.frame)")
    }
    
    // MARK: Change avatar
    
    private func openGallery() {
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let cameraExceptionAlert = UIAlertController(title: "Ошибка", message: "Ваше устройство не имеет камеры.", preferredStyle: .alert)
            cameraExceptionAlert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))
            self.present(cameraExceptionAlert, animated: true, completion: nil)
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
        print("Выбери изображение профиля")
        let changeAvatarAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        changeAvatarAlert.addAction(UIAlertAction(title: "Галерея", style: .default, handler: { [weak self] _ in
            changeAvatarAlert.dismiss(animated: true, completion: nil)
            self?.openGallery()
        }))
        changeAvatarAlert.addAction(UIAlertAction(title: "Камера", style: .default, handler: { [weak self] _ in
            changeAvatarAlert.dismiss(animated: true, completion: nil)
            self?.openCamera()
        }))
        changeAvatarAlert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))
        self.present(changeAvatarAlert, animated: true, completion: nil)
    }
}
