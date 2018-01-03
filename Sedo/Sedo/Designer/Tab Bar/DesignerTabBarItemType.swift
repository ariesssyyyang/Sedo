//
//  DesignerTabBarItemType.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/14.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

// MARK: - DesignerTabBarItemType

import UIKit

enum DesignerTabBarItemType {

    // MARK: Case

    case calendar, portfolio, service, profile

}

// MARK: - Title

extension DesignerTabBarItemType {

    var title: String {

        switch self {

        case .calendar:

            return NSLocalizedString("Calendar", comment: "")

        case .profile:

            return NSLocalizedString("Orders", comment: "")

        case .portfolio:

            return NSLocalizedString("Portfolio", comment: "")

        case .service:

            return NSLocalizedString("Service", comment: "")
        }

    }

}

// MARK: - Image

extension DesignerTabBarItemType {

    var image: UIImage {

        switch self {

        case .calendar:

            return #imageLiteral(resourceName: "icon-calendar").withRenderingMode(.alwaysTemplate)

        case .portfolio:

            return #imageLiteral(resourceName: "icon-works").withRenderingMode(.alwaysTemplate)

        case .service:

            return #imageLiteral(resourceName: "icon-list").withRenderingMode(.alwaysTemplate)

        case .profile:

            return #imageLiteral(resourceName: "icon-user").withRenderingMode(.alwaysTemplate)
        }
    }

    var selectedImage: UIImage? {

        switch self {

        case .calendar:

            return nil

        case .portfolio:

            return #imageLiteral(resourceName: "selected-works").withRenderingMode(.alwaysTemplate)

        case .service:
            return nil

        case .profile:
            return #imageLiteral(resourceName: "selected-user").withRenderingMode(.alwaysTemplate)

        }

    }
}
