//
//  EditProfile.swift
//  Swayam Auth
//
//  Created by Swayam Infotech on 19/09/20.
//  Copyright © 2020 Swayam Infotech. All rights reserved.
//

import UIKit
import BEMCheckBox
import ActiveLabel

class EditProfile: UIViewController {

    // define outlets for header.
    @IBOutlet var viewHeader: UIView!
    @IBOutlet var lblHeader: UILabel!
    @IBOutlet var btnSideMenu: UIButton!
    @IBOutlet var imgSideMenu: UIImageView!
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

    // define outlet for action buttons.
    @IBOutlet var btnSave: AuthButton!

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

        // get user profile
        getUserProfile()
    }

    func setLocalizedStrings(){

        lblHeader.text = localize(str: "edit_profile")
        lblFirstName.text = localize(str: "first_name")
        lblLastName.text = localize(str: "last_name")
        lblEmailTitle.text = localize(str: "email")
        lblAboutMe.text = localize(str: "about_me")
        lblMale.text = localize(str: "male")
        lblFemale.text = localize(str: "female")
        lblGender.text = localize(str: "gender")
    }

    func configureCheckbox() {

        checkboxGroup = BEMCheckBoxGroup(checkBoxes: [checkboxMale, checkboxFemale])
        //checkboxGroup.selectedCheckBox = checkboxMale
        checkboxGroup.mustHaveSelection = false
    }

    func getUserProfile(){

        if (Util.isInternetAvailable()) {

            Loader().showLoader()

            let parameter: [String: Any] = ["user_id": CurrentUser.sharedInstance.id];

            ServerAPIs.postRequest(apiUrl: ApiURL().apiGetProfile, parameter) { (response, error, statusCode) in

                Loader().stopLoader()
                print("Login Response: \(response)")

                if response["success"].stringValue == "yes" {

                    if let data = response["data"].object as? [String: Any] {
                        currentUserObj.SetAndGetValue(data: data, isEdit: true)
                        self.reloadScreenData()
                    }

                }else{
                    Alert.shared.ShowAlert(title: response["message"].stringValue, message: "", in: self)
                }
            }
        }else{
            Alert.shared.ShowAlert(title: "internet_not_available", message: "", in: self);
        }
    }

    func reloadScreenData() {

        self.txtEmail.text = CurrentUser.sharedInstance.email
        self.txtFirstName.text = CurrentUser.sharedInstance.firstName
        self.txtLastName.text = CurrentUser.sharedInstance.lastName
        self.txtAboutMe.text = CurrentUser.sharedInstance.abountMe

        self.imgProfile.image = UIImage(named: "profile_placeholder")
        if let urlProfile = URL(string: CurrentUser.sharedInstance.profilePicture) {
            self.imgProfile.pin_setImage(from: urlProfile)
        }
    }

    @IBAction func userHandeAction(_ sender: UIButton) {

        self.view.endEditing(true)

        if sender == btnProfileImage {
            openPhotoSelectionOptions()
        }else if sender == btnSave {
            checkValidationsForSignUp()
        }else if sender == btnSideMenu {
            SideMenu.showSideMenu()
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

        //for iPad actionSheet
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
        }
        
        if !(isError) {
            self.editProfileProcess()
        }
    }

    func editProfileProcess(){

        if (Util.isInternetAvailable()) {

            Loader().showLoader()

            let parameter: [String: Any] = [
                "first_name": txtFirstName.text!,
                "last_name": txtLastName.text!,
                "email": txtEmail.text!,
                "device_type": Util.sharedInstance.deviceType ,
                "device_token": Util.sharedInstance.FCMToken,
                "user_id": CurrentUser.sharedInstance.id,
                "gender": selectedGender,
                "id": currentUserObj.id
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

extension EditProfile: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        Alert.shared.hideCustomAlert()
    }
}

extension EditProfile: BEMCheckBoxDelegate {

    func didTap(_ checkBox: BEMCheckBox) {

        selectedGender = "0"
        if checkboxGroup.selectedCheckBox == checkboxMale {
            selectedGender = "1"
        }else if checkboxGroup.selectedCheckBox == checkboxFemale {
            selectedGender = "2"
        }
    }
}

extension EditProfile: UIImagePickerControllerDelegate , UINavigationControllerDelegate {

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

            self.imgProfile.borderColor = theamColor
            self.imgProfile.borderWidth = 1.0
        }
        dismiss(animated: true, completion: nil)
    }
}
