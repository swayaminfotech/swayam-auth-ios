//
//  Util.swift
//  Swayam Auth
//
//  Created by Swayam Infotech on 19/09/20.
//  Copyright © 2020 Swayam Infotech. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import SystemConfiguration
import CoreLocation

class Util: NSObject {
    
    private override init() {
    }

    // shared instance of Util.
    static let sharedInstance: Util = Util()

    // to store device token.
    var deviceToken : String = "IOSBLANKDEVICETOKEN"

    // to store (Google) FCM token.
    var FCMToken : String = "IOSBLANKFCMTOKEN"

    // to identify device type (1-Android, 0-iOS).
    var deviceType : Int = 1

    // to change particular text color of string.
    class func changeTextColor(fullStr: String, str: String,color:UIColor) -> NSAttributedString {
        let AttributeString = NSMutableAttributedString(string: fullStr)
        let ran = (fullStr as NSString).range(of: fullStr)
        AttributeString.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range:ran)
        let range = (fullStr as NSString).range(of: str)
        AttributeString.addAttribute(NSAttributedStringKey.foregroundColor, value: theamColor , range: range)
        AttributeString.addAttribute(NSAttributedStringKey.font, value: UIFont(name: fontName.popinBold, size: 15)!, range: range)
        return AttributeString
    }

    // to validate email address.
    class func validateEmail(enteredEmail:String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }

    // to validate phone number.
    class func validatePhoneNumber(enteredPhonenumber:String) -> Bool {
        let phonenumberFormat = "^[0-9]{10}$"
        let phonePredicate = NSPredicate(format:"SELF MATCHES %@", phonenumberFormat)
        return phonePredicate.evaluate(with: enteredPhonenumber)
    }

    // to convert date format.
    class func convertDate(date:Date, formater:String, to: String) -> Date {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = to
        dateFormater.timeZone = TimeZone.current
        let strDate = dateFormater.string(from: date)
        dateFormater.dateFormat = to
        let dateTemp = dateFormater.date(from: strDate)
        return dateTemp!
    }

    // convert date with particular date formatter.
    class func convertDate(date:Date,to:String) -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = to
        dateFormater.timeZone = TimeZone.current
        let strDate = dateFormater.string(from: date)
        return strDate
    }

    // convert date with particular date formtter with to.
    class func convertDate(date:String,formater:String,to:String) -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = formater
        dateFormater.timeZone = TimeZone.current
        if dateFormater.date(from: date) != nil {
            let date = dateFormater.date(from: date)!
            dateFormater.dateFormat = to
            let strDate = dateFormater.string(from: date)
            return strDate
        }
        return ""
    }

    // to get date from string.
    class func getDateFromString(strDate:String, strFormatter: String) -> Date? {
        let formater = DateFormatter()
        formater.dateFormat = strFormatter
        formater.timeZone = TimeZone.current

        let dateTemp = formater.date(from: strDate)
        let strTempDate = formater.string(from: dateTemp!)
        return formater.date(from: strTempDate)!
    }

    // to check string is null or not.
    class func isStringNull(srcString: String) -> Bool {
        if srcString != "" && srcString !=  "null" && !(srcString == "<null>") && !(srcString == "(null)") && (srcString.count) > 0
        {
            return false
        }
        return true
    }

    // to check is password have valid structure or not.
    class func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{7,}$")
        return passwordTest.evaluate(with: password)
    }

    // to validate entered password with confirmed password.
    class func validConfirmpassword(password : String , confirmpassword : String) -> Bool{

        if(password != confirmpassword){
            return false
        }
        return true
    }

    // to check is internet connectivity is available or not.
    class func isInternetAvailable() -> Bool {

        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }

    // to get particular storyboard name.
    class func getStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }

    // to get used font (with families) in to project.
    class func fontInProject() {
        for family in UIFont.familyNames {
            print("\(family)")
            for name in UIFont.fontNames(forFamilyName: family) {
                print("   \(name)")
            }
        }
    }

    // to get supported mime types of particular asset.
    class func getSupportedFileMIMEType(info: [String : Any], picker: UIImagePickerController) -> String {
        if picker.sourceType == .camera {
            return "image/jpeg"
        }
        if #available(iOS 11.0, *) {
            if let imageURL = info[UIImagePickerControllerImageURL] as? URL {
                
                if !Util.isStringNull(srcString: imageURL.absoluteString) {
                    
                    if imageURL.absoluteString.hasSuffix("PNG") || imageURL.absoluteString.hasSuffix("png"){
                        return "image/png"
                        
                    }else if imageURL.absoluteString.hasSuffix("JPEG") || imageURL.absoluteString.hasSuffix("jpeg"){
                        return "image/jpeg"
                        
                    }else if imageURL.absoluteString.hasSuffix("JPG") || imageURL.absoluteString.hasSuffix("jpg"){
                        return "image/jpeg"
                    }else{
                        return ""
                    }
                }else{
                    return ""
                }
            }else{
                return ""
            }

        }else{

            if let imageURL = info[UIImagePickerControllerReferenceURL] as? URL {
                
                if !Util.isStringNull(srcString: imageURL.absoluteString) {
                    if imageURL.absoluteString.hasSuffix("PNG") || imageURL.absoluteString.hasSuffix("png"){
                        return "image/png"
                    }else if imageURL.absoluteString.hasSuffix("JPEG") || imageURL.absoluteString.hasSuffix("jpeg"){
                        return "image/jpeg"
                    }else if imageURL.absoluteString.hasSuffix("JPG") || imageURL.absoluteString.hasSuffix("jpg"){
                        return "image/jpeg"
                    }else{
                        return ""
                    }
                }else{
                    return ""
                }
                
            }else{
                return ""
            }
        }
    }

    // to print log in to console.
    class func printLog( _ details : Any = "", _ title : String = "") {
        print("\(title) : \(details)")
    }
}
