//
//  SideMenu.swift
//  Swayam Auth
//
//  Created by Swayam Infotech on 19/09/20.
//  Copyright © 2020 Swayam Infotech. All rights reserved.
//

import UIKit
import PINRemoteImage
import StoreKit

class SideMenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // define outlets for sidemenu.
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var tblSideMenu: UITableView!
    @IBOutlet var vwLogout: UIView!
    @IBOutlet var lbllogut: UILabel!
    @IBOutlet var btnlogout: UIButton!

    // define variables
    var menus = [""]
    var menuImages = [""]

    override func viewDidLayoutSubviews() {

        super.viewDidLayoutSubviews()

        if IS_IPHONE_X {
            var contentbtnFrame: CGRect = vwLogout.frame
            contentbtnFrame.origin.y = screenHeight - contentbtnFrame.size.height - 10
            vwLogout.frame = contentbtnFrame

            var contentScrollFrame: CGRect = tblSideMenu.frame
            contentScrollFrame.size.height = screenHeight - contentScrollFrame.origin.y - contentbtnFrame.size.height - 10
            tblSideMenu.frame = contentScrollFrame
        }
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        // set localized strings for the screen.
        setLocalizedStrings()

        // set sidemenu background color to theme color.
        self.view.backgroundColor = theamColor

        // register custom sidemenu cell to sidemenu tableview.
        self.tblSideMenu.register(UINib(nibName: "SideMenuCell", bundle: nil), forCellReuseIdentifier: "SideMenuCell")

        // add right swipe gesture to sidemenu.
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(holeSwiped(gesture:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.left
        self.tblSideMenu.addGestureRecognizer(swipeRight)
    }

    func setLocalizedStrings() {
        lbllogut.text = localize(str: "logout")
    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)

        // to make round corner of profile picture
        profileImage.layer.cornerRadius = profileImage.frame.size.height / 2
        profileImage.layer.borderColor = UIColor.white.cgColor
        profileImage.clipsToBounds = true
        profileImage.contentMode = .scaleAspectFill
        self.profileImage.image = UIImage(named: "sidemenu_profile_placeholder")

        // assign logged in user image to sidemenu.
        if currentUserObj.profilePicture != ""{
            self.profileImage.pin_setImage(from: URL(string: currentUserObj.profilePicture)!, placeholderImage: UIImage(named: "sidemenu_profile_placeholder"), completion: nil)
        }

        // assign logged in user name into sidemenu.
        lblName.text = currentUserObj.fullName
        if Util.isStringNull(srcString: currentUserObj.fullName) {
            lblName.text = localize(str: "company_name")
        }

        // added menus for sidemenu.
        menus = [
            localize(str: "home"),
            localize(str: "edit_profile"),
            localize(str: "change_password"),
            localize(str: "about_us"),
            localize(str: "rate_application"),
            localize(str: "share_application")
        ]

        // added menu images for sidemenu.
        menuImages = [
            "sidemenu_home",
            "sidemenu_profile",
            "sidemenu_change_password",
            "sidemenu_about_us",
            "sidemenu_rate_application",
            "sidemenu_share_application"
        ]

        self.tblSideMenu.reloadData()
    }

    @IBAction func userHandleActions(_ sender: UIButton) {

        self.view.endEditing(true)

        if sender == btnlogout {

            let alert = UIAlertController(title: localize(str: "want_to_logout"), message: nil, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: localize(str: "yes"), style: .default, handler: { action in
                SideMenu.hideSideMenu();
                self.logoutUser()
            }))
            
            alert.addAction(UIAlertAction(title: localize(str: "no"), style: .cancel, handler: { action in
                
            }))
            
            alert.view.tintColor = theamColor
            self.present(alert, animated: true)
        }
    }
    
    @objc func holeSwiped(gesture: UISwipeGestureRecognizer) {
        SideMenu.hideSideMenu();
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseIdentifier: String = "SideMenuCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SideMenuCell
        let todoItem = menus[indexPath.row]
        cell.labelName?.text = todoItem
        cell.icon.frame.origin.y = (cell.bounds.height/2) - (cell.icon.frame.height/2)
        cell.icon.image = UIImage(named: menuImages[indexPath.row])
        cell.icon.image = cell.icon.image?.withRenderingMode(.alwaysTemplate)
        cell.icon.tintColor = theamColor
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        SideMenu.hideSideMenu();

        if indexPath.row == 0 {
            let vc = Util.getStoryboard().instantiateViewController(withIdentifier: "Home") as! Home
            SharedAppDelegate.customNavigationController.pushViewController(vc,animated: false)
        }else if indexPath.row == 1 {
            let vc = Util.getStoryboard().instantiateViewController(withIdentifier: "EditProfile") as! EditProfile
            SharedAppDelegate.customNavigationController.pushViewController(vc,animated: false)
        }else if indexPath.row == 2 {
            let vc = Util.getStoryboard().instantiateViewController(withIdentifier: "ChangePassword") as! ChangePassword
            SharedAppDelegate.customNavigationController.pushViewController(vc,animated: false)
        }else if indexPath.row == 3 {
            let vc = Util.getStoryboard().instantiateViewController(withIdentifier: "AboutUs") as! AboutUs
            SharedAppDelegate.customNavigationController.pushViewController(vc,animated: false)
        }else if indexPath.row == 4 {
            rateApp()
        }else if indexPath.row == 5 {
            shareApp()
        }
    }
    
    func rateApp() {

        let storeVC = SKStoreProductViewController.init()
        storeVC.delegate = self

        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else {
            let iTunesLink = "\(appleStoreApplicationID)"
            if let aLink = URL(string: iTunesLink) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(aLink, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
            }
        }
    }

    func shareApp() {

        let items = [URL(string: "\(String(describing: shareApp))")!]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        self.present(ac, animated: true)
    }

    func logoutUser(){
        
        self.view.endEditing(true)
        if (Util.isInternetAvailable()){
            
            Loader().showLoader()
            
            let parameter: [String: Any] = ["user_id": currentUserObj.id];
            print(parameter)
            
            ServerAPIs.postRequest(apiUrl: ApiURL().apiLogout, parameter, completion: { (response, error, statusCode) in

                Loader().stopLoader()

                let vc = Util.getStoryboard().instantiateViewController(withIdentifier: "Login") as! Login
                SharedAppDelegate.customNavigationController.pushViewController(vc,animated: true)
                
            })
            
        }else{
            Alert.shared.ShowAlert(title: "internet_not_available", message: "", in: self);
        }
    }
}

extension SideMenuVC: SKStoreProductViewControllerDelegate {

    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}
