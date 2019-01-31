//
//  IdeasSlotViewController.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/09/27.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import UIKit
import RealmSwift
import DropDown

class IdeasSlotViewController: UIViewController {
//    enum Operators {
//        case plus
//        case minus
//        case multiply
//        case division
//    }

    var ideaSlotPickerView = IdeaSlotPickerView(){
        didSet{
            ideaSlotPickerView.frame = CGRect(x: 0, y: 100, width: IdeaSlotPickerView.Const.width, height: IdeaSlotPickerView.Const.height)
            ideaSlotPickerView.dropdown.dataSource = arrayCategoryList(listFlg: 1)
        }
    }
    var ideaSlotPickerView2 = IdeaSlotPickerView(){
        didSet{
            ideaSlotPickerView2.frame = CGRect(x: self.view.frame.width - IdeaSlotPickerView.Const.width, y: 100, width: IdeaSlotPickerView.Const.width, height: IdeaSlotPickerView.Const.height)
            ideaSlotPickerView2.dropdown.dataSource = arrayCategoryList(listFlg: 1)
        }
    }
    var operatorButton = UIButton(){
        didSet{
            operatorButton.setImage(UIImage(named: "Operator-Plus"), for: .normal)
            operatorButton.imageView?.contentMode = .scaleAspectFit
        }
    }
    var shuffleButton = UIButton(){
        didSet{
            shuffleButton.setTitle("All Shuffle", for: .normal)
            shuffleButton.frame = CGRect(x: 100, y: 425, width: 200, height: 40)
            shuffleButton.backgroundColor = UIColor.AppColor.buttonColor
            shuffleButton.layer.masksToBounds = true
            shuffleButton.layer.cornerRadius = 5.0
        }
    }
    var registForm = IdeaRegistFormView(){
        didSet{
            registForm.frame = CGRect(x: 0, y: 500, width: self.view.frame.size.width, height: IdeaRegistFormView.Const.height)
        }
    }
    var wordEntities:Results<Words>? = nil
    var operatorName:[String] = ["Plus", "Minus", "Multiply", "Divide"]
    let realm = try!Realm()
    let dropdown = DropDown()
    

    /**
     viewDidLoad
     **/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //picker 1
        ideaSlotPickerView = UINib(nibName: "IdeaSlotPickerView", bundle: Bundle(for: type(of: self))).instantiate(withOwner: self, options: nil).first! as! IdeaSlotPickerView

        //picker 2
        ideaSlotPickerView2 = UINib(nibName: "IdeaSlotPickerView", bundle: Bundle(for: type(of: self))).instantiate(withOwner: self, options: nil).first! as! IdeaSlotPickerView

        //regist form
        registForm = UINib(nibName: "IdeaRegistFormView", bundle: Bundle(for: type(of: self))).instantiate(withOwner: self, options: nil).first! as! IdeaRegistFormView
        
        //operator
        dropdown.anchorView = operatorButton
        dropdown.dataSource = operatorName
        dropdown.selectionAction = {(index, item) in
            self.operatorButton.setImage(UIImage(named: "Operator-\(self.operatorName[index])"), for: .normal)
        }
        operatorButton.frame = CGRect(x: self.view.frame.size.width / 2 - 40, y: 210, width: 80, height: 80)
        operatorButton.setImage(UIImage(named: "Operator-Plus"), for: .normal)
        operatorButton.addTarget(self, action: #selector(showOperator), for: .touchUpInside)

        //addSubView
        self.view.addSubview(operatorButton)
        self.view.addSubview(ideaSlotPickerView)
        self.view.addSubview(ideaSlotPickerView2)
        self.view.addSubview(shuffleButton)
        self.view.addSubview(registForm)
    }
    
    /**
     viewWillAppear
     **/
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarTitle(title: "Idea Slot")
        wordEntities = realm.objects(Words.self)
        
        //picker 1
        ideaSlotPickerView = setPickerViewData(view: ideaSlotPickerView, setFlg: 0)
        ideaSlotPickerView.categoryButtonTapHandler = { [weak self] in
            guard let me = self else { return }
            self!.ideaSlotPickerView = me.setPickerViewData(view: self!.ideaSlotPickerView, setFlg: 1)
        }
        ideaSlotPickerView.playButtonTapHandler = { [weak self] in
            guard let me = self else { return }
        }
        
        //picker 2
        ideaSlotPickerView2 = setPickerViewData(view: ideaSlotPickerView2, setFlg: 0)
        ideaSlotPickerView2.categoryButtonTapHandler = { [weak self] in
            guard let me = self else { return }
            self!.ideaSlotPickerView2 = me.setPickerViewData(view: self!.ideaSlotPickerView2, setFlg: 1)
        }
        ideaSlotPickerView2.playButtonTapHandler = { [weak self] in
            guard let me = self else { return }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func showOperator() {
        dropdown.show()
    }
    
    //create words list only word's text
    func arrayWordList(wordList: Array<Words>) -> Array<String> {
        var wordNameList:[String] = []

        for word in wordList{
            wordNameList.append(word.word!)
        }
        return wordNameList
    }
    
    //create filtered words list
    func filteredWordList(category:Category) -> Array<Words>? {
        var wordList = wordEntities
        if category.categoryId != 0 {
            wordList = wordList?.filter("categoryId == %@", category.categoryId)
        }
        return Array(wordList!)
    }
    
    //set up pickerview's property
    func setPickerViewData(view: IdeaSlotPickerView,setFlg:Int) -> IdeaSlotPickerView{
        switch setFlg {
        case 0:
            view.category = self.findCategoryItem(categoryName: "")
            view.wordList = self.filteredWordList(category: Category())
            view.wordNameList = self.arrayWordList(wordList: view.wordList!)

        case 1:
            view.category = self.findCategoryItem(categoryName: view.categoryName!)
            view.wordList = self.filteredWordList(category: view.category!)
            view.wordNameList = self.arrayWordList(wordList: view.wordList!)
            view.wordsPickerView.reloadAllComponents()
        default:
            break
        }
        return view
    }

}
