//
//  SideMenuModel.swift
//  Swayam Auth
//
//  Created by Swayam Infotech on 22/09/20.
//  Copyright © 2020 Swayam Infotech. All rights reserved.
//

import Foundation
import UIKit

let SideMenu = SideMenuModel.shared

class SideMenuModel : NSObject {

    private override init() { }
    
    static let shared = SideMenuModel()

    var sideMenuObj = SideMenuVC();
    var sideMenu = UIView();
    var subSideMenu = UIView();
    var overlayButton = UIButton();
    var sideMenuWidth:CGFloat = 270

    func configureSideMenu(){

        if(self.sideMenu != nil){
            self.sideMenu.removeFromSuperview()
        }
        self.sideMenuObj = SideMenuVC.init(nibName: "SideMenuVC", bundle: nil);

        self.sideMenu = UIView(frame:  CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))

        self.sideMenu.backgroundColor = UIColor.clear
        self.sideMenu.isHidden = true;
        SharedAppDelegate.window?.addSubview(self.sideMenu);

        if (IS_IPHONE_X) {
            self.overlayButton = UIButton(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight+40));
        }else{
            self.overlayButton = UIButton(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight));
        }

        self.overlayButton.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5);
        self.overlayButton.addTarget(self, action:#selector(hideSideMenu), for: .touchUpInside);
        self.sideMenu.addSubview(self.overlayButton);

        self.subSideMenu = UIView(frame: CGRect(x: -(sideMenuWidth), y: 0, width: sideMenuWidth, height: screenHeight))
        self.subSideMenu.backgroundColor = UIColor.clear;
        self.sideMenuObj.view.frame = CGRect(x: 0, y: 0, width: self.subSideMenu.frame.size.width, height: screenHeight);
        self.subSideMenu.addSubview(self.sideMenuObj.view);
        self.sideMenu.addSubview(self.subSideMenu);
    }

    @objc func hideSideMenu() {

        self.overlayButton.alpha = 1.0;
        UIView.animate(withDuration: 0.3, animations: {
            var sideMenuFrame: CGRect = self.subSideMenu.frame
            sideMenuFrame.origin.x = -(self.sideMenuWidth)
            self.subSideMenu.frame = sideMenuFrame
            self.overlayButton.alpha = 0.0
        }) { (completion) in
            self.sideMenu.isHidden = true;
        }
    }

    func showSideMenu() {

        self.sideMenu.isHidden = false;
        self.overlayButton.alpha = 0.0;

        let notificationIdentifier: String = "refreshSideMenuNotification"
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationIdentifier), object: nil)

        UIView.animate(withDuration: 0.3) {
            var sideMenuFrame: CGRect = self.subSideMenu.frame
            sideMenuFrame.origin.x = 0
            self.subSideMenu.frame = sideMenuFrame
            self.overlayButton.alpha = 1.0
        }
    }
}
