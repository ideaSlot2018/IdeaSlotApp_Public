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
    let nextImage = UIImage(named: "Into")
    

    override func awakeFromNib() {
        super.awakeFromNib()
        setCategoryItem()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCategoryItem(){
        let imageview = UIImageView(image: nextImage)
        imageview.frame = CGRect(x:self.frame.width - 10, y:25, width:20, height:20)
        self.addSubview(imageview)
    }


}
