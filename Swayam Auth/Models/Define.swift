//
//  Define.swift
//  Swayam Auth
//
//  Created by Swayam Infotech on 19/09/20.
//  Copyright © 2020 Swayam Infotech. All rights reserved.
//

import Foundation
import UIKit

// to get screen height and width.
let screenHeight = UIScreen.main.bounds.size.height
let screenWidth =  UIScreen.main.bounds.size.width

// to identify particular device.
let IS_IPAD = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad
let IS_IPHONE = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone
let IS_IPHONE_5 = IS_IPHONE && UIScreen.main.bounds.size.height == 568.0
let IS_IPHONE_6 = IS_IPHONE && UIScreen.main.bounds.size.height == 667.0
let IS_IPHONE_6_PLUS = IS_IPHONE && UIScreen.main.bounds.size.height == 736.0
let IS_IPHONE_4 = IS_IPHONE && UIScreen.main.bounds.size.height == 480.0
let IS_IPHONE_X = IS_IPHONE && (UIScreen.main.bounds.size.height == 812.0 || UIScreen.main.bounds.size.height == 896.0)

// to change apperiance of UI.
let theamColor = UIColor(red: 254.0/255.0, green: 91.0/255.0, blue: 91.0/255.0, alpha: 1)
let buttonTextColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
let textFieldBorderColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1)
let textFieldBackgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
let textFieldPlaceholderColor = UIColor(red: 59/255, green: 65/255, blue: 83/255, alpha: 1)//3b4153
let headerSeperatorColor = UIColor(red: 178/255, green: 178/255, blue: 178/255, alpha: 0.5)
let headerColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)

// to set application header height.
let appCustomHeaderHeight : CGFloat = (IS_IPHONE_X) ? 84 : 64

// to set font programitically.
let fontName = fontNames()
struct fontNames {
    
    let popinBlackItalic        =  "Poppins-BlackItalic"
    let popinExtraLight         =  "Poppins-ExtraLight"
    let popinExtraLightItalic   =  "Poppins-ExtraLightItalic"
    let popinExtraBold          =  "Poppins-ExtraBold"
    let popinBold               =  "Poppins-Bold"
    let popinLight              = "Poppins-Light"
    let popinExtraBoldItalic    =  "Poppins-ExtraBoldItalic"
    let popinItalic             = "Poppins-Italic"
    let popinThinItalic         = "Poppins-ThinItalic"
    let popinLightItalic        = "Poppins-LightItalic"
    let popinBlack              = "Poppins-Black"
    let popinMedium             = "Poppins-Medium"
    let popinBoldItalic         = "Poppins-BoldItalic"
    let popinSemiBold           = "Poppins-SemiBold"
    let popinRegular            = "Poppins-Regular"
    let popinThin               = "Poppins-Thin"
    let popinSemiBoldItalic     = "Poppins-SemiBoldItalic"
    let popinMediumItalic       = "Poppins-MediumItalic"
}

// to set localizable string into project.
public func localize(str: String) -> String{
    return String.localizedStringWithFormat(NSLocalizedString(str, comment: ""))
}

// to share and rate app set your appstore id
let appleStoreApplicationID = ""
let shareAppURL = "https://apps.apple.com/in/app/{your-appstore-url-name}/id\(appleStoreApplicationID)"

// home screen website
let homeScreenWebsite = "https://www.swayaminfotech.com/"
