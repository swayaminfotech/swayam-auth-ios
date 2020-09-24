//
//  AboutUs.swift
//  Swayam Auth
//
//  Created by S10 on 22/09/20.
//  Copyright © 2020 Swayam Infotech. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

class AboutUs: UIViewController {

    // define outlets for header.
    @IBOutlet var viewHeader: UIView!
    @IBOutlet var lblHeader: UILabel!
    @IBOutlet var btnSideMenu: UIButton!
    @IBOutlet var imgSideMenu: UIImageView!
    @IBOutlet var viewHeaderSeperator: UIView!
    
    var strTitle = ""
    var webView = WKWebView()

    override func viewDidLayoutSubviews() {

        super.viewDidLayoutSubviews()

        self.viewHeader.frame.size.height = appHeaderHeight
        webView.frame = CGRect(x: 0, y: appHeaderHeight, width: screenWidth, height: screenHeight - appHeaderHeight)

        self.viewHeaderSeperator.backgroundColor = headerSeperatorColor
        self.viewHeader.backgroundColor = headerColor
        self.lblHeader.textColor = theamColor
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()

        lblHeader.textColor = theamColor
        lblHeader.text = strTitle
        self.view.addSubview(webView)
        webView.navigationDelegate = self

        // get about us description
        getAboutUs()

        // set localized strings for the screen.
        setLocalizedStrings()
    }

    func setLocalizedStrings(){
        lblHeader.text = localize(str: "about_us")
    }

    override func viewWillDisappear(_ animated: Bool) {

        super.viewWillDisappear(animated)
        Loader().stopLoader()
        SVProgressHUD.setDefaultMaskType(.clear)
    }
    
    func getAboutUs() {

        if (Util.isInternetAvailable()) {

            Loader().showLoader()
            SVProgressHUD.setDefaultMaskType(.none)

            ServerAPIs.postRequest(apiUrl: ApiURL().apiAboutUs, [:]) { (response, error, statusCode) in

                if response["success"].stringValue == "yes" {

                    if let data = response["data"].object as? [String:Any] {
                        if let content = data["content"] as? String {
                            self.webView.loadHTMLString(content, baseURL: nil)
                        }
                    }

                }else{
                    Alert.shared.ShowAlert(title: response["message"].stringValue, message: "", in: self)
                }
            }
        }else{
            Alert.shared.ShowAlert(title: "internet_not_available", message: "", in: self);
        }
    }

    @IBAction func userHandleAction(_ sender: UIButton) {

        self.view.endEditing(true)
        if sender == btnSideMenu {
            SideMenu.showSideMenu()
        }
    }
}

extension AboutUs: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        Loader().showLoader()
        SVProgressHUD.setDefaultMaskType(.none)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Loader().stopLoader()
        SVProgressHUD.setDefaultMaskType(.clear)
    }
}
