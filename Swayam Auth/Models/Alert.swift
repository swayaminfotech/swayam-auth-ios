//
//  Alert.swift
//  Swayam Auth
//
//  Created by Swayam Infotech on 19/09/20.
//  Copyright © 2020 Swayam Infotech. All rights reserved.
//

import Foundation
import UIKit

class Alert : NSObject {

    private override init() { }

    var customAlert = ErrorAlertView()
    static let shared = Alert()
    
    // to show alert with title and message
    func ShowAlert(title: String, message: String, in vc: UIViewController , withAction : [UIAlertAction]? = nil , addCloseAction : Bool = true) {

        let alert = UIAlertController(title: localize(str: title), message: localize(str: message), preferredStyle: UIAlertControllerStyle.alert)

        if addCloseAction {
            alert.addAction(UIAlertAction(title: localize(str: "ok_text"), style: UIAlertActionStyle.default, handler: nil))
        }
        
        if withAction != nil {
            for ac in withAction! {
                alert.addAction(ac)
            }
        }
        alert.view.tintColor = theamColor
        
        if !Util.isStringNull(srcString: title) {
            vc.present(alert, animated: true, completion: nil)
        }
    }

    // configure alert configurations.
    func customeAlertConfigure() {

        Loader().stopLoader()
        customAlert = Bundle.main.loadNibNamed("ErrorAlertView", owner: nil, options: nil)?.first as! ErrorAlertView
        customAlert.frame = CGRect(x: 0, y: -screenHeight, width: screenWidth, height: 120)
        customAlert.autoresizingMask = [.flexibleWidth]
        SharedAppDelegate.window?.addSubview(customAlert)
    }

    // show custom alert with title and description.
    func showCustomAlert(title : String , description : String) {

        customAlert.strErrorTitle = localize(str: title)
        customAlert.strErrorDescripition = localize(str: description)
        customAlert.setUpErrorView()
        SharedAppDelegate.window?.bringSubview(toFront: customAlert)
        self.customAlert.isHidden = false;
        UIView.animate(withDuration: 0.5, animations: {
            if IS_IPHONE_X {
                self.customAlert.frame.origin.y = 35
            }else {
                self.customAlert.frame.origin.y = 25
            }
        })
    }

    // hide alert
    func hideCustomAlert(){

        UIView.animate(withDuration: 0.3, animations: {
            self.customAlert.frame.origin.y = -screenHeight
        }) { (completion) in
            self.customAlert.isHidden = true;
        }
    }
}
