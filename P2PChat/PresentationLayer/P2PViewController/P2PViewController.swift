//
//  P2PViewController.swift
//  P2PChat
//
//  Created by Anna Rodionova on 26.04.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import UIKit

class P2PViewController: UIViewController {
    
    private var isKeyboardEnabled = false
    
    private let imageSize = CGFloat(40.0)
    private let imageVectorLength = CGFloat(40.0)
    
    private let imageName = "TinkoffLogo"
    private var imageView: UIImageView?
    
    private var isLogoAnimated = false
    
    // MARK: Image View
    
    func initImageView() {
        let imageView = UIImageView(image: UIImage(named: imageName))
        imageView.alpha = 0
        view.addSubview(imageView)
        self.imageView = imageView
    }
    
    // MARK: Keyboard observers

    @objc func keyboardWillShow(notification: NSNotification) {
        print("keyboardWillShow")
        isKeyboardEnabled = true
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        print("keyboardWillHide")
        isKeyboardEnabled = false
    }
    
    func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIWindow.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIWindow.keyboardWillHideNotification,
                                               object: nil)
    }
    
    func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Gesture recognizer
    
    func getRandomDirection() -> CGPoint {
        let angle = drand48() * 2 * Double.pi
        return CGPoint(x: cos(angle), y: sin(angle))
    }
    
    func setInitialState(_ recognizer: UILongPressGestureRecognizer) {
        imageView?.alpha = 0
        let location = recognizer.location(in: view)
        let initialFrame = CGRect(x: location.x - imageSize / 2,
                                  y: location.y - imageSize / 2,
                                  width: imageSize,
                                  height: imageSize)
        imageView?.frame = initialFrame
    }
    
    func doLogoAnimation(_ recognizer: UILongPressGestureRecognizer) {
        setInitialState(recognizer)
        if !isLogoAnimated { return }
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: { [weak self] in
            guard let self = self else { return }
            let direction = self.getRandomDirection()
            self.imageView?.alpha = 1
            self.imageView?.center.y += self.imageVectorLength * direction.y
            self.imageView?.center.x += self.imageVectorLength * direction.x
        }, completion: {[weak self] _ in self?.doLogoAnimation(recognizer)})
    }
    
    @objc func showLogo(_ recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == .began {
            isLogoAnimated = true
            if let imageView = imageView {
                view.bringSubviewToFront(imageView)
                doLogoAnimation(recognizer)
            }
        }
        if recognizer.state == .ended {
            isLogoAnimated = false
        }
    }
    
    func setupGestureRecognizer() {
        let gestureRecognizer = UILongPressGestureRecognizer()
        gestureRecognizer.addTarget(self, action: #selector(showLogo))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initImageView()
        addKeyboardObservers()
        setupGestureRecognizer()
    }
    
    deinit {
        removeKeyboardObservers()
    }
}
