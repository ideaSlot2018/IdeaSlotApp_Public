//
//  CategoryTableViewCell.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/11/24.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import UIKit
import SwipeCellKit

class CategoryTableViewCell: SwipeTableViewCell {

    @IBOutlet weak var includeWordsCount: UILabel!{
        didSet{
            includeWordsCount.textColor = UIColor.AppColor.textColor
        }
    }
    @IBOutlet weak var categoryTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setImage(image: "Into")
    }

}
