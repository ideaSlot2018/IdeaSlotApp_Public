//
//  IdeaRegisterFormView.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2019/01/14.
//  Copyright © 2019年 yuta akazawa. All rights reserved.
//

import UIKit
import DropDown

class IdeaRegisterFormView: UIView {
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
            saveButton.setTitle("Create", for: .normal)
            saveButton.isEnabled = false
            saveButton.backgroundColor = UIColor.AppColor.buttonColor
            saveButton.tintColor = UIColor.AppColor.buttonTextColor
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
    @IBOutlet weak var categoryButton: UIButton!{
        didSet{
            categoryButton.setTitle("No Category", for: .normal)
            categoryButton.layer.masksToBounds = true
            categoryButton.layer.cornerRadius = 5.0
            categoryButton.backgroundColor = UIColor.AppColor.buttonColor
            categoryButton.tintColor = UIColor.AppColor.buttonTextColor
            categoryButton.titleLabel?.lineBreakMode = .byTruncatingTail
        }
    }
    @IBOutlet weak var closeButton: UIButton!{
        didSet{
            closeButton.setImage(UIImage(named: "Close"), for: .normal)
            closeButton.tintColor = UIColor.gray
        }
    }
    var saveButtonTapHandler:(() -> Void)?
    var categoryButtonTapHandler:(() -> Void)?
    var closeButtonTapHandler:(() -> Void)?
    var categoryName:String? = nil
    
    let dropdown = DropDown()
    
    @IBAction func saveButtonAction(_ sender: Any) {
        saveButtonTapHandler?()
    }

    @IBAction func showDropdown(_ sender: Any) {
        dropdown.show()
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        closeButtonTapHandler?()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setDropDown(button: categoryButton, dropdown: dropdown)
        addBottomBorder(view: ideaTitle, height: 1.0, color: UIColor.darkGray.cgColor)
        addBottomBorder(view: wordText1, height: 1.0, color: UIColor.darkGray.cgColor)
        addBottomBorder(view: wordText2, height: 1.0, color: UIColor.darkGray.cgColor)
        addBottomBorder(view: operatorName, height: 1.0, color: UIColor.darkGray.cgColor)
        NotificationCenter.default.addObserver(self, selector: #selector(changeNotifyTextField(sender:)), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //set drop down function
    func setDropDown(button:UIButton, dropdown:DropDown){
        dropdown.anchorView = button
        dropdown.selectionAction = {(index, item) in
            button.setTitle(item, for: .normal)
            self.categoryName = item
            self.categoryButtonTapHandler?()
        }
    }
    
    //notify ideaTitle's change
    @objc public func changeNotifyTextField (sender: NSNotification) {
        guard let textfield = sender.object as? UITextField else {
            return
        }
        if textfield.text != nil {
            saveButton.isEnabled = textfield.text != ""
        }
    }
}
