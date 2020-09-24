//
//  CurrentUser.swift
//  Swayam Auth
//
//  Created by Swayam Infotech on 19/09/20.
//  Copyright © 2020 Swayam Infotech. All rights reserved.
//

import UIKit
import SwiftyJSON


enum Gender : Int {
    case male = 1
    case female = 2
    case other = 3
}
var currentUserObj = CurrentUser()

class CurrentUser : NSObject {

    static let sharedInstance: CurrentUser = CurrentUser()
    var id : Int = 0
    var fullName : String = ""
    var firstName : String = ""
    var lastName : String = ""
    var email : String = ""
    var password : String = ""
    var profilePicture : String = ""
    var profilePictureThumb : String = ""
    var abountMe = ""
    var gender : Gender = .male

    var session: [String: Any]? {
        get {
            let localStorage = UserDefaults.standard
            if let userSession = localStorage.dictionary(forKey: "UserSession") {
                return userSession as [String : Any]
            }else{
                return nil
            }
        }
    }

    override init() { }

    class func isLogin() -> Bool {
        if (UserDefaults.standard.value(forKey: "UserSession") != nil){
            return true
        }
        return false
    }

    func SetAndGetValue(data: [String:Any],isEdit:Bool) {

        if let value = data["user_id"] as? Int {
            CurrentUser.sharedInstance.id = value
        }
        if let value = data["full_name"] as? String {
            CurrentUser.sharedInstance.fullName = value
        }
        if let value = data["first_name"] as? String {
            CurrentUser.sharedInstance.firstName = value
        }
        if let value = data["last_name"] as? String {
            CurrentUser.sharedInstance.lastName = value
        }
        if let value = data["email"] as? String {
            CurrentUser.sharedInstance.email = value
        }
        if let value = data["profile_picture"] as? String {
            CurrentUser.sharedInstance.profilePicture = value
        }
        if let value = data["profile_thumb"] as? String {
            CurrentUser.sharedInstance.profilePictureThumb   = value
        }
        if let value = data["about_me"] as? String {
            CurrentUser.sharedInstance.abountMe = value
        }


        if isEdit {
            let userdata : [String : Any] = [
                "user_id": CurrentUser.sharedInstance.id,
                "email": CurrentUser.sharedInstance.email,
                "full_name": CurrentUser.sharedInstance.fullName,
                "first_name": CurrentUser.sharedInstance.firstName,
                "last_name": CurrentUser.sharedInstance.lastName,
                "profile_picture": CurrentUser.sharedInstance.profilePicture,
                "profile_thumb": CurrentUser.sharedInstance.profilePictureThumb,
                "about_me": CurrentUser.sharedInstance.abountMe]

            UserDefaults.standard.setValue(userdata, forKey: "UserSession")
        }
    }

    func updateSingleParameter(key:String, value : Any , data:[String:Any]?){

        if var singleObj = data {
            singleObj.updateValue(value, forKey: key)
            currentUserObj.SetAndGetValue(data: singleObj, isEdit: true)
        }
    }

    func logOut(){

        CurrentUser.sharedInstance.id = 0
        CurrentUser.sharedInstance.fullName = ""
        CurrentUser.sharedInstance.email = ""
        CurrentUser.sharedInstance.firstName = ""
        CurrentUser.sharedInstance.lastName = ""
        CurrentUser.sharedInstance.profilePicture = ""
        CurrentUser.sharedInstance.profilePictureThumb = ""
        CurrentUser.sharedInstance.abountMe = ""

        SetAndGetValue(data: [:],isEdit:true)
        UserDefaults.standard.removeObject(forKey: "UserSession")
    }

    func logoutProcess(vc : UIViewController){

        if (Util.isInternetAvailable()) {

            let parameter: [String: Any] = ["user_id": CurrentUser.sharedInstance.id];
            ServerAPIs.postRequest(apiUrl: ApiURL().apiLogout, parameter) { (response, error, statusCode) in
                Loader().stopLoader()
                Util.printLog("Login Response: \(response)")
                currentUserObj.logOut()
            }
        }
        currentUserObj.logOut()

        let vc = Util.getStoryboard().instantiateViewController(withIdentifier: "Login") as! Login
        SharedAppDelegate.customNavigationController.pushViewController(vc, animated: true)
    }
}
