//
//  mainPageScrollView.swift
//  Sedo
//
//  Created by Aries Yang on 2018/1/10.
//  Copyright © 2018年 Aries Yang. All rights reserved.
//

import UIKit

class MainPageScrollView: UIScrollView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension MainPageScrollView {
    override func touchesShouldCancel(in view: UIView) -> Bool {
        if view is UIButton {
            return true
        }

        return super.touchesShouldCancel(in: view)
    }
}
