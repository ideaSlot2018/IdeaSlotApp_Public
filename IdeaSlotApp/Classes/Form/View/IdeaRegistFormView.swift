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
        static let height:CGFloat = 600
    }
    
    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.layer.masksToBounds = true
            containerView.layer.masksToBounds = true
            containerView.layer.cornerRadius = 5.0
            containerView.backgroundColor = UIColor.white
        }
    }
    @IBOutlet weak var ideaTitle: UITextField!
    @IBOutlet weak var saveButton: UIButton!{
        didSet{
            saveButton.layer.masksToBounds = true
            saveButton.layer.cornerRadius = 5.0
            saveButton.setImage(UIImage(named: "Check-OK"), for: .normal)
        }
    }
    @IBOutlet weak var wordText1: UILabel!
    @IBOutlet weak var wordText2: UILabel!
    @IBOutlet weak var operatorName: UILabel!
    @IBOutlet weak var detailsTextView: UITextView!{
        didSet{
            detailsTextView.layer.masksToBounds = true
            detailsTextView.layer.cornerRadius = 5.0
            detailsTextView.layer.borderWidth = 2.0
            detailsTextView.layer.borderColor = UIColor.gray.cgColor
        }
    }
    
    var saveButtonTapHandler:(() -> Void)?
    
    @IBAction func saveButtonAction(_ sender: Any) {
        saveButtonTapHandler?()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addBottomBorder(view: ideaTitle, height: 1.0, color: UIColor.darkGray.cgColor)
        addBottomBorder(view: wordText1, height: 1.0, color: UIColor.darkGray.cgColor)
        addBottomBorder(view: wordText2, height: 1.0, color: UIColor.darkGray.cgColor)
        addBottomBorder(view: operatorName, height: 1.0, color: UIColor.darkGray.cgColor)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
