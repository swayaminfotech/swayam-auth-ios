//
//  SignUp.swift
//  Swayam Auth
//
//  Created by Swayam Infotech on 19/09/20.
//  Copyright © 2020 Swayam Infotech. All rights reserved.
//

import UIKit
import BEMCheckBox
import ActiveLabel

class SignUp: UIViewController {

    // define outlets for header.
    @IBOutlet var viewHeader: UIView!
    @IBOutlet var lblHeader: UILabel!
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var imgBack: UIImageView!
    @IBOutlet var viewHeaderSeperator: UIView!

    // define outlet for main scrollview.
    @IBOutlet var viewScrollMain: UIScrollView!

    @IBOutlet var viewProfileImage: UIView!
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var imgCamera: UIImageView!
    @IBOutlet var btnProfileImage: UIButton!

    // define outlets for signup form.
    @IBOutlet var viewAuthFields: UIView!
    @IBOutlet var lblFirstName: TitleLableForTextField!
    @IBOutlet var txtFirstName: BorderTextField!
    @IBOutlet var lblLastName: TitleLableForTextField!
    @IBOutlet var txtLastName: BorderTextField!
    @IBOutlet var lblEmailTitle: TitleLableForTextField!
    @IBOutlet var txtEmail: BorderTextField!
    @IBOutlet var lblAboutMe:TitleLableForTextField!
    @IBOutlet var txtAboutMe: BorderTextField!
    @IBOutlet var lblGender:TitleLableForTextField!
    @IBOutlet var lblMale:TitleLableForTextField!
    @IBOutlet var checkboxMale: BEMCheckBox!
    @IBOutlet var lblFemale:TitleLableForTextField!
    @IBOutlet var checkboxFemale: BEMCheckBox!
    @IBOutlet var lblPassword: TitleLableForTextField!
    @IBOutlet var txtPassword: BorderTextField!
    @IBOutlet var lblConfirmPassword: TitleLableForTextField!
    @IBOutlet var txtConfirmPassword: BorderTextField!
    @IBOutlet var checkboxTermsOfUse: BEMCheckBox!
    @IBOutlet var lblTermsOfUse: ActiveLabel!

    // define outlet for action buttons.
    @IBOutlet var btnSignup: AuthButton!

    // define variables
    var selectedGender = "" //0 - no selection, 1 - male, 2 - female
    var checkboxGroup = BEMCheckBoxGroup(checkBoxes: [])
    var imagePicker: UIImagePickerController? = UIImagePickerController()
    var strMimeType = "image/jpeg"
    var strFileName = "swift_file.jpeg"

    override func viewDidLayoutSubviews() {

       super.viewDidLayoutSubviews()

       self.lblHeader.textColor = theamColor
       self.viewHeader.frame.size.height = appHeaderHeight
       self.viewHeaderSeperator.backgroundColor = headerSeperatorColor
       self.viewHeader.backgroundColor = headerColor

       self.viewScrollMain.frame.origin.y = appHeaderHeight
       self.viewScrollMain.frame.size.height = screenHeight - appHeaderHeight

       viewScrollMain.contentSize = CGSize(width: screenWidth, height: viewAuthFields.getY())

       // to make round corner of profile picture
       self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.width / 2
       self.imgProfile.clipsToBounds = true
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        // set localized strings for the screen.
        setLocalizedStrings()

        // configure group of checkboxes.
        configureCheckbox()
        
        // configure terms of use
        configureTermsOfUse()
    }

    func setLocalizedStrings(){

        lblHeader.text = localize(str: "signup")
        lblFirstName.text = localize(str: "first_name")
        lblLastName.text = localize(str: "last_name")
        lblEmailTitle.text = localize(str: "email")
        lblAboutMe.text = localize(str: "about_me")
        lblMale.text = localize(str: "male")
        lblFemale.text = localize(str: "female")
        lblGender.text = localize(str: "gender")
        lblPassword.text = localize(str: "password")
        lblConfirmPassword.text = localize(str: "confirm_password")
        btnSignup.setTitle(localize(str: "signup"), for: .normal)
    }

    func configureCheckbox() {

        checkboxGroup = BEMCheckBoxGroup(checkBoxes: [checkboxMale, checkboxFemale])
        //checkboxGroup.selectedCheckBox = checkboxMale
        checkboxGroup.mustHaveSelection = false

        checkboxTermsOfUse.boxType = .square
    }

    func configureTermsOfUse() {

        var strTerms = localize(str: "agree_terms_of_use")
        strTerms = strTerms.replacingOccurrences(of: "****", with: localize(str: "terms_of_use"))
        lblTermsOfUse.text = strTerms

        let customType = ActiveType.custom(pattern: localize(str: "terms_of_use"))
        lblTermsOfUse.enabledTypes.append(customType)
        lblTermsOfUse.customize { label in
            label.customColor[customType] = theamColor
            label.handleCustomTap(for: customType) { _ in
                let vc = Util.getStoryboard().instantiateViewController(withIdentifier: "TermsOfUse") as! TermsOfUse
                vc.strTitle = localize(str: "terms_of_use")
                SharedAppDelegate.customNavigationController.pushViewController(vc, animated: true)
            }
            label.configureLinkAttribute = { (type, attributes, isSelected) in
                var atts = attributes
                atts[NSAttributedStringKey.underlineStyle] = NSUnderlineStyle.styleThick.rawValue
                return atts
            }
        }
    }

    @IBAction func userHandeAction(_ sender: UIButton) {

        self.view.endEditing(true)

        if sender == btnProfileImage {
            openPhotoSelectionOptions()
        }else if sender == btnSignup {
            checkValidationsForSignUp()
        }else if sender == btnBack {
            SharedAppDelegate.customNavigationController.popViewController(animated: true)
        }
    }

