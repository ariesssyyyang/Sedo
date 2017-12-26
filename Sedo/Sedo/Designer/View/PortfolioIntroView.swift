//
//  PortfolioIntroView.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/24.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

import UIKit

class PortfolioIntroView: UICollectionReusableView {

    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var editButton: UIButton!

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var lineIdLabel: UILabel!
    
    @IBOutlet weak var introTextView: UITextView!
    
    override func awakeFromNib() {

        super.awakeFromNib()

        setupImageView()

        setupButton()

        setupLabel()

        setupTextView()

    }

    func setupImageView() {
        profileImageView.image = #imageLiteral(resourceName: "icon-alien").withRenderingMode(.alwaysTemplate)
        profileImageView.tintColor = UIColor.lightGray
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.borderColor = UIColor.lightGray.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
    }

    func setupButton() {
        editButton.layer.borderWidth = 1.0
        editButton.layer.borderColor = UIColor(red: 147.0/255, green: 174.0/255, blue: 191.0/255, alpha: 1.0).cgColor
        editButton.layer.cornerRadius = 8.0
        editButton.layer.masksToBounds = true
    }

    func setupLabel() {
        
    }

    func setupTextView() {
        
    }
}
