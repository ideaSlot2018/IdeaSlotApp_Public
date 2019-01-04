//
//  IdeasSlotViewController.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/09/27.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import UIKit
import RealmSwift

class IdeasSlotViewController: UIViewController {
    enum Operators {
        case plus
        case minus
        case multiply
        case division
    }

    var wordEntities:Results<Words>? = nil
    var ideaSlotPickerView = IdeaSlotPickerView()
    var ideaSlotPickerView2 = IdeaSlotPickerView()

    let realm = try!Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ideaSlotPickerView = UINib(nibName: "IdeaSlotPickerView", bundle: Bundle(for: type(of: self))).instantiate(withOwner: self, options: nil).first! as! IdeaSlotPickerView
        ideaSlotPickerView.frame = CGRect(x: 0, y: 100, width: IdeaSlotPickerView.Const.width, height: IdeaSlotPickerView.Const.height)
        
        ideaSlotPickerView2 = UINib(nibName: "IdeaSlotPickerView", bundle: Bundle(for: type(of: self))).instantiate(withOwner: self, options: nil).first! as! IdeaSlotPickerView
        ideaSlotPickerView2.frame = CGRect(x: self.view.frame.width - 200, y: 100, width: IdeaSlotPickerView.Const.width, height: IdeaSlotPickerView.Const.height)
        
        self.view.addSubview(ideaSlotPickerView)
        self.view.addSubview(ideaSlotPickerView2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarTitle(title: "Idea Slot")

        wordEntities = realm.objects(Words.self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func arrayWordList(categoryId: Int) -> Array<String> {
        var wordNameList:[String] = []
        if categoryId != 0 {
            wordEntities = wordEntities!.filter("categoryId == %@", categoryId)
        }
        
        for word in wordEntities!{
            wordNameList.append(word.word!)
        }
        return wordNameList
    }

}

//extension IdeasSlotViewController: UIPickerViewDelegate{
//    
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        print(pickerView)
//    }
//}

//extension IdeasSlotViewController: UIPickerViewDataSource{
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return "no list"
//    }
//
//}
