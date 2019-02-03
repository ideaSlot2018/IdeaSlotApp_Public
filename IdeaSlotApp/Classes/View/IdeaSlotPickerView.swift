//
//  IdeaSlotPickerView.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2019/01/02.
//  Copyright © 2019年 yuta akazawa. All rights reserved.
//

import UIKit
import DropDown

class IdeaSlotPickerView: UIView {
    enum Const {
        static let width: CGFloat = 190
        static let height: CGFloat = 300
    }
    
    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.frame = CGRect(x: 0, y: 0, width: IdeaSlotPickerView.Const.width, height: IdeaSlotPickerView.Const.height)
        }
    }
    @IBOutlet weak var categoryButton: UIButton!{
        didSet{
            categoryButton.setTitle("All", for: .normal)
            categoryButton.backgroundColor = UIColor.AppColor.buttonColor
            categoryButton.tintColor = UIColor.AppColor.buttonTextColor
            categoryButton.layer.cornerRadius = 5.0
            categoryButton.layer.masksToBounds = true
            categoryButton.titleLabel?.lineBreakMode = .byTruncatingTail
        }
    }
    @IBOutlet weak var playButton: UIButton!{
        didSet{
            playButton.layer.cornerRadius = 5.0
            playButton.layer.masksToBounds = true
            playButton.setImage(UIImage(named: "Play"), for: .normal)
            playButton.imageView?.contentMode = .scaleAspectFit
            playButton.imageView?.tintColor = UIColor.black
        }
    }
    @IBOutlet weak var wordsPickerView: UIPickerView!{
        didSet{
        }
    }
    var categoryButtonTapHandler: (() -> Void)?
    var playButtonTapHandler: (() -> Void)?
    var wordList:Array<Words>? = nil
    var wordNameList:Array<String>? = nil
    var categoryName:String? = nil
    var category:Category? = nil
    
    let dropdown = DropDown()
    let pickerViewRows = 10_000
    var pickerViewMiddle = 0
    
    @IBAction func playButtonAction(_ sender: Any) {
        playButtonTapHandler?()
    }
    @IBAction func showDropDown(_ sender: Any) {
        dropdown.show()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setDropDown(button: categoryButton, dropdown: dropdown)
        wordsPickerView.delegate = self
        wordsPickerView.dataSource = self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setDropDown(button:UIButton, dropdown:DropDown){
        dropdown.anchorView = button
        dropdown.selectionAction = {(index, item) in
            button.setTitle(item, for: .normal)
            self.categoryName = item            
            self.categoryButtonTapHandler?()
        }
    }
    
    func randomNumber(size:Int) -> Int {
        return Int.random(in: 0..<size)
    }
}

extension IdeaSlotPickerView: UIPickerViewDelegate{
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let newRow = pickerViewMiddle + (row % wordNameList!.count)
        pickerView.selectRow(newRow, inComponent: 0, animated: false)
        print("Resetting row to \(newRow)")
    }
}

extension IdeaSlotPickerView: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if wordNameList!.count > 0 {
//            return wordNameList!.count
            return pickerViewRows
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if wordNameList!.count > 0{
            return NSAttributedString(string: valueForRow(row: row), attributes: [NSAttributedString.Key.foregroundColor: UIColor.AppColor.textColor])
        } else {
            return NSAttributedString(string: "\'No List\'", attributes: [NSAttributedString.Key.foregroundColor: UIColor.AppColor.textColor])
        }
    }
    
    func valueForRow(row: Int) -> String {
        // the rows repeat every `pickerViewData.count` items
        return wordNameList![row % wordNameList!.count]
    }
    
    func rowForValue(value: Int) -> Int? {
        if wordNameList!.count > 0 {
            return pickerViewMiddle + value
        }
        return nil
    }
}
