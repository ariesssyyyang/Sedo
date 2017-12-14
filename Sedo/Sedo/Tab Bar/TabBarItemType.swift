//
//  TabBarItemType.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/14.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

// MARK: - TabBarItemType

import UIKit

enum TabBarItemType {

    // MARK: Case

    case main, order, profile, calendar, portfolio, service

}

// MARK: - Title

extension TabBarItemType {

    var title: String {

        switch self {

        case .main:

            return NSLocalizedString("Main", comment: "")

        case .profile:

            return NSLocalizedString("Profile", comment: "")

        case .order:
            
            return NSLocalizedString("Order", comment: "")

        case .calendar:
            
            return NSLocalizedString("Calendar", comment: "")
            
        case .portfolio:
            
            return NSLocalizedString("Portfolio", comment: "")
            
        case .service:
            
            return NSLocalizedString("Service", comment: "")
  
        }
        
    }
    
}

// MARK: - Image

extension TabBarItemType {
    
    var image: UIImage {
        
        switch self {
            
        case .main:
            
            return #imageLiteral(resourceName: "icon-home").withRenderingMode(.alwaysTemplate)
            
        case .order:
            
            return #imageLiteral(resourceName: "icon-order").withRenderingMode(.alwaysTemplate)
            
        case .profile:
            
            return #imageLiteral(resourceName: "icon-user").withRenderingMode(.alwaysTemplate)

        case .calendar:
            
            return #imageLiteral(resourceName: "icon-calendar").withRenderingMode(.alwaysTemplate)
            
        case .portfolio:
            
            return #imageLiteral(resourceName: "icon-works").withRenderingMode(.alwaysTemplate)
            
        case .service:
            return #imageLiteral(resourceName: "icon-list").withRenderingMode(.alwaysTemplate)

        }
    }
    
    var selectedImage: UIImage? {
        
        switch self {
            
        case .main:
            
            return #imageLiteral(resourceName: "selected-home").withRenderingMode(.alwaysTemplate)
            
        case .order:
            
            return nil
            
        case .profile:
            
            return #imageLiteral(resourceName: "selected-user").withRenderingMode(.alwaysTemplate)

        case .calendar:
            
            return #imageLiteral(resourceName: "selected-calendar").withRenderingMode(.alwaysTemplate)
            
        case .portfolio:
            
            return #imageLiteral(resourceName: "selected-works").withRenderingMode(.alwaysTemplate)
            
        case .service:

            return nil

        }
        
    }
}
