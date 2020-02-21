//
//  ViewController.swift
//  P2PChat
//
//  Created by Анна Родионова on 16.02.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        if let profileViewController = profileStoryboard.instantiateInitialViewController() {
            profileViewController.modalPresentationStyle = .fullScreen
            self.present(profileViewController, animated: true, completion: nil)
        }
    }
}

