//
//  IdeaDetailsViewController.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/09/29.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import UIKit
import RealmSwift
import DropDown

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
    var categoryName: String? = nil
    
    let dropdown = DropDown()
    let categoryManager = CategoryManager()
    let ideaManager = IdeaManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarTitle()
        customBackButton()
        setDropDown(button: categoryButton, dropdown: dropdown)
        dropdown.dataSource = categoryManager.arrayCategoryList(listFlg: 0)
        
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
            categoryName = linkedCategory?.categoryName
        } else {
            categoryButton.setTitle("No Category", for: .normal)
            categoryName = "No Category"
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
        dropdown.show()
    }
    @IBAction func editButtonAction(_ sender: Any) {
        if registerButton.isEnabled {
            switchEnabled(editable: false)
        } else {
            switchEnabled(editable: true)
        }
    }
    @IBAction func registerButtonAction(_ sender: Any) {
        let newCategory = categoryManager.findCategoryItem(categoryName: categoryName!)
        let result = ideaManager.update(idea: idea!, ideaName: ideaTitle!.text!, details: detailsTextView!.text, category: newCategory)
        if result {
            switchEnabled(editable: false)
        } else {
            print("failure")
        }
    }
    
    func switchEnabled(editable:Bool) {
        ideaTitle.isEnabled = editable
        categoryButton.isEnabled = editable
        detailsTextView.isEditable = editable
        registerButton.isEnabled = editable
    }
    
    //set drop down function
    func setDropDown(button:UIButton, dropdown:DropDown){
        dropdown.anchorView = button
        dropdown.selectionAction = {(index, item) in
            button.setTitle(item, for: .normal)
            self.categoryName = item
        }
    }
}
