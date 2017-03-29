//
//  LoginViewController.swift
//  Copyright © 2017 Sequencing.com. All rights reserved.
//

import Foundation
import UIKit


class LoginViewController: UIViewController, SQAuthorizationProtocol {
    
    // THESE ARE THE APPLICATION PARAMETERS
    // SPECIFY THEM HERE
    let CLIENT_ID: String       = "oAuth2 Demo ObjectiveC"
    let CLIENT_SECRET: String   = "RZw8FcGerU9e1hvS5E-iuMb8j8Qa9cxI-0vfXnVRGaMvMT3TcvJme-Pnmr635IoE434KXAjelp47BcWsCrhk0g"
    let REDIRECT_URI: String    = "authapp://Default/Authcallback"
    let SCOPE: String           = "demo,external"
    
    let kMainQueue = DispatchQueue.main
    let SELECT_FILES_CONTROLLER_SEGUE_ID = "SELECT_FILES"
    
    let oauthApiHelper = SQOAuth.sharedInstance()
    
    
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // set up loginButton
        let loginButton = UIButton(type: UIButtonType.custom)
        loginButton.setImage(UIImage(named: "button_signin_black"), for: UIControlState())
        loginButton.addTarget(self, action: #selector(self.loginButtonPressed), for: UIControlEvents.touchUpInside)
        loginButton.sizeToFit()
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(loginButton)
        self.view.bringSubview(toFront: loginButton)
        
        // adding constraints for loginButton
        let xCenter = NSLayoutConstraint.init(item: loginButton,
                                              attribute: NSLayoutAttribute.centerX,
                                              relatedBy: NSLayoutRelation.equal,
                                              toItem: self.view,
                                              attribute: NSLayoutAttribute.centerX,
                                              multiplier: 1,
                                              constant: 0)
        let yCenter = NSLayoutConstraint.init(item: loginButton,
                                              attribute: NSLayoutAttribute.centerY,
                                              relatedBy: NSLayoutRelation.equal,
                                              toItem: self.view,
                                              attribute: NSLayoutAttribute.centerY,
                                              multiplier: 1,
                                              constant: 0)
        self.view.addConstraint(xCenter)
        self.view.addConstraint(yCenter)
        
        // REGISTER APPLICATION PARAMETERS
        oauthApiHelper!.registerApplicationParametersCliendID(CLIENT_ID,
                                                             clientSecret: CLIENT_SECRET,
                                                             redirectUri: REDIRECT_URI,
                                                             scope: SCOPE,
                                                             delegate: self,
                                                             viewControllerDelegate: self)
    }
    
    
    
    // MARK: - Actions
    func loginButtonPressed() {
        self.view.isUserInteractionEnabled = false
        oauthApiHelper!.authorizeUser()
    }
        
    
    
    // MARK: - SQAuthorizationProtocolDelegate
    func userIsSuccessfullyAuthorized(_ token: SQToken) -> Void {
        self.kMainQueue.async(execute: { () -> Void in
            print("user Is Successfully Authorized")
            self.view.isUserInteractionEnabled = true
            self.performSegue(withIdentifier: self.SELECT_FILES_CONTROLLER_SEGUE_ID, sender: token)
        })
    }
    
    
    func userIsNotAuthorized() -> Void {
        self.kMainQueue.async {
            print("user is not authorized")
            self.view.isUserInteractionEnabled = true
            self.showAlertWithMessage("Server error\nCan't authorize user")
        }
    }
    
    func userDidCancelAuthorization() -> Void {
        self.kMainQueue.async {
            self.view.isUserInteractionEnabled = true
            print("user Did Cancel Authorization")
        }
    }
    
    
    
    
    
    // MARK: - Allert Message
    func showAlertWithMessage(_ message: NSString) -> Void {
        let alert = UIAlertController(title: nil, message: message as String, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Close", style: .default, handler: nil)
        alert.addAction(closeAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    

}
