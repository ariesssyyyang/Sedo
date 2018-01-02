//
//  UIWindowExtension.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/20.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

// MARK: - UIWindowExtensions

import UIKit

// MARK: - Update Root View Controller

extension UIWindow {
    
    typealias UpdateRootCompletion = (Bool) -> Void

    typealias UpdateRootAnimation = (_ from: UIViewController?, _ to: UIViewController, _ for: Double, _ completion: UpdateRootCompletion?) -> Void
    
    func updateRoot(
        to newViewController: UIViewController,
        animation: UpdateRootAnimation,
        duration: Double,
        completion: UpdateRootCompletion?
        ) {
        
        let fromViewController = rootViewController
        
        let toViewController = newViewController
        
        rootViewController = toViewController

        animation(
            fromViewController,
            toViewController,
            duration,
            completion
        )

    }

}
