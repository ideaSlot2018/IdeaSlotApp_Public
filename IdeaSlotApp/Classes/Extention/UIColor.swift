//
//  UIColor.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/11/12.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import UIKit

extension UIColor{
    struct AppColor {
        private init() {}
        //common
        static let navigationbarColor = #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
        static let navigationTitle = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        static let backgroundHeader = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        static let buttonColor = #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
        static let buttonTextColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        static let textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        static let searchbarColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        static let deleteBackGroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        static let editBackGroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        
        //form
        static let formBackgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

        //left menu
        static let backgroundLeftmenu = #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
        static let separatorColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        static let leftmenuCellColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        
        //picker
        static let pickerColor = #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
        static let pickerTextColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
    }
}
