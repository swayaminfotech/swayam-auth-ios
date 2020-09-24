//
//  Login.swift
//  Swayam Auth
//
//  Created by Swayam Infotech on 19/09/20.
//  Copyright © 2020 Swayam Infotech. All rights reserved.
//

import UIKit
import CryptoSwift

class Login: UIViewController {

    // define outlets for main screen scrollview.
    @IBOutlet var viewScrollMain: UIScrollView!
    @IBOutlet var imgLogo: UIImageView!
    @IBOutlet var viewAuthField: UIView!

    // define outlets for login form.
    @IBOutlet var lblEmailTitle: TitleLableForTextField!
    @IBOutlet var txtEmail: BorderTextField!
    @IBOutlet var lblPassword: TitleLableForTextField!
    @IBOutlet var txtPassword: BorderTextField!

    // define outlets for action buttons.
    @IBOutlet var btnForgotPassword: UIButton!
    @IBOutlet var btnRegister: UIButton!
    @IBOutlet var btnLogin: AuthButton!

    override func viewDidLayoutSubviews() {

        super.viewDidLayoutSubviews()
        self.viewScrollMain.frame.origin.y = appHeaderHeight
        self.viewScrollMain.frame.size.height = screenHeight - appHeaderHeight
        viewScrollMain.contentSize = CGSize(width: screenWidth, height: viewAuthField.getY())
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        // set localized strings for the screen.
        setLocalizedStrings()

        // for logo animation
        startLogoAnimation()
    }

    func startLogoAnimation() {

        lblEmailTitle.isHidden = true
        txtEmail.isHidden = true
        lblPassword.isHidden = true
        txtPassword.isHidden = true
        btnForgotPassword.isHidden = true
        btnLogin.isHidden = true
        btnRegister.isHidden = true
        imgLogo.alpha = 0.0

        UIView.animate(withDuration: 1.0, delay: 1, options: .curveEaseIn, animations: {

            self.imgLogo.alpha = 1.0
            self.imgLogo.frame.origin.y = self.lblEmailTitle.frame.origin.y - 160

        }) { _ in

            self.lblEmailTitle.isHidden = false
            self.txtEmail.isHidden = false
            self.lblPassword.isHidden = false
            self.txtPassword.isHidden = false
            self.btnForgotPassword.isHidden = false
            self.btnLogin.isHidden = false
            self.btnRegister.isHidden = false
        }
    }

    func setLocalizedStrings(){

        lblEmailTitle.text = localize(str: "email")
        lblPassword.text = localize(str: "password")
        btnForgotPassword.setTitle(localize(str: "forgot_password"), for: .normal)
        btnLogin.setTitle(localize(str: "login"), for: .normal)
        btnRegister.setTitle(localize(str: "dont_have_account"), for: .normal)
    }

    override func viewWillDisappear(_ animated: Bool) {

        super.viewWillDisappear(animated)
        Alert.shared.hideCustomAlert()
    }

    @IBAction func userHandleAction(_ sender: UIButton) {

        self.view.endEditing(true)

        if sender == btnLogin {
            checkValidationsForLogin()
        }else if sender == btnRegister {
            let vc = Util.getStoryboard().instantiateViewController(withIdentifier: "SignUp") as! SignUp
            SharedAppDelegate.customNavigationController.pushViewController(vc, animated: true)
        }else if sender == btnForgotPassword {
            let vc = Util.getStoryboard().instantiateViewController(withIdentifier: "ForgotPassword") as! ForgotPassword
            SharedAppDelegate.customNavigationController.pushViewController(vc, animated: true)
        }
    }

    func checkValidationsForLogin() {

        var isError = false
        if Util.isStringNull(srcString: txtEmail.text!) {
            isError = true
            Alert.shared.showCustomAlert(title: localize(str: "email_required_title"), description: "email_blank")
        }else if !Util.validateEmail(enteredEmail: txtEmail.text!) {
            isError = true
            Alert.shared.showCustomAlert(title: localize(str: "email_incorrect_title"), description: "email_invalid")
        }else if Util.isStringNull(srcString: txtPassword.text!) {
            isError = true
            Alert.shared.showCustomAlert(title: localize(str: "password_required_title"), description: "password_blank")
        }
        
        if !(isError) {

            //self.loginProcess()
            let vc = Util.getStoryboard().instantiateViewController(withIdentifier: "Home") as! Home
            SharedAppDelegate.customNavigationController.pushViewController(vc, animated: true)
        }
    }

    func loginProcess(){

        if (Util.isInternetAvailable()) {

            Loader().showLoader()

            // convert password to sha512
            let passwordConvert: String = (txtPassword.text)!.sha512()

            let parameter: [String: Any] = ["email": txtEmail.text! as String, "password": passwordConvert, "device_type" : Util.sharedInstance.deviceType , "device_token" : Util.sharedInstance.FCMToken];

            ServerAPIs.postRequest(apiUrl: ApiURL().apiLogin, parameter) { (response, error, statusCode) in

                Loader().stopLoader()

                if response["success"].stringValue == "yes" {

                    if let data = response["data"].object as? [String: Any] {

                        // store response into usermodel
                        currentUserObj.SetAndGetValue(data: data, isEdit: true)
                        
                        // redirect to home screen
                        let vc = Util.getStoryboard().instantiateViewController(withIdentifier: "Home") as! Home
                        SharedAppDelegate.customNavigationController.pushViewController(vc, animated: true)
                    }

                }else{
                    Alert.shared.ShowAlert(title: response["message"].stringValue, message: "", in: self)
                }
            }

        }else{
            Alert.shared.ShowAlert(title: "internet_not_available", message: "", in: self);
        }
    }
}

extension Login: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        Alert.shared.hideCustomAlert()
    }
}
