//
//  GCDDataManager.swift
//  P2PChat
//
//  Created by Anna Rodionova on 15.03.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import UIKit

class GCDProfileDataManager: ProfileDataManager {
    
    weak var delegate: ProfileDataManagerDelegate?
    
    let globalQueue = DispatchQueue.global(qos: .default)
    
    let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    let fullNameFileName = "fullName.txt"
    let descriptionFileName = "description.txt"
    let avatarFileName = "avatar.png"
    
    // MARK: Reading
    
    private func readTextData(fileName: String) -> String? {
        if let directory = directory {
            let path = directory.appendingPathComponent(fileName)
            let text = try? String(contentsOf: path, encoding: .utf8)
            return text
        }
        return nil
    }
    
    private func readImageData(fileName: String) -> UIImage? {
        if let directory = directory {
            let path = directory.appendingPathComponent(fileName)
            guard let imageData = try? Data(contentsOf: path) else { return nil }
            return UIImage(data: imageData)
        }
        return nil
    }
    
    func readProfile() {
        globalQueue.async {[weak self] in
            guard let self = self else { return }
            let profile = ProfileModel.shared
            let fullName = self.readTextData(fileName: self.fullNameFileName)
            if let fullName = fullName {
                profile.fullName = fullName
            }
            let description = self.readTextData(fileName: self.descriptionFileName)
            if let description = description {
                profile.description = description
            }
            let avatar = self.readImageData(fileName: self.avatarFileName)
            if let avatar = avatar {
                profile.avatar = avatar
            }
            self.delegate?.profileDidReaded()
        }
    }
    
    // MARK: Writing
    
    private func writeTextData(fileName: String, text: String) -> Bool {
        if let directory = directory {
            let path = directory.appendingPathComponent(fileName)
            do {
                try text.write(to: path, atomically: false, encoding: .utf8)
                return true
            } catch {
                return false
            }
        }
        return false
    }
    
    private func writeImageData(fileName: String, image: UIImage) -> Bool {
        if let directory = directory {
            let path = directory.appendingPathComponent(fileName)
            if let imageData = image.pngData() {
                do {
                    try imageData.write(to: path, options: .atomic)
                    return true
                } catch {
                    return false
                }
            }
        }
        return false
    }
    
    func writeProfile(fullName: String?, description: String?, avatar: UIImage?) {
        globalQueue.async {[weak self] in
            guard let self = self else { return }
            let profile = ProfileModel.shared
            var fullNameWritingStatus = true
            if let fullName = fullName {
                fullNameWritingStatus = self.writeTextData(fileName: self.fullNameFileName, text: fullName)
                if fullNameWritingStatus {
                    profile.fullName = fullName
                }
            }
            var descriptionWritingStatus = true
            if let description = description {
                descriptionWritingStatus = self.writeTextData(fileName: self.descriptionFileName, text: description)
                if descriptionWritingStatus {
                    profile.description = description
                }
            }
            var avatarWritingStatus = true
            if let avatar = avatar {
                avatarWritingStatus = self.writeImageData(fileName: self.avatarFileName, image: avatar)
                if avatarWritingStatus {
                    profile.avatar = avatar
                }
            }
            let writingStatus = fullNameWritingStatus && descriptionWritingStatus && avatarWritingStatus
            self.delegate?.profileDidWrited(status: writingStatus)
        }
    }
}
