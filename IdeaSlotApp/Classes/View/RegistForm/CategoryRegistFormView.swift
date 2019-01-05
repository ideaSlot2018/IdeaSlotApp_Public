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
    enum Const {
        static let height: CGFloat = 150
    }
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
            registButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
            registButton.backgroundColor = UIColor.AppColor.buttonColor
            registButton.tintColor = UIColor.AppColor.buttonTextColor
            registButton.layer.cornerRadius = 5.0
            registButton.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var closeButton: UIButton!{
        didSet{
            closeButton.setImage(UIImage(named:"Close"), for: .normal)
            closeButton.imageView?.tintColor = UIColor.gray
        }
    }
    
    @IBAction func RegistAction(_ sender: Any) {
        registerButtonTapHandler?()
    }
    
    @IBAction func CloseAction(_ sender: Any) {
        closeButtonTapHandler?()
    }
    
    var registerButtonTapHandler: (() -> Void)?
    var closeButtonTapHandler: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.AppColor.formBackgroundColor
        let border = CALayer()
        border.borderColor = UIColor.black.cgColor
        border.frame = CGRect(x: 0, y: textFrom.frame.size.height, width: textFrom.frame.size.width, height: 1)
        border.borderWidth = CGFloat(2.0)
        
        textFrom.layer.addSublayer(border)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

