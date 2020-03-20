//
//  OperationDataManager.swift
//  P2PChat
//
//  Created by Anna Rodionova on 15.03.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import UIKit

class OperationProfileDataManager: ProfileDataManager {
    
    weak var delegate: ProfileDataManagerDelegate?
    
    let operationQueue = OperationQueue()
    
    let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    let fullNameFileName = "fullName.txt"
    let descriptionFileName = "description.txt"
    let avatarFile = "avatar.png"
    
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
    
    func readFullName() {
        let operation = BlockOperation(block: {
            let fullName = self.readTextData(fileName: "fullName.txt")
            self.delegate?.didReadData(fullName: fullName)
        })
        operationQueue.addOperation(operation)
    }
    
    func readDescription() {
        let operation = BlockOperation(block: {
            let description = self.readTextData(fileName: "description.txt")
            self.delegate?.didReadData(description: description)
        })
        operationQueue.addOperation(operation)
    }
    
    func readImage() {
        let operation = BlockOperation(block: {
            let avatar = self.readImageData(fileName: "avatar.png")
            self.delegate?.didReadData(avatar: avatar)
        })
        operationQueue.addOperation(operation)
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
    
    func writeData(fullName: String) {
        let operation = BlockOperation(block: {
            let writingStatus = self.writeTextData(fileName: "fullName.txt", text: fullName)
            self.delegate?.didWriteData(fullName: fullName, status: writingStatus)
        })
        operationQueue.addOperation(operation)
    }
    
    func writeData(description: String) {
        let operation = BlockOperation(block: {
            let writingStatus = self.writeTextData(fileName: "description.txt", text: description)
            self.delegate?.didWriteData(description: description, status: writingStatus)
        })
        operationQueue.addOperation(operation)
    }
    
    func writeData(avatar: UIImage) {
        let operation = BlockOperation(block: {
            let writingStatus = self.writeImageData(fileName: "avatar.png", image: avatar)
            self.delegate?.didWriteData(avatar: avatar, status: writingStatus)
        })
        operationQueue.addOperation(operation)
    }
}
