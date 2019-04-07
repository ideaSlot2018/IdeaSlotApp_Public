//
//  CategoryDeleteAlertView.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2019/01/04.
//  Copyright © 2019年 yuta akazawa. All rights reserved.
//

import UIKit
import PopupWindow

class CategoryDeleteAlertView: UIView, PopupViewContainable {
    enum Const {
        static let height: CGFloat = 500
    }
    
    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.layer.masksToBounds = true
            containerView.layer.cornerRadius = 5.0
            containerView.backgroundColor = UIColor.AppColor.formBackgroundColor
        }
    }
    
    @IBOutlet weak var deleteDescription: UILabel!{
        didSet{
            deleteDescription.textColor = UIColor.darkGray
        }
    }
    
    @IBOutlet weak var canselButton: UIButton!{
        didSet{
            canselButton.setTitle("Cansel", for: .normal)
            canselButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
            canselButton.tintColor = UIColor.AppColor.buttonColor
            canselButton.layer.cornerRadius = 5.0
            canselButton.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var deleteButton: UIButton!{
        didSet{
            deleteButton.setTitle("Delete", for: .normal)
            deleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
            deleteButton.backgroundColor = UIColor.AppColor.buttonColor
            deleteButton.tintColor = UIColor.AppColor.buttonTextColor
            deleteButton.layer.cornerRadius = 5.0
            deleteButton.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var closeButton: UIButton!{
        didSet{
            closeButton.setImage(UIImage(named: "Close"), for: .normal)
            closeButton.tintColor = UIColor.gray
        }
    }
    
    var deleteButtonTapHandler:(() -> Void)?
    var canselButtonTapHandler:(() -> Void)?
    var closeButtonTapHandler:(() -> Void)?
    
    @IBAction func canselButtonAction(_ sender: Any) {
        canselButtonTapHandler?()
    }
    @IBAction func closeButtonAction(_ sender: Any) {
        closeButtonTapHandler?()
    }
    @IBAction func deleteButtonAction(_ sender: Any) {
        deleteButtonTapHandler?()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        canselButton.layer.borderColor = UIColor.AppColor.buttonColor.cgColor
        canselButton.layer.borderWidth = CGFloat(2.0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
