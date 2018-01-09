//
//  AlertManager.swift
//  Sedo
//
//  Created by Aries Yang on 2018/1/7.
//  Copyright © 2018年 Aries Yang. All rights reserved.
//

import Foundation
import UIKit

class AlertManager {

    static func customizedTitle(title: String) -> NSMutableAttributedString {

        let localTitle = NSLocalizedString(title, comment: "alert")
        let titleString = NSMutableAttributedString(string: localTitle as String, attributes: [NSAttributedStringKey.font: UIFont(name: "Kohinoor Bangla", size: 18) ?? UIFont.systemFont(ofSize: 18)])
        return titleString

    }

    static func successTitle(title: String) -> NSMutableAttributedString {

        let sendGreen = UIColor(red: 42.0/255, green: 120.0/255, blue: 27.0/255, alpha: 1.0)

        let localTitle = NSLocalizedString(title, comment: "alert")
        let titleString = NSMutableAttributedString(string: localTitle as String, attributes: [NSAttributedStringKey.font: UIFont(name: "Kohinoor Bangla", size: 20) ?? UIFont.systemFont(ofSize: 20), NSAttributedStringKey.foregroundColor: sendGreen])

        return titleString

    }

    static func customizedMessage(message: String) -> NSMutableAttributedString {

        let localMessage = NSLocalizedString(message, comment: "alert")
        let messageString = NSMutableAttributedString(string: localMessage as String, attributes: [NSAttributedStringKey.font: UIFont(name: "Kohinoor Bangla", size: 12) ?? UIFont.systemFont(ofSize: 12)])
        return messageString

    }

}
