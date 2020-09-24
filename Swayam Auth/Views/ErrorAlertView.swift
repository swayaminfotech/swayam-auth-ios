//
//  ErrorAlertView.swift
//  Swayam Auth
//
//  Created by Swayam Infotech on 19/09/20.
//  Copyright © 2020 Swayam Infotech. All rights reserved.
//

import UIKit

class ErrorAlertView: UIView {
    
    var imgErrorBg = UIImageView()

    @IBOutlet var imgErrorBG: UIImageView!
    @IBOutlet var imgError: UIImageView!
    @IBOutlet var lblErrorTitle: UILabel!
    @IBOutlet var lblErrorDescription: UILabel!
        
    var strErrorTitle  = ""
    var strErrorDescripition  = ""
    var timer : Timer = Timer()

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setUpErrorView() {
        
        self.lblErrorTitle.text = self.strErrorTitle
        self.lblErrorDescription.text = self.strErrorDescripition
        
        self.lblErrorTitle.sizeToFit()
        self.lblErrorDescription.sizeToFit()
        self.lblErrorTitle.frame.size.width = screenWidth - 147
        self.lblErrorDescription.frame.size.width = screenWidth - 147
        
        self.lblErrorDescription.frame.origin.y = lblErrorTitle.getY() + 10
        self.frame.size.height = lblErrorDescription.getY() + 38
        
        timer.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.closeTime), userInfo: nil, repeats: false)
    }
    
    @objc func closeTime(){
        Alert.shared.hideCustomAlert()
    }
}


