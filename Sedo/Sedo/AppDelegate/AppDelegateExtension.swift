//
//  AppDelegateExtension.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/20.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

import UIKit

extension AppDelegate {
    
    // swiftlint:disable force_cast
    class var shared: AppDelegate {
        
        return UIApplication.shared.delegate as! AppDelegate
        
    }
    // swiftlint:enable force_cast
    
}
