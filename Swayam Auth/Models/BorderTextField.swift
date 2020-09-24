//
//  BorderTextField.swift
//  Swayam Auth
//
//  Created by Swayam Infotech on 19/09/20.
//  Copyright © 2020 Swayam Infotech. All rights reserved.
//


import Foundation
import UIKit

open class BorderTextField : UITextField {
    
    public override init(frame: CGRect) {

        super.init(frame: frame)
        self.setUpTextField()
    }
    
    public required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        self.setUpTextField()
    }
    
    func setUpTextField() {

        self.borderStyle = .none
        self.borderWidth = 1.0
        self.borderColor = textFieldBorderColor
        self.backgroundColor = textFieldBackgroundColor
        self.font = UIFont(name: fontName.popinRegular, size: 17.0)
        self.leftPadding()
    }
    
    func leftPadding(padding : CGFloat = 10) {

        let vw = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.size.height))
        self.leftView = vw
        self.leftViewMode = .always
    }
    
    func rightPadding(padding : CGFloat = 10) {

        let vw = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.size.height))
        self.rightView = vw
        self.rightViewMode = .always
    }
}

open class BorderTextView : UITextView {

    public required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        self.setUpTextField()
    }
    
    func setUpTextField() {

        self.borderWidth = 1.0
        self.borderColor = textFieldBorderColor
        self.backgroundColor = textFieldBackgroundColor
        self.font = UIFont(name: fontName.popinRegular, size: 17.0)
    }
}

open class TitleLableForTextField : UILabel {

    public override init(frame: CGRect) {

        super.init(frame: frame)
        self.setUpTitleLabel()
    }
    
    public required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        self.setUpTitleLabel()
    }
    
    func setUpTitleLabel() {
        
        self.backgroundColor = .clear
        self.font = UIFont(name: fontName.popinRegular, size: 15.0)
        self.textColor = textFieldPlaceholderColor
    }
}
