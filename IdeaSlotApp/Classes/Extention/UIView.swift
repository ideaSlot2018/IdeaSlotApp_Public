//
//  UIView.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2019/02/17.
//  Copyright © 2019年 yuta akazawa. All rights reserved.
//

import UIKit

extension UIView {
    func addBottomBorder(view:UIView, height:CGFloat, color:CGColor) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: view.frame.size.height, width: view.frame.size.width, height: height)
        border.borderColor = color
        border.borderWidth = height
        view.layer.addSublayer(border)
    }
    
    func setImage(image:String){
        let imageview = UIImageView(image: UIImage(named: image))
        imageview.frame = CGRect(x:self.frame.width - 10, y:25, width:20, height:20)
        self.addSubview(imageview)
    }

}

protocol Nibable: NSObjectProtocol {
    static var nibName: String { get }
    static func nib() -> UINib
}

extension Nibable where Self: UIView {
    static var nibName: String {
        return className
    }
    
    static func nib() -> UINib {
        return UINib(nibName: nibName, bundle: nil)
    }
    
    static func view() -> Self {
        return nib().instantiate(withOwner: nil, options: nil).first as! Self
    }
}

extension NSObjectProtocol {
    static var className: String {
        return String(describing: self)
    }
    
    var className: String {
        return type(of: self).className
    }
}
