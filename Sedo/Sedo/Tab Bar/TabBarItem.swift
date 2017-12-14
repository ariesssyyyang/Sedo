//
//  TabBarItem.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/14.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

// MARK: - TabBarItem

import UIKit

class TabBarItem: UITabBarItem {
    
    // MARK: Property
    
    var itemType: TabBarItemType?
    
    // MARK: Init

    init(itemType: TabBarItemType) {

        super.init()
        
        self.itemType = itemType
        
        self.title = itemType.title
        
        self.image = itemType.image
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
    }

}
