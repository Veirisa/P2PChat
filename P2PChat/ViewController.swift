//
//  ViewController.swift
//  P2PChat
//
//  Created by Анна Родионова on 16.02.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let lyfecycleLogger = LifecycleLogger()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lyfecycleLogger.log(with: "ViewController moved to \"Appearing\": \(#function)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        lyfecycleLogger.log(with: "ViewController moved from \"Appearing\" to \"Appeared\": \(#function)")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        lyfecycleLogger.log(with: "\(#function)")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        lyfecycleLogger.log(with: "\(#function)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        lyfecycleLogger.log(with: "ViewController moved to \"Disappearing\": \(#function)")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        lyfecycleLogger.log(with: "ViewController moved from \"Disappearing\" to \"Disappeared\": \(#function)")
    }
}

