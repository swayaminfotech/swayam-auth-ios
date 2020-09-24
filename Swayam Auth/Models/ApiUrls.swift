//
//  ApiUrls.swift
//  Swayam Auth
//
//  Created by Swayam Infotech on 19/09/20.
//  Copyright © 2020 Swayam Infotech. All rights reserved.
//


import Foundation

let baseUrl: String           = "{set_your_base_url}"

struct ApiURL {

    let apiLogin:String                       = "\(baseUrl)authentication/login"
    let apiSignUp:String                      = "\(baseUrl)authentication/signup"
    let apiForgotPassword:String              = "\(baseUrl)authentication/forgotPassword"
    let apiChangePassword:String              = "\(baseUrl)authentication/changePassword"
    let apiGetProfile:String                  = "\(baseUrl)authentication/getProfile"
    let apiUpdateProfile:String               = "\(baseUrl)authentication/updateProfile"
    let apiLogout:String                      = "\(baseUrl)authentication/logout"
    let apiAboutUs:String                     = "\(baseUrl)page/aboutUs"
    let apiTermsOfUse:String                  = "\(baseUrl)page/termsofuse"
}
