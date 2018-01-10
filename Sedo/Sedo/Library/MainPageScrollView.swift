//
//  mainPageScrollView.swift
//  Sedo
//
//  Created by Aries Yang on 2018/1/10.
//  Copyright © 2018年 Aries Yang. All rights reserved.
//

import UIKit

class MainPageScrollView: UIScrollView {

    override func touchesShouldBegin(_ touches: Set<UITouch>, with event: UIEvent?, in view: UIView) -> Bool {
        if view.isKind(of: UIButton.self) {
            return true
        }
        return false
    }

    override func touchesShouldCancel(in view: UIView) -> Bool {
        if view.isKind(of: UIButton.self) {
            return true
        }
        
        return super.touchesShouldCancel(in: view)
    }

}
