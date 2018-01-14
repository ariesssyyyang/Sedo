//
//  CustomerSettingController.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/15.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

import UIKit
import Crashlytics

class CustomerSettingController: UITableViewController {

    let settingCellId = "settingCell"
    let helps: [String] = [NSLocalizedString("Help", comment: ""), NSLocalizedString("Contact us", comment: "")]
    let abouts: [String] = [NSLocalizedString("About", comment: ""), NSLocalizedString("Social Media", comment: ""), NSLocalizedString("Privacy Policy", comment: "")]
    let components: [String] = [NSLocalizedString("About", comment: ""), NSLocalizedString("Help", comment: ""), "Account"]

    override func viewDidLoad() {

        super.viewDidLoad()

        setupNavigationBar()

        setupBackground()

        tableView.register(UINib(nibName: "CustomerSettingCell", bundle: nil), forCellReuseIdentifier: settingCellId)

        tableView.separatorStyle = .none

    }

    // MARK: - Set Up

    func setupNavigationBar() {

        let titleString = NSLocalizedString("Setting", comment: "customer setting")
        self.navigationItem.title = titleString
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

    }

    func setupBackground() {

        let backgroundImageView = UIImageView(image: #imageLiteral(resourceName: "back-woman"))
        backgroundImageView.contentMode = .scaleAspectFill
        tableView.backgroundView = backgroundImageView

        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = backgroundImageView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundImageView.addSubview(blurEffectView)
    }

    // MARK: - Actions

    @objc func handleSignOut() {

        let alert = UIAlertController(title: "Log out", message: "Do you really want to logout?", preferredStyle: .alert)

        let localTitle = NSLocalizedString("Logout", comment: "alert")
        let titleString = NSMutableAttributedString(string: localTitle as String, attributes: [NSAttributedStringKey.font: UIFont(name: "Kohinoor Bangla", size: 20) ?? UIFont.systemFont(ofSize: 20)])

        alert.setValue(titleString, forKey: "attributedTitle")

        let localMessage = NSLocalizedString("Do you really want to log out?", comment: "alert")
        let messageString = NSMutableAttributedString(string: localMessage as String, attributes: [NSAttributedStringKey.font: UIFont(name: "Kohinoor Bangla", size: 16) ?? UIFont.systemFont(ofSize: 16)])

        alert.setValue(messageString, forKey: "attributedMessage")

        let yesString = NSLocalizedString("Yes", comment: "alert action")
        let okAction = UIAlertAction(title: yesString, style: .default) { (_) in

            UserManager.signOut(viewController: self)
        }

        let cancelString = NSLocalizedString("Cancel", comment: "alert action")
        let cancelAction = UIAlertAction(title: cancelString, style: .destructive, handler: nil)

        alert.addAction(cancelAction)
        alert.addAction(okAction)
        alert.view.tintColor = UIColor(
            red: 24.0 / 255.0,
            green: 79.0 / 255.0,
            blue: 135 / 255.0,
            alpha: 1.0
        )

        self.present(alert, animated: true, completion: nil)

    }

    func goMessenger() {

        let urlString = "fb://messaging?id=styolife"
        let webString = "https://www.facebook.com/messages/t/styolife"

        if let url = URL(string: urlString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.open(URL(string: webString)!, options: [:], completionHandler: nil)
            }
        }
    }

    func goFanPage() {
        let urlString = "fb://profile?id=styolife"
        let webString = "https://www.facebook.com/styolife/"
        
        if let url = URL(string: urlString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.open(URL(string: webString)!, options: [:], completionHandler: nil)
            }
        }
    }

    // MARK: - UITableView DataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return components.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch components[section] {
        case NSLocalizedString("About", comment: ""):
            return abouts.count
        case NSLocalizedString("Help", comment: ""):
            return helps.count
        default:
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: settingCellId, for: indexPath) as? CustomerSettingCell
        else { return CustomerSettingCell() }

        let component = components[indexPath.section]
        switch component {
        case NSLocalizedString("About", comment: ""):
            if indexPath.row == 0 {
                cell.goImageView.isHidden = true
                cell.optionLabel.text = component
                cell.optionLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
                return cell
            } else {
                cell.optionLabel.text = abouts[indexPath.row]
                return cell
            }
        case NSLocalizedString("Help", comment: ""):
            if indexPath.row == 0 {
                cell.goImageView.isHidden = true
                cell.optionLabel.text = component
                cell.optionLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
                return cell
            } else {
                cell.optionLabel.text = helps[indexPath.row]
                return cell
            }
        default:
            cell.optionLabel.text = ""
            cell.goImageView.isHidden = true
            cell.logoutButton.isHidden = false
            cell.logoutButton.addTarget(self, action: #selector(handleSignOut), for: .touchUpInside)
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let component = components[indexPath.section]
        switch component {
        case NSLocalizedString("About", comment: ""):
            if indexPath.row == 0 {
                return 50
            } else {
                return 60
            }
        case NSLocalizedString("Help", comment: ""):
            if indexPath.row == 0 {
                return 50
            } else {
                return 60
            }
        default:
            return 70
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let component = components[indexPath.section]
        switch component {
        case NSLocalizedString("About", comment: ""):
            if indexPath.row == 1 {
                goFanPage()
            } else if indexPath.row == 2 {
                let policycontroller = PrivacyPolicyController()
                self.navigationController?.pushViewController(policycontroller, animated: true)
            }
        case NSLocalizedString("Help", comment: ""):
            if indexPath.row != 0 {
                goMessenger()
            }
        default:
            return
        }
    }

}
