//
//  ForgotPassword.swift
//  Swayam Auth
//
//  Created by Swayam Infotech on 19/09/20.
//  Copyright © 2020 Swayam Infotech. All rights reserved.
//

import UIKit

class ForgotPassword: UIViewController {

    // define outlets for header.
    @IBOutlet var viewHeader: UIView!
    @IBOutlet var lblHeader: UILabel!
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var imgBack: UIImageView!
    @IBOutlet var viewHeaderSeperator: UIView!

    // define outlet for main scrollview.
    @IBOutlet var viewScrollMain: UIScrollView!

    // define outlets for signup form.
    @IBOutlet var lblEmailTitle: TitleLableForTextField!
    @IBOutlet var txtEmail: BorderTextField!

    // define outlet for action buttons.
    @IBOutlet var btnForgotPassword: AuthButton!

    override func viewDidLayoutSubviews() {

       super.viewDidLayoutSubviews()

       self.lblHeader.textColor = theamColor
       self.viewHeader.frame.size.height = appHeaderHeight
       self.viewHeaderSeperator.backgroundColor = headerSeperatorColor
       self.viewHeader.backgroundColor = headerColor

       self.viewScrollMain.frame.origin.y = appHeaderHeight
       self.viewScrollMain.frame.size.height = screenHeight - appHeaderHeight
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()

        // set localized strings for the screen.
        setLocalizedStrings()
    }

    func setLocalizedStrings(){

        lblHeader.text = localize(str: "forgot_password")
        lblEmailTitle.text = localize(str: "email")
        btnForgotPassword.setTitle(localize(str: "send_mail"), for: .normal)
    }

    @IBAction func userHandeAction(_ sender: UIButton) {

        self.view.endEditing(true)

        if sender == btnForgotPassword {
            checkValidationsForForgotPassword()
        }else if sender == btnBack {
            SharedAppDelegate.customNavigationController.popViewController(animated: true)
        }
    }

    func checkValidationsForForgotPassword() {

        var isError = false
        if Util.isStringNull(srcString: txtEmail.text!) {
            isError = true
            Alert.shared.showCustomAlert(title: localize(str: "email_required_title"), description: "email_blank")
        }else if !Util.validateEmail(enteredEmail: txtEmail.text!) {
            isError = true
            Alert.shared.showCustomAlert(title: localize(str: "email_incorrect_title"), description: "email_invalid")
        }

        if !(isError) {
            self.forgotPasswordProcess()
        }
    }

    func forgotPasswordProcess(){

        if (Util.isInternetAvailable()) {

            Loader().showLoader()
            let parameter: [String: Any] = ["email": txtEmail.text!]

            ServerAPIs.postRequest(apiUrl: ApiURL().apiForgotPassword, parameter) { (response, error, statusCode) in

                Loader().stopLoader()

                if response["success"].stringValue == "yes" {

                    self.txtEmail.text = ""
                    let okAction = UIAlertAction(title: localize(str: "ok_text"), style: .default) { (_) in

                        // to goback to previous screen.
                        SharedAppDelegate.customNavigationController.popViewController(animated: true)
                    }

                    Alert.shared.ShowAlert(title: response["message"].stringValue, message: "", in: self, withAction: [okAction], addCloseAction: false)

                }else{
                    Alert.shared.ShowAlert(title: response["message"].stringValue, message: "", in: self)
                }
            }

        }else{
            Alert.shared.ShowAlert(title: "internet_not_available", message: "", in: self);
        }
    }
}

extension ForgotPassword: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        Alert.shared.hideCustomAlert()
    }
}
