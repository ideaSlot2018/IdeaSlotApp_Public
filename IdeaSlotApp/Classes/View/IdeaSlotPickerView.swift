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
    var playImage = UIImageView(image: UIImage(named: "Play")){
        didSet{
            playImage.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        }
    }
    @IBOutlet weak var playButton: UIButton!{
        didSet{
//            playButton.setImage(UIImage(named: "Play"), for: .normal)
            playButton.imageView?.contentMode = .scaleAspectFit
            playButton.backgroundColor = UIColor.AppColor.buttonColor
            playButton.layer.cornerRadius = 5.0
            playButton.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var wordsPickerView: UIPickerView!{
        didSet{
            wordsPickerView.layer.borderWidth = 0.5
            wordsPickerView.layer.borderColor = UIColor.AppColor.buttonTextColor.cgColor
        }
    }
    var categoryButtonTapHandler: (() -> Void)?
    var playButtonTapHandler: (() -> Void)?
    var wordList:Array<Words>? = nil
    var wordNameList:Array<String>? = nil
    var categoryName:String? = nil
    var category:Category? = nil
    
    let dropdown = DropDown()
    
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
}

extension IdeaSlotPickerView: UIPickerViewDelegate{
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(pickerView)
    }
}

extension IdeaSlotPickerView: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if wordNameList!.count > 0 {
            return wordNameList!.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if wordNameList!.count > 0 {
            return wordNameList![row]
        } else {
            return "No List"
        }
    }
}
