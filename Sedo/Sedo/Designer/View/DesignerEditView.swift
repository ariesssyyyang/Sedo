//
//  DesignerEditView.swift
//  Sedo
//
//  Created by Aries Yang on 2017/12/26.
//  Copyright © 2017年 Aries Yang. All rights reserved.
//

import UIKit

class DesignerEditView: UIView {

    @IBOutlet weak var designerImageView: UIImageView!

    @IBOutlet weak var imageSelectedButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var lineIdTextField: UITextField!
    
    @IBOutlet weak var introductionTextField: UITextField!

    override func awakeFromNib() {

        super.awakeFromNib()

        setupImageView()
        
    }

    // MARK: - Set up

    func setupImageView() {

        designerImageView.image = #imageLiteral(resourceName: "icon-alien").withRenderingMode(.alwaysTemplate)
        designerImageView.tintColor = UIColor.lightGray
        designerImageView.layer.borderWidth = 1
        designerImageView.layer.borderColor = UIColor.lightGray.cgColor
        designerImageView.layer.cornerRadius = designerImageView.frame.size.width / 2
        designerImageView.clipsToBounds = true

    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
