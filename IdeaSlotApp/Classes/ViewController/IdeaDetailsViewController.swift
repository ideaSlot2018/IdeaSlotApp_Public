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
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var wordName1: UILabel!
    @IBOutlet weak var wordName2: UILabel!
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
    
    var operatorImage:UIImage? = nil
    
    var idea:Idea? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarTitle()
        customBackButton()
        
        //bottom border
        addBottomBorder(view: ideaTitle, height: 1.0, color: UIColor.gray.cgColor)
        addBottomBorder(view: categoryName, height: 1.0, color: UIColor.gray.cgColor)
        addBottomBorder(view: wordName1, height: 1.0, color: UIColor.gray.cgColor)
        addBottomBorder(view: wordName2, height: 1.0, color: UIColor.gray.cgColor)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //set idea's description
        ideaTitle.text = idea?.ideaName
        categoryName.text = idea?.categoryName
        wordName1.text = idea?.words[0].word
        wordName2.text = idea?.words[1].word
        detailsTextView.text = idea?.details
        operatorImageView.image = UIImage(named: "Operator-\(idea!.operatorId1!)")
        operatorImageView.contentMode = .center

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
