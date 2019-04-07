//
//  UIApplication.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/09/08.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

extension UIApplication{
    
    class func topViewController(_ viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(presented)
        }
        
        if let slide = viewController as? SlideMenuController {
            return topViewController(slide.mainViewController)
        }
        return viewController
    }
}
