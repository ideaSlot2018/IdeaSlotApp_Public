//
//  CategoryRegistFormView.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/12/16.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import UIKit

class CategoryRegistFormView: UIView {
    
    @IBOutlet weak var textFrom: UITextField!
    @IBOutlet weak var registButton: UIButton!
    let categoryId:Int? = nil
    
    @IBAction func RegistAction(_ sender: Any) {
        registCategory()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupRegistForm()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func registCategory(){
        print("tap regist button :",textFrom.text)
    }

    private func setupRegistForm(){
        textFrom.placeholder = "15 characters"
        
        registButton.setTitle("Continue", for: .normal)
        registButton.backgroundColor = UIColor.AppColor.buttonColor
        registButton.tintColor = UIColor.AppColor.buttonTextColor
        registButton.layer.cornerRadius = 5.0
        registButton.layer.masksToBounds = true
    }
}
