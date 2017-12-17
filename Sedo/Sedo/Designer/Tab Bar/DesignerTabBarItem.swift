//
//  DesignerTabBarItem.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/14.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

// MARK: - DesignerTabBarItem

import UIKit

class DesignerTabBarItem: UITabBarItem {

    // MARK: Property

    var itemType: DesignerTabBarItemType?

    // MARK: Init

    init(itemType: DesignerTabBarItemType) {

        super.init()

        self.itemType = itemType

        self.title = itemType.title

        self.image = itemType.image

        self.selectedImage = itemType.selectedImage

    }

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)

    }

}
