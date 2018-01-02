//
//  FadeInOutTransition.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/20.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

import UIKit

typealias CrossDissolveCompletion = (Bool) -> Void

// swiftlint:disable variable_name
func crossDissolve(from: UIViewController?, to: UIViewController, duration: Double, completion: CrossDissolveCompletion?) {
    // swiftlint:enable variable_name

    guard
        let from = from
    else {

        completion?(true)
        return

    }

    let fromView = from.view!

    let toView = to.view!

    toView.addSubview(fromView)

    UIView.animate(
        withDuration: duration,
        animations: {

            fromView.layer.opacity = 0.0

        },
        completion: { isComplete in

            fromView.removeFromSuperview()

            completion?(isComplete)

        }
    )

}
