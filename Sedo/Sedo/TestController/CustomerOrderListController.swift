//
//  CustomerOrderListController.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/18.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class CustomerOrderListController: ButtonBarPagerTabStripViewController {

    let graySpotifyColor = UIColor(red: 21/255.0, green: 21/255.0, blue: 24/255.0, alpha: 1.0)
    let darkGraySpotifyColor = UIColor(red: 19/255.0, green: 20/255.0, blue: 20/255.0, alpha: 1.0)

    override func viewDidLoad() {

        self.navigationController?.navigationBar.isTranslucent = false
        // change selected bar color
        settings.style.buttonBarBackgroundColor = UIColor.black
        settings.style.buttonBarItemBackgroundColor = UIColor.black

        settings.style.selectedBarBackgroundColor = .yellow
        settings.style.buttonBarItemFont = UIFont(name: "HelveticaNeue-Bold", size: 16) ?? UIFont.systemFont(ofSize: 16)
        settings.style.selectedBarHeight = 3.0

        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = UIColor.yellow
        settings.style.buttonBarItemsShouldFillAvailableWidth = true

        settings.style.buttonBarLeftContentInset = 20
        settings.style.buttonBarRightContentInset = 20

        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .white
            newCell?.label.textColor = .yellow
        }

        super.viewDidLoad()
    }

    // MARK: - PageTabStripDataSource

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let approvedList = CustomerOrdersController(style: .plain, itemInfo: IndicatorInfo(title: "Orders"))
        let pendingList = CustomerPendingController(style: .plain, itemInfo: IndicatorInfo(title: "Pending"))
        return [pendingList, approvedList]
    }

}
