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
import PopupWindow

class IdeasSlotViewController: UIViewController {

    var ideaSlotPickerView = IdeaSlotPickerView(){
        didSet{
            ideaSlotPickerView.frame = CGRect(x: 0, y: 100, width: IdeaSlotPickerView.Const.width, height: IdeaSlotPickerView.Const.height)
            ideaSlotPickerView.dropdown.dataSource = arrayCategoryList(listFlg: 1)
            ideaSlotPickerView.slotFlg = 1
        }
    }
    var ideaSlotPickerView2 = IdeaSlotPickerView(){
        didSet{
            ideaSlotPickerView2.frame = CGRect(x: self.view.frame.width - IdeaSlotPickerView.Const.width, y: 100, width: IdeaSlotPickerView.Const.width, height: IdeaSlotPickerView.Const.height)
            ideaSlotPickerView2.dropdown.dataSource = arrayCategoryList(listFlg: 1)
            ideaSlotPickerView2.slotFlg = 2
        }
    }
    var operatorButton = UIButton(){
        didSet{
            operatorButton.imageView?.contentMode = .scaleAspectFit
        }
    }
    var shuffleButton = UIButton()
    var pickupButton = UIButton()
    
//    var registForm = IdeaRegistFormView(){
//        didSet{
//            registForm.frame = CGRect(x: 0, y: 500, width: self.view.frame.size.width, height: IdeaRegistFormView.Const.height)
//        }
//    }
    var wordEntities:Results<Words>? = nil
    var operatorName:[String] = ["Plus", "Minus", "Multiply", "Divide"]
    var ideaItem = Idea()    
    let realm = try!Realm()
    let dropdown = DropDown()

    /**
     viewDidLoad
     **/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //picker 1
        //***********************************************************************//
        ideaSlotPickerView = UINib(nibName: "IdeaSlotPickerView", bundle: Bundle(for: type(of: self))).instantiate(withOwner: self, options: nil).first! as! IdeaSlotPickerView
        ideaSlotPickerView.categoryButtonTapHandler = { [weak self] in
            guard let me = self else { return }
            self!.ideaSlotPickerView = me.setPickerViewData(view: self!.ideaSlotPickerView, setFlg: 1)
        }
        ideaSlotPickerView.playButtonTapHandler = { [weak self] in
            guard let me = self else { return }
            me.playSlotPicker(view: self!.ideaSlotPickerView)
        }

        //picker 2
        //***********************************************************************//
        ideaSlotPickerView2 = UINib(nibName: "IdeaSlotPickerView", bundle: Bundle(for: type(of: self))).instantiate(withOwner: self, options: nil).first! as! IdeaSlotPickerView
        ideaSlotPickerView2.categoryButtonTapHandler = { [weak self] in
            guard let me = self else { return }
            self!.ideaSlotPickerView2 = me.setPickerViewData(view: self!.ideaSlotPickerView2, setFlg: 1)
        }
        ideaSlotPickerView2.playButtonTapHandler = { [weak self] in
            guard let me = self else { return }
            me.playSlotPicker(view: self!.ideaSlotPickerView2)
        }

        //regist form
        //***********************************************************************//
//        registForm = UINib(nibName: "IdeaRegistFormView", bundle: Bundle(for: type(of: self))).instantiate(withOwner: self, options: nil).first! as! IdeaRegistFormView
        
