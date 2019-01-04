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
        static let width: CGFloat = 200
        static let height: CGFloat = 300
    }
    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
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
            playButton.setTitle("Play", for: .normal)
            playButton.backgroundColor = UIColor.AppColor.buttonColor
            playButton.tintColor = UIColor.AppColor.buttonTextColor
            playButton.layer.cornerRadius = 5.0
            playButton.layer.masksToBounds = true
            playButton.setImage(UIImage(named: "Play"), for: .normal)
        }
    }
    @IBOutlet weak var wordsPickerView: UIPickerView!{
        didSet{
        }
    }
    
    @IBAction func playButtonAction(_ sender: Any) {
        print("tap play button")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        setDropDown(button: categorybutton, dropdown: dropdown)
        wordsPickerView.delegate = self
        wordsPickerView.dataSource = self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return "no list"
    }
}
