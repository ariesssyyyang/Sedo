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

    override func viewDidLoad() {

        setupNavigationBar()

        self.navigationController?.navigationBar.isTranslucent = false
        // change selected bar color
        settings.style.buttonBarBackgroundColor = UIColor.white
        settings.style.buttonBarItemBackgroundColor = UIColor.white

        settings.style.selectedBarBackgroundColor = UIColor(
            red: 24.0 / 255.0,
            green: 79.0 / 255.0,
            blue: 135 / 255.0,
            alpha: 1.0
        )
        settings.style.buttonBarItemFont = UIFont(name: "Menlo-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16)
        settings.style.selectedBarHeight = 3.0

        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = UIColor(
            red: 24.0 / 255.0,
            green: 79.0 / 255.0,
            blue: 135 / 255.0,
            alpha: 1.0
        )
        settings.style.buttonBarItemsShouldFillAvailableWidth = true

        settings.style.buttonBarLeftContentInset = 20
        settings.style.buttonBarRightContentInset = 20

        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = UIColor(
                red: 133.0/255,
                green: 53.0/255,
                blue: 11.0/255,
                alpha: 1.0
            )
            newCell?.label.textColor = UIColor(
                red: 24.0 / 255.0,
                green: 79.0 / 255.0,
                blue: 135 / 255.0,
                alpha: 1.0
            )
        }

        super.viewDidLoad()
    }

    func setupNavigationBar() {

        self.navigationItem.title = "Order List"
        self.navigationController?.navigationBar.backgroundColor = UIColor.blue
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Palatino-Bold", size: 20) ?? UIFont.systemFont(ofSize: 20)]

    }

    // MARK: - PageTabStripDataSource

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let approvedList = CustomerOrdersController(style: .plain, itemInfo: IndicatorInfo(title: "Orders"))
        let pendingList = CustomerPendingController(style: .plain, itemInfo: IndicatorInfo(title: "Pending"))
        return [pendingList, approvedList]
    }

}
