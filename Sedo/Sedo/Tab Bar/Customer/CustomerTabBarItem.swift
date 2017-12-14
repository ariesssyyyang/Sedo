//
//  TabBarItem.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/14.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

// MARK: - CustomerTabBarItem

import UIKit

class CustomerTabBarItem: UITabBarItem {

    // MARK: Property

    var itemType: CustomerTabBarItemType?

    // MARK: Init

    init(itemType: CustomerTabBarItemType) {

        super.init()

        self.itemType = itemType

        self.title = itemType.title

        self.image = itemType.image

    }

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)

    }

}

