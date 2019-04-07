//
//  IdeaTableViewCell.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/09/27.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import UIKit
import SwipeCellKit

class IdeaTableViewCell: SwipeTableViewCell {

    @IBOutlet weak var ideaTitle: UILabel!
    @IBOutlet weak var categoryTitle: UILabel!{
        didSet{
            categoryTitle.textColor = UIColor.AppColor.textColor
        }
    }
    var idea:Idea? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setImage(image: "Into")
    }

}
