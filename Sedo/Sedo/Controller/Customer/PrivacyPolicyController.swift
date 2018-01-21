//
//  PrivacyPolicyController.swift
//  Sedo
//
//  Created by Aries Yang on 2018/1/14.
//  Copyright © 2018年 Aries Yang. All rights reserved.
//

import UIKit

class PrivacyPolicyController: UIViewController {

    let textView: UITextView = {
        let tv = UITextView()
        tv.text = privacyPolicyText
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTextView()
    }

    func setupTextView() {
        view.addSubview(textView)

        textView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        textView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

}
