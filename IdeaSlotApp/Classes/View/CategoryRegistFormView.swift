//
//  CategoryRegistFormView.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/12/16.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import UIKit
import PopupWindow

class CategoryRegistFormView: UIView ,PopupViewContainable{
    let categoryId:Int? = nil
    
    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var textFrom: UITextField!{
        didSet{
            textFrom.placeholder = "15 characters"
        }
    }
    
    @IBOutlet weak var registButton: UIButton!{
        didSet{
            registButton.setTitle("Continue", for: .normal)
            registButton.backgroundColor = UIColor.AppColor.buttonColor
            registButton.tintColor = UIColor.AppColor.buttonTextColor
            registButton.layer.cornerRadius = 5.0
            registButton.layer.masksToBounds = true
        }
    }
    
    @IBAction func RegistAction(_ sender: Any) {
        registerButtonTapHandler?()
    }
    
    var registerButtonTapHandler: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.blue
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
