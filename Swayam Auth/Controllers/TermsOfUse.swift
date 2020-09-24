//
//  TermsOfUse.swift
//  Swayam Auth
//
//  Created by S10 on 22/09/20.
//  Copyright © 2020 Swayam Infotech. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

class TermsOfUse: UIViewController {

    // define outlets for header.
    @IBOutlet var viewHeader: UIView!
    @IBOutlet var lblHeader: UILabel!
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var imgBack: UIImageView!
    @IBOutlet var viewHeaderSeperator: UIView!

    // define variables
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

        lblHeader.text = strTitle
        self.view.addSubview(webView)
        webView.navigationDelegate = self

        // get terms of use description
        getTermsOfUse()

        // set localized strings for the screen.
        setLocalizedStrings()
    }

    override func viewWillDisappear(_ animated: Bool) {

        super.viewWillDisappear(animated)
        Loader().stopLoader()
        SVProgressHUD.setDefaultMaskType(.clear)
    }

    func getTermsOfUse() {

        if (Util.isInternetAvailable()) {

            Loader().showLoader()
            SVProgressHUD.setDefaultMaskType(.none)

            ServerAPIs.postRequest(apiUrl: ApiURL().apiTermsOfUse, [:]) { (response, error, statusCode) in

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

    func setLocalizedStrings(){
        lblHeader.text = localize(str: "terms_of_use")
    }

    @IBAction func userHandleAction(_ sender: UIButton) {

        self.view.endEditing(true)
        if sender == btnBack {
            SharedAppDelegate.customNavigationController.popViewController(animated: true)
        }
    }
}

extension TermsOfUse: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        Loader().showLoader()
        SVProgressHUD.setDefaultMaskType(.none)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Loader().stopLoader()
        SVProgressHUD.setDefaultMaskType(.clear)
    }
}
