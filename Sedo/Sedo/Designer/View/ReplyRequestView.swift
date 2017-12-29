//
//  ReplyRequestView.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/29.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

import UIKit

class ReplyRequestView: UIView {

    @IBOutlet weak var customerImageView: UIImageView!
    
    @IBOutlet weak var bubbleImageView: UIImageView!

    @IBOutlet weak var leftButton: UIButton!
    
    @IBOutlet weak var rightButton: UIButton!

    @IBOutlet weak var serviceLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var noteLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override func awakeFromNib() {

        super.awakeFromNib()

        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)

        self.translatesAutoresizingMaskIntoConstraints = false

        setupBubbleView()

        setupButtons()
    }

    func setupBubbleView() {
        bubbleImageView.image = #imageLiteral(resourceName: "icon-chatBubble").withRenderingMode(.alwaysTemplate)
//        bubbleImageView.tintColor = UIColor(
//            red: 53.0 / 255.0,
//            green: 184.0 / 255.0,
//            blue: 208 / 255.0,
//            alpha: 0.5
//        )
    }

    func setupLabels() {
        
    }

    func setupButtons() {
        leftButton.layer.cornerRadius = leftButton.frame.height / 2
        leftButton.layer.borderWidth = 1.0
        leftButton.layer.borderColor = UIColor(
            red: 53.0 / 255.0,
            green: 184.0 / 255.0,
            blue: 208 / 255.0,
            alpha: 1.0
            ).cgColor

        rightButton.layer.cornerRadius = rightButton.frame.height / 2
        rightButton.layer.borderWidth = 1.0
        rightButton.layer.borderColor = UIColor(
            red: 245.0 / 255.0,
            green: 30.0 / 255.0,
            blue: 8 / 255.0,
            alpha: 1.0
            ).cgColor
    }
}
