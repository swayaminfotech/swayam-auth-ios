//
//  ChangePassword.swift
//  Swayam Auth
//
//  Created by S10 on 22/09/20.
//  Copyright © 2020 Swayam Infotech. All rights reserved.
//

import UIKit

class ChangePassword: UIViewController {

    // define outlets for header.
    @IBOutlet var viewHeader: UIView!
    @IBOutlet var lblHeader: UILabel!
    @IBOutlet var btnSideMenu: UIButton!
    @IBOutlet var imgSideMenu: UIImageView!
    @IBOutlet var viewHeaderSeperator: UIView!

    // define outlet for main scrollview.
    @IBOutlet var viewScrollMain: UIScrollView!

    @IBOutlet var viewAuthField: UIView!
    @IBOutlet var lblCurrentPassword: TitleLableForTextField!
    @IBOutlet var txtCurrentPassword: BorderTextField!
    @IBOutlet var lblNewPassword: TitleLableForTextField!
    @IBOutlet var txtNewPassword: BorderTextField!
    @IBOutlet var lblConfirmNewPassword: TitleLableForTextField!
    @IBOutlet var txtConfirmNewPassword: BorderTextField!

    // define outlet for action buttons.
    @IBOutlet var btnChangePassword: AuthButton!

    override func viewDidLayoutSubviews() {

        super.viewDidLayoutSubviews()

        self.viewHeader.frame.size.height = appHeaderHeight
        self.viewHeaderSeperator.backgroundColor = headerSeperatorColor
        self.viewHeader.backgroundColor = headerColor
        self.lblHeader.textColor = theamColor

        self.viewScrollMain.frame.origin.y = appHeaderHeight
        self.viewScrollMain.frame.size.height = screenHeight - appHeaderHeight

        viewScrollMain.contentSize = CGSize(width: screenWidth, height: viewAuthField.getY())
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        // set localized strings for the screen.
        setLocalizedStrings()
    }

    func setLocalizedStrings(){

        lblHeader.text = localize(str: "change_password")
        lblCurrentPassword.text = localize(str: "current_password")
        lblNewPassword.text = localize(str: "new_password")
        lblConfirmNewPassword.text = localize(str: "confirm_new_password")
        btnChangePassword.setTitle(localize(str: "change_password"), for: .normal)
    }

    override func viewWillDisappear(_ animated: Bool) {

        super.viewWillDisappear(animated)
        Alert.shared.hideCustomAlert()
    }

    @IBAction func userHandleAction(_ sender: UIButton) {

        self.view.endEditing(true)

        if sender == btnChangePassword {
            checkValidationsForForgotPassword()
        }else if sender == btnSideMenu {
            SideMenu.showSideMenu()
        }
    }

    func checkValidationsForForgotPassword() {

        var isError = false
        if Util.isStringNull(srcString: txtCurrentPassword.text!) {
            isError = true
            Alert.shared.showCustomAlert(title: localize(str: "current_password_required_title"), description: "current_password_blank")
        }else if Util.isStringNull(srcString: txtNewPassword.text!) {
            isError = true
            Alert.shared.showCustomAlert(title: localize(str: "new_password_required_title"), description: "new_password_blank")
        }else if !Util.isPasswordValid(txtNewPassword.text!) {
            isError = true
            Alert.shared.showCustomAlert(title: localize(str: "new_password_incorrect_title"), description: "new_password_invalid")
        }else if Util.isStringNull(srcString: txtConfirmNewPassword.text!) {
            isError = true
            Alert.shared.showCustomAlert(title: localize(str: "confirm_new_password_required_title"), description: "confirm_new_password_blank")
        }else if !Util.validConfirmpassword(password: txtNewPassword.text!, confirmpassword: txtConfirmNewPassword.text!) {
            isError = true
            Alert.shared.showCustomAlert(title: localize(str: "confirm_new_password_incorrect_title"), description: "confirm_new_password_invalid")
        }

        if !(isError) {
            changePasswordProcess()
        }
    }

    func changePasswordProcess(){

        if (Util.isInternetAvailable()) {

            Loader().showLoader()

            let currentPasswordConverted: String = (txtCurrentPassword.text)!.sha512()
            let newPasswordConverted: String = (txtCurrentPassword.text)!.sha512()

            let parameter: [String: Any] = ["user_id": CurrentUser.sharedInstance.id, "current_password": currentPasswordConverted, "new_password": newPasswordConverted]
            print(parameter)

            ServerAPIs.postRequest(apiUrl: ApiURL().apiChangePassword, parameter) { (response, error, statusCode) in

                Loader().stopLoader()
                print("ChangePassword Response: \(response)")

                if response["success"].stringValue == "yes" {

                    self.txtCurrentPassword.text = ""
                    self.txtNewPassword.text = ""
                    self.txtConfirmNewPassword.text = ""
                    
                    let okAction = UIAlertAction(title: localize(str: "ok_text"), style: .default) { (_) in
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

//MARK:- textfield delegate
extension ChangePassword : UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        Alert.shared.hideCustomAlert()
    }
}
