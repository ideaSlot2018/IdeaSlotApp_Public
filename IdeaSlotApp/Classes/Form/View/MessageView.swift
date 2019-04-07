//
//  MessageView.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2019/03/31.
//  Copyright © 2019年 yuta akazawa. All rights reserved.
//

import UIKit
import PopupWindow

class MessageView: UIView, PopupViewContainable, Nibable {
    enum Const {
        static let height: CGFloat = 80
    }
    enum InfoFlg {
        case info
        case error
    }
    
    enum MessageText {
        static let infoTitle: String = "Successed!"
        static let errorTitle: String = "Error..."
        static var errorMessage: String = "please try again"
    }

    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.layer.cornerRadius = 5.0
            containerView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var title: UILabel!
        {
        didSet{
            title.font = UIFont.systemFont(ofSize: 25.0)
        }
    }
    @IBOutlet weak var message: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.message.textColor = UIColor.white
        self.title.textColor = UIColor.white
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setMessage(title:String, message:String?, infoFlg:InfoFlg) {
        self.title.text = title
        self.message.text = message
        
        switch infoFlg {
        case .info:
            containerView.backgroundColor = UIColor.AppColor.infoColor
        case .error:
            containerView.backgroundColor = UIColor.AppColor.errorColor
        }
    }
}
