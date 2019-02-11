//
//  IdeaRegistFormView.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2019/01/14.
//  Copyright © 2019年 yuta akazawa. All rights reserved.
//

import UIKit

class IdeaRegistFormView: UIView {
    enum Const {
        static let height:CGFloat = 400
    }
    
    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.layer.masksToBounds = true
            containerView.layer.masksToBounds = true
            containerView.layer.cornerRadius = 5.0
        }
    }
    
    @IBOutlet weak var textContainerView: UIView!{
        didSet{
            textContainerView.backgroundColor = UIColor.gray
            textContainerView.layer.masksToBounds = true
            textContainerView.layer.cornerRadius = 5.0
        }
    }
    
    @IBOutlet weak var ideaTitle: UITextField!{
        didSet{
            ideaTitle.layer.masksToBounds = true
            ideaTitle.layer.cornerRadius = 5.0
        }
    }
    
    @IBOutlet weak var saveButton: UIButton!{
        didSet{
            saveButton.layer.masksToBounds = true
            saveButton.layer.cornerRadius = 5.0
        }
    }
    
    @IBOutlet weak var detailTextView: UITextView!{
        didSet{
            detailTextView.layer.masksToBounds = true
            detailTextView.layer.cornerRadius = 5.0
        }
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        print("tap save button")
    }
}