    func openPhotoSelectionOptions() {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: localize(str: "close_text"),style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: localize(str: "takePhoto_text"), style: .default, handler: { action in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker?.sourceType = .camera;
                self.imagePicker?.allowsEditing = true
                self.imagePicker?.delegate = self
                self.present(self.imagePicker!
                    , animated: true, completion: nil)
            }else{
                let alrt = UIAlertController(title: localize(str: "camera_not_found"), message: localize(str: "device_no_cemera"), preferredStyle: .alert)
                let ok = UIAlertAction(title: localize(str: "ok_text"), style:.default, handler: nil)
                alrt.addAction(ok)
                alrt.view.tintColor = theamColor
                self.present(alrt, animated: true, completion: nil)
            }
        }))

        alert.addAction(UIAlertAction(title: localize(str: "Choose_photo"), style: .default, handler: { action in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                self.imagePicker?.sourceType = .photoLibrary;
                self.imagePicker?.delegate = self
                self.imagePicker?.allowsEditing = true
                self.present(self.imagePicker!, animated: true, completion: nil)
            }
        }))
        alert.view.tintColor = theamColor

        if  let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = btnProfileImage.frame
        }
        self.present(alert, animated: true)
    }

    func checkValidationsForSignUp() {

        var isError = false
        if Util.isStringNull(srcString: txtFirstName.text!) {
            isError = true
            Alert.shared.showCustomAlert(title: localize(str: "first_name_incorrect"), description: "first_name_blank")
        }else if Util.isStringNull(srcString: txtLastName.text!) {
            isError = true
            Alert.shared.showCustomAlert(title: localize(str: "last_name_incorrect"), description: "last_name_blank")
        }else if Util.isStringNull(srcString: txtEmail.text!) {
            isError = true
            Alert.shared.showCustomAlert(title: localize(str: "email_required_title"), description: "email_blank")
        }else if !Util.validateEmail(enteredEmail: txtEmail.text!) {
            isError = true
            Alert.shared.showCustomAlert(title: localize(str: "email_incorrect_title"), description: "email_invalid")
        }else if Util.isStringNull(srcString: txtAboutMe.text!) {
            isError = true
            Alert.shared.showCustomAlert(title: localize(str: "aboutme_required_title"), description: "aboutme_blank")
        }else if Util.isStringNull(srcString: txtPassword.text!) {
            isError = true
            Alert.shared.showCustomAlert(title: localize(str: "password_required_title"), description: "password_blank")
        }else if !Util.isPasswordValid(txtPassword.text!) {
            isError = true
            Alert.shared.showCustomAlert(title: localize(str: "password_incorrect_title"), description: "password_invalid")
        }else if Util.isStringNull(srcString: txtConfirmPassword.text!) {
            isError = true
            Alert.shared.showCustomAlert(title: localize(str: "confirm_password_required_title"), description: "confirm_password_blank")
        }else if !Util.validConfirmpassword(password: txtPassword.text!, confirmpassword: txtConfirmPassword.text!) {
            isError = true
            Alert.shared.showCustomAlert(title: localize(str: "confirm_password_incorrect_title"), description: "confirm_password_invalid")
        }else if checkboxTermsOfUse.on == false {
            isError = true
            Alert.shared.showCustomAlert(title: localize(str: "terms_of_use_required"), description: localize(str: "terms_of_use_blank"))
        }
        
        if !(isError) {
            self.signupProcess()
        }
    }

    func signupProcess(){

        if (Util.isInternetAvailable()) {

            Loader().showLoader()

            // convert password to sha512
            let passwordConvert: String = (txtPassword.text)!.sha512()
            
            let parameter: [String: Any] = [
                "first_name": txtFirstName.text!,
                "last_name": txtLastName.text!,
                "email": txtEmail.text!,
                "password": passwordConvert,
                "device_type": Util.sharedInstance.deviceType ,
                "device_token": Util.sharedInstance.FCMToken,
                "user_id": CurrentUser.sharedInstance.id,
                "gender": selectedGender
            ]

            ServerAPIs.postRequest(apiUrl: ApiURL().apiSignUp, parameter) { (response, error, statusCode) in

                Loader().stopLoader()

                if response["success"].stringValue == "yes" {

                    if let data = response["data"].object as? [String: Any] {

                        // store response into usermodel.
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

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Alert.shared.hideCustomAlert()
    }
}

extension SignUp: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        Alert.shared.hideCustomAlert()
    }
}

extension SignUp: BEMCheckBoxDelegate {

    func didTap(_ checkBox: BEMCheckBox) {

        selectedGender = "0"
        if checkboxGroup.selectedCheckBox == checkboxMale {
            selectedGender = "1"
        }else if checkboxGroup.selectedCheckBox == checkboxFemale {
            selectedGender = "2"
        }
    }
}

extension SignUp: UIImagePickerControllerDelegate , UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){

        if let pickedImg = info[UIImagePickerControllerEditedImage] as? UIImage {

            let fileMIMEType = "\(Util.getSupportedFileMIMEType(info: info, picker: picker))"

            if Util.isStringNull(srcString: fileMIMEType) {
                dismiss(animated: true, completion: nil)
                Alert.shared.ShowAlert(title: localize(str: "file_format_not_support"), message: localize(str: "file_format_alert"), in: self)
                return
            }

            self.imgProfile.contentMode = .scaleAspectFill
            self.imgProfile.image = pickedImg
            //self.isImageChange = true

            self.imgProfile.borderColor = theamColor
            self.imgProfile.borderWidth = 1.0
        }
        dismiss(animated: true, completion: nil)
    }
}
