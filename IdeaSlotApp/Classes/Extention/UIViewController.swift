//
//  UIViewController.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/09/08.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import UIKit
import RealmSwift
import DropDown

extension UIViewController{
    
    func setNavigationBarItem() {
        self.addLeftBarButtonWithImage(UIImage(named: "Menu")!)
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.addLeftGestures()
    }
    
    func setNavigationBarRightItem(imageName: String) {
        let button: UIButton = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.addTarget(self, action: #selector(rightButtonAction), for: .touchUpInside)
        let rightButton = UIBarButtonItem(customView:button)
        let currWidth = rightButton.customView?.widthAnchor.constraint(equalToConstant: 25)
        currWidth?.isActive = true
        let currHeight = rightButton.customView?.heightAnchor.constraint(equalToConstant: 25)
        currHeight?.isActive = true

        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    @objc func rightButtonAction() {}
    
    func setNavigationBarTitle(){
        let navigationTitle = UIImageView(image: UIImage(named: "Header"))
        navigationTitle.frame = CGRect(x: 0, y: 0, width: 100, height: 20)
        self.navigationItem.titleView = navigationTitle
    }
    
    func customBackButton(){
        self.slideMenuController()?.removeLeftGestures()

        let button: UIButton = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        button.setImage(UIImage(named: "Back"), for: .normal)
        button.addTarget(self, action: #selector(toBack), for: .touchUpInside)
        let backButton = UIBarButtonItem(customView:button)
        let currWidth = backButton.customView?.widthAnchor.constraint(equalToConstant: 25)
        currWidth?.isActive = true
        let currHeight = backButton.customView?.heightAnchor.constraint(equalToConstant: 25)
        currHeight?.isActive = true
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func toBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func addBottomBorder(view:UIView, height:CGFloat, color:CGColor) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: view.frame.size.height, width: view.frame.size.width, height: height)
        border.borderColor = color
        border.borderWidth = height
        view.layer.addSublayer(border)
    }

}
