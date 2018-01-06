//
//  DesignerOrderListController.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/18.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class DesignerOrderListController: ButtonBarPagerTabStripViewController {

    override func viewDidLoad() {

        setupNavigationBar()

        self.navigationController?.navigationBar.isTranslucent = false
        // change selected bar color
        settings.style.buttonBarBackgroundColor = UIColor.black
        settings.style.buttonBarItemBackgroundColor = UIColor.black

        settings.style.selectedBarBackgroundColor = UIColor(
            red: 53.0 / 255.0,
            green: 184.0 / 255.0,
            blue: 208 / 255.0,
            alpha: 1.0
        )
        settings.style.buttonBarItemFont = UIFont(name: "Menlo-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16)
        settings.style.selectedBarHeight = 3.0

        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = UIColor.yellow
        settings.style.buttonBarItemsShouldFillAvailableWidth = true

        settings.style.buttonBarLeftContentInset = 20
        settings.style.buttonBarRightContentInset = 20

        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .white
            newCell?.label.textColor = UIColor(
                red: 53.0 / 255.0,
                green: 184.0 / 255.0,
                blue: 208 / 255.0,
                alpha: 1.0
            )
        }

        super.viewDidLoad()
    }

    func setupNavigationBar() {

        self.navigationItem.title = "Order List"

//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon-mode"), style: .plain, target: self, action: #selector(changeMode))

//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon-exit"), style: .plain, target: self, action: #selector(handleSignOut))

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

    }

    // MARK: - Actions

    @objc func changeMode() {

        self.dismiss(animated: true, completion: nil)

    }

    // MARK: - PageTabStripDataSource

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let approvedList = DesignerOrdersController(style: .plain, itemInfo: IndicatorInfo(title: "Orders"))
        let pendingList = DesignerPendingController(style: .plain, itemInfo: IndicatorInfo(title: "Pending"))
        return [pendingList, approvedList]
    }

}
