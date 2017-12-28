//
//  BookingView.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/25.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

import UIKit

class BookingView: UIView {

    @IBOutlet weak var serviceTextField: UITextField!

    @IBOutlet weak var dateTextField: UITextField!
    
    @IBOutlet weak var doneButton: UIButton!
    
    override func awakeFromNib() {

        super.awakeFromNib()

        self.translatesAutoresizingMaskIntoConstraints = false
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
