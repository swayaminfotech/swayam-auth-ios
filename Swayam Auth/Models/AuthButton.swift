//
//  AuthButton.swift
//  Swayam Auth
//
//  Created by Swayam Infotech on 19/09/20.
//  Copyright © 2020 Swayam Infotech. All rights reserved.
//


import Foundation
import UIKit

@IBDesignable
open class AuthButton : UIButton {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpAuthButton()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUpAuthButton()
    }
    
    func setUpAuthButton() {
        self.backgroundColor = theamColor
        self.setTitleColor(buttonTextColor, for: .normal)
        self.cornerRadius = self.frame.size.height/2
    }
}