        //operator
        //***********************************************************************//
        dropdown.anchorView = operatorButton
        dropdown.dataSource = operatorName
        dropdown.selectionAction = {(index, item) in
            self.operatorButton.setImage(UIImage(named: "Operator-\(self.operatorName[index])"), for: .normal)
            self.ideaItem.operatorId1 = item
        }
        operatorButton.frame = CGRect(x: self.view.frame.size.width / 2 - 40, y: 210, width: 80, height: 80)
        operatorButton.setImage(UIImage(named: "Operator-Plus"), for: .normal)
        operatorButton.addTarget(self, action: #selector(showOperator), for: .touchUpInside)

        //shuffle button
        //***********************************************************************//
        shuffleButton.setTitle("All Shuffle", for: .normal)
        shuffleButton.frame = CGRect(x: 100, y: 425, width: 200, height: 40)
        shuffleButton.backgroundColor = UIColor.AppColor.buttonColor
        shuffleButton.addTarget(self, action: #selector(shuffleButtonAction), for: .touchUpInside)
        shuffleButton.layer.masksToBounds = true
        shuffleButton.layer.cornerRadius = 5.0
        
        //pickup button
        //***********************************************************************//
        pickupButton.setTitle("Pick Up", for: .normal)
        pickupButton.frame = CGRect(x: 100, y: 500, width: 200, height: 40)
        pickupButton.backgroundColor = UIColor.AppColor.buttonColor
        pickupButton.addTarget(self, action: #selector(setRegistForm), for: .touchUpInside)
        pickupButton.layer.masksToBounds = true
        pickupButton.layer.cornerRadius = 5.0

        //addSubView
        //***********************************************************************//
        self.view.addSubview(operatorButton)
        self.view.addSubview(ideaSlotPickerView)
        self.view.addSubview(ideaSlotPickerView2)
        self.view.addSubview(shuffleButton)
        self.view.addSubview(pickupButton)
//        self.view.addSubview(registForm)
    }
    
    /**
     viewWillAppear
     **/
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarTitle(title: "Idea Slot")
        wordEntities = realm.objects(Words.self).sorted(byKeyPath: "updateDate", ascending: false)
        
        //picker 1
        //***********************************************************************//
        ideaSlotPickerView = setPickerViewData(view: ideaSlotPickerView, setFlg: 0)
        ideaSlotPickerView.pickerViewRows = ideaSlotPickerView.wordNameList!.count * 10
        ideaSlotPickerView.pickerViewMiddle = ideaSlotPickerView.pickerViewRows / 2
        ideaSlotPickerView.wordsPickerView.selectRow(ideaSlotPickerView.pickerViewMiddle, inComponent: 0, animated: false)

        //picker 2
        //***********************************************************************//
        ideaSlotPickerView2 = setPickerViewData(view: ideaSlotPickerView2, setFlg: 0)
        ideaSlotPickerView2.pickerViewRows = ideaSlotPickerView2.wordNameList!.count * 10
        ideaSlotPickerView2.pickerViewMiddle = ideaSlotPickerView2.pickerViewRows / 2
        ideaSlotPickerView2.wordsPickerView.selectRow(ideaSlotPickerView2.pickerViewMiddle, inComponent: 0, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //change operator
    @objc func showOperator() {
        dropdown.show()
    }
    
    //play all shuffle
    @objc func shuffleButtonAction(){
        playSlotPicker(view: ideaSlotPickerView)
        playSlotPicker(view: ideaSlotPickerView2)
    }
    
    @objc func setRegistForm() {
        let ideaRegistFormViewController = IdeaRegistFormViewController()
        print(ideaItem)
        PopupWindowManager.shared.changeKeyWindow(rootViewController: ideaRegistFormViewController)
    }
    
    //create word's name list
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
    
    //set pickerview's property
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
            view.wordsPickerView.selectRow(view.randomNumber(size: view.pickerViewRows), inComponent: 0, animated: false)
        default:
            break
        }
        return view
    }

    //slot animation and get picker's text
    func playSlotPicker(view: IdeaSlotPickerView){
        
        if view.wordNameList!.count > 0 {
            view.wordsPickerView.selectRow(view.randomNumber(size: view.pickerViewRows), inComponent: 0, animated: true)
        }
        let rowWord = view.wordNameList![view.wordsPickerView.selectedRow(inComponent: 0) % view.wordNameList!.count]
        
        //set idea's data
        switch view.slotFlg {
        case 1:
            ideaItem.wordId1 = rowWord
        case 2:
            ideaItem.wordId2 = rowWord
        default:
            break
        }
        
        print(ideaItem)
    }
}
