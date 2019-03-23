//
//  IdeaDetailsViewController.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/09/29.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import UIKit
import RealmSwift

class IdeaDetailsViewController: UIViewController {
    
    @IBOutlet weak var ideaTitle: UITextField!
    @IBOutlet weak var wordName1: UILabel!
    @IBOutlet weak var wordName2: UILabel!
    @IBOutlet weak var categoryButton: UIButton!{
        didSet{
            categoryButton.layer.masksToBounds = true
            categoryButton.layer.cornerRadius = 5.0
            categoryButton.backgroundColor = UIColor.AppColor.buttonColor
            categoryButton.tintColor = UIColor.AppColor.buttonTextColor
            categoryButton.titleLabel?.font = UIFont.systemFont(ofSize: 20.0)
        }
    }
    @IBOutlet weak var operatorImageView: UIImageView!{
        didSet{
            operatorImageView.contentMode = .scaleAspectFill
        }
    }
    @IBOutlet weak var detailsTextView: UITextView!{
        didSet{
            detailsTextView.layer.masksToBounds = true
            detailsTextView.layer.cornerRadius = 5.0
            detailsTextView.layer.borderWidth = 2.0
            detailsTextView.layer.borderColor = UIColor.gray.cgColor
            detailsTextView.isEditable = false
        }
    }
    @IBOutlet weak var editButton: UIButton!{
        didSet{
            editButton.setImage(UIImage(named: "Edit"), for: .normal)
            editButton.tintColor = UIColor.gray
        }
    }
    @IBOutlet weak var registerButton: UIButton!{
        didSet{
            registerButton.setImage(UIImage(named: "Done"), for: .normal)
            registerButton.tintColor = UIColor.green
        }
    }
    
    var operatorImage:UIImage? = nil
    var idea:Idea? = nil
    
    let categoryManager = CategoryManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarTitle()
        customBackButton()
        
        //bottom border
        addBottomBorder(view: ideaTitle, height: 1.0, color: UIColor.gray.cgColor)
        addBottomBorder(view: wordName1, height: 1.0, color: UIColor.gray.cgColor)
        addBottomBorder(view: wordName2, height: 1.0, color: UIColor.gray.cgColor)
        
        switchEnabled(editable: false)
        registerButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let linkedCategory = categoryManager.findCategoryItem(categoryId: idea!.categoryId)
        
        //set idea's description
        ideaTitle.text = idea?.ideaName
        if linkedCategory != nil {
            categoryButton.setTitle(linkedCategory?.categoryName, for: .normal)
        } else {
            categoryButton.setTitle("No Category", for: .normal)
        }
        wordName1.text = idea?.words[0].word
        wordName2.text = idea?.words[1].word
        detailsTextView.text = idea?.details
        operatorImageView.image = UIImage(named: "Operator-\(idea!.operatorId1!)")
        operatorImageView.contentMode = .center
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func categoryButtonAction(_ sender: Any) {
    }
    @IBAction func editButtonAction(_ sender: Any) {
        if registerButton.isEnabled {
            switchEnabled(editable: false)
        } else {
            switchEnabled(editable: true)
        }
    }
    @IBAction func registerButtonAction(_ sender: Any) {
        //update idea
        switchEnabled(editable: false)
    }
    
    func switchEnabled(editable:Bool) {
        ideaTitle.isEnabled = editable
        categoryButton.isEnabled = editable
        detailsTextView.isEditable = editable
        registerButton.isEnabled = editable
    }
    
}
