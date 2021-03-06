//
//  CustomerTabBarItemType.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/14.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

// MARK: - CustomerTabBarItemType

import UIKit

enum CustomerTabBarItemType {

    // MARK: Case

    case main, order, profile

}

// MARK: - Title

extension CustomerTabBarItemType {

    var title: String {

        switch self {

        case .main:

            return NSLocalizedString("Main", comment: "")

        case .profile:

            return NSLocalizedString("Customer", comment: "")

        case .order:

            return NSLocalizedString("Order", comment: "")

        }

    }

}

// MARK: - Image

extension CustomerTabBarItemType {

    var image: UIImage {

        switch self {

        case .main:

            return #imageLiteral(resourceName: "icon-home").withRenderingMode(.alwaysTemplate)

        case .order:

            return #imageLiteral(resourceName: "icon-order").withRenderingMode(.alwaysTemplate)

        case .profile:

            return #imageLiteral(resourceName: "icon-setting").withRenderingMode(.alwaysTemplate)
        }
    }

    var selectedImage: UIImage? {

        switch self {

        case .main:

            return #imageLiteral(resourceName: "selected-home").withRenderingMode(.alwaysTemplate)

        case .order:

            return nil

        case .profile:

            return #imageLiteral(resourceName: "selected-setting").withRenderingMode(.alwaysTemplate)
        }

    }
}
