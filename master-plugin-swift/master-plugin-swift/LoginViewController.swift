//
//  LoginViewController.swift
//  Copyright © 2016 Sequencing.com. All rights reserved.
//

import Foundation
import UIKit

// ADD THIS POD IMPORT
import sequencing_oauth_api_swift


class LoginViewController: UIViewController, SQAuthorizationProtocolDelegate {
    
    
    // THESE ARE THE APPLICATION PARAMETERS
    // SPECIFY THEM HERE
    let CLIENT_ID: String       = "oAuth2 Demo ObjectiveC"
    let CLIENT_SECRET: String   = "RZw8FcGerU9e1hvS5E-iuMb8j8Qa9cxI-0vfXnVRGaMvMT3TcvJme-Pnmr635IoE434KXAjelp47BcWsCrhk0g"
    let REDIRECT_URI: String    = "authapp://Default/Authcallback"
    let SCOPE: String           = "demo,external"
    
    let kMainQueue = dispatch_get_main_queue()
    let SELECT_FILES_CONTROLLER_SEGUE_ID = "SELECT_FILES"
    
    
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // set up loginButton
        let loginButton = UIButton(type: UIButtonType.Custom)
        loginButton.setImage(UIImage(named: "button_signin_white_gradation"), forState: UIControlState.Normal)
        loginButton.addTarget(self, action: #selector(self.loginButtonPressed), forControlEvents: UIControlEvents.TouchUpInside)
        loginButton.sizeToFit()
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(loginButton)
        self.view.bringSubviewToFront(loginButton)
        
        // adding constraints for loginButton
        let xCenter = NSLayoutConstraint.init(item: loginButton,
                                              attribute: NSLayoutAttribute.CenterX,
                                              relatedBy: NSLayoutRelation.Equal,
                                              toItem: self.view,
                                              attribute: NSLayoutAttribute.CenterX,
                                              multiplier: 1,
                                              constant: 0)
        let yCenter = NSLayoutConstraint.init(item: loginButton,
                                              attribute: NSLayoutAttribute.CenterY,
                                              relatedBy: NSLayoutRelation.Equal,
                                              toItem: self.view,
                                              attribute: NSLayoutAttribute.CenterY,
                                              multiplier: 1,
                                              constant: 0)
        self.view.addConstraint(xCenter)
        self.view.addConstraint(yCenter)
        
        // REGISTER APPLICATION PARAMETERS
        SQOAuth.instance.registrateApplicationParametersClientID(CLIENT_ID,
                                                                 ClientSecret: CLIENT_SECRET,
                                                                 RedirectUri: REDIRECT_URI,
                                                                 Scope: SCOPE)
        
        // subscribe self as delegate to SQAuthorizationProtocol
        SQOAuth.instance.authorizationDelegate = self
    }
    
    
    
    // MARK: - Actions
    func loginButtonPressed() {
        self.view.userInteractionEnabled = false
        SQOAuth.instance.authorizeUser()
    }
        
    
    
    // MARK: - SQAuthorizationProtocolDelegate
    func userIsSuccessfullyAuthorized(token: SQToken) -> Void {
        dispatch_async(self.kMainQueue, { () -> Void in
            print("user Is Successfully Authorized")
            self.view.userInteractionEnabled = true
            self.performSegueWithIdentifier(self.SELECT_FILES_CONTROLLER_SEGUE_ID, sender: token)
        })
    }
    
    
    func userIsNotAuthorized() -> Void {
        dispatch_async(kMainQueue) {
            print("user is not authorized")
            self.view.userInteractionEnabled = true
            self.showAlertWithMessage("Server error\nCan't authorize user")
        }
    }
    
    func userDidCancelAuthorization() -> Void {
        dispatch_async(kMainQueue) {
            self.view.userInteractionEnabled = true
            print("user Did Cancel Authorization")
        }
    }
    
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController.isKindOfClass(SelectFileViewController) {
            if sender != nil {
                let destinationVC = segue.destinationViewController as! SelectFileViewController
                destinationVC.token = sender as! SQToken?
            }
        }
    }
    
    
    
    // MARK: - Allert Message
    func showAlertWithMessage(message: NSString) -> Void {
        let alert = UIAlertController(title: nil, message: message as String, preferredStyle: .Alert)
        let closeAction = UIAlertAction(title: "Close", style: .Default, handler: nil)
        alert.addAction(closeAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    
    // MARK: - Memory help
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
