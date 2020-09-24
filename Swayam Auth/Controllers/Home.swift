//
//  Home.swift
//  Swayam Auth
//
//  Created by Swayam Infotech on 19/09/20.
//  Copyright © 2020 Swayam Infotech. All rights reserved.
//

import UIKit
import WebKit

class Home: UIViewController {

    // define outlets for header.
    @IBOutlet var viewHeader: UIView!
    @IBOutlet var lblHeader: UILabel!
    @IBOutlet var btnSideMenu: UIButton!
    @IBOutlet var imgSideMenu: UIImageView!
    @IBOutlet var viewHeaderSeperator: UIView!
    var websiteView = WKWebView()

    override func viewDidLayoutSubviews() {

        super.viewDidLayoutSubviews()
        self.lblHeader.textColor = theamColor
        self.viewHeader.frame.size.height = appHeaderHeight
        self.viewHeaderSeperator.backgroundColor = headerSeperatorColor
        self.viewHeader.backgroundColor = headerColor

        websiteView.frame = CGRect(x: 0, y: appHeaderHeight, width: screenWidth, height: screenHeight - appHeaderHeight)
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        // set localized strings for the screen.
        setLocalizedStrings()

        // load website
        loadWebsite()
    }

    func setLocalizedStrings(){
        lblHeader.text = localize(str: "Home")
    }

    func loadWebsite() {

        self.view.addSubview(websiteView)
        websiteView.navigationDelegate = self
        websiteView.uiDelegate = self

        Loader().showLoader()

        let requestUrl = NSURLRequest(url: URL(string: homeScreenWebsite)!)
        websiteView.load(requestUrl as URLRequest)
        websiteView.allowsBackForwardNavigationGestures = true
    }

    @IBAction func userHandeAction(_ sender: UIButton) {

        self.view.endEditing(true)

        if sender == btnSideMenu {
            SideMenu.showSideMenu()
        }
    }
}

extension Home: WKUIDelegate, WKNavigationDelegate {

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Loader().stopLoader()
    }
}
