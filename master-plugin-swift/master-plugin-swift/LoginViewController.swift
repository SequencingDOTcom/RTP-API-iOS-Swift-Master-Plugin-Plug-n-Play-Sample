//
//  LoginViewController.swift
//  Copyright © 2017 Sequencing.com. All rights reserved.
//

import Foundation
import UIKit


class LoginViewController: UIViewController, SQAuthorizationProtocol, UserSignOutProtocol {
    
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
        
        // REGISTER APPLICATION PARAMETERS
        oauthApiHelper!.registerApplicationParametersCliendID(CLIENT_ID,
                                                             clientSecret: CLIENT_SECRET,
                                                             redirectUri: REDIRECT_URI,
                                                             scope: SCOPE,
                                                             delegate: self,
                                                             viewControllerDelegate: self)
    }
    
    
    // MARK: - Actions
    @IBAction func loginButtonPressed(_ sender: Any) {
        self.view.isUserInteractionEnabled = false
        oauthApiHelper!.authorizeUser()
    }
    
    
    @IBAction func registerResetPressed(_ sender: Any) {
        oauthApiHelper!.callRegisterResetAccountFlow()
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
    
    
    func userDidSignOut() -> Void {
        self.dismiss(animated: true, completion: nil)
        
        // Clear out credentials
        let credentialStorage = URLCredentialStorage.shared
        
        for (protectionSpace, credentials) in credentialStorage.allCredentials {
            for (_, credential) in credentials {
                credentialStorage.remove(credential, for: protectionSpace)
            }
        }
        
        // Clear out cookies
        let cookieStorage = HTTPCookieStorage.shared
        cookieStorage.cookies?.forEach { cookieStorage.deleteCookie($0) }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selectNav: UINavigationController = segue.destination as! UINavigationController
        let selectFileVC: SelectFileViewController = selectNav.viewControllers.first as! SelectFileViewController
        
        selectFileVC.delegate = self
    }
    
    
    
    // MARK: - Allert Message
    func showAlertWithMessage(_ message: NSString) -> Void {
        let alert = UIAlertController(title: nil, message: message as String, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Close", style: .default, handler: nil)
        alert.addAction(closeAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    

}
