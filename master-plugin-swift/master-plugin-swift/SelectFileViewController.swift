//
//  SelectFileViewController.swift
//  Copyright © 2016 Sequencing.com. All rights reserved.
//

import UIKit
import QuartzCore

// ADD THIS POD IMPORT
import sequencing_oauth_api_swift
import sequencing_file_selector_api_swift
import sequencing_app_chains_api_swift
    

class SelectFileViewController: UIViewController, SQTokenRefreshProtocolDelegate, SQFileSelectorProtocolDelegate {
    
    
    let kMainQueue = dispatch_get_main_queue()
    let kBackgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    let FILES_CONTROLLER_SEGUE_ID = "GET_FILES"
    
    // actiity indicator
    var messageFrame = UIView()
    var strLabel = UILabel()
    var activityIndicator = UIActivityIndicatorView()
    
    var token: SQToken?
    var selectedFile = NSDictionary()
    
    // UI items
    @IBOutlet weak var buttonSelectFile: UIButton!
    @IBOutlet weak var buttonView: UIView!
    
    @IBOutlet weak var getFileInfo: UISegmentedControl!
    @IBOutlet weak var segmentedControlView: UIView!
    
    @IBOutlet weak var selectedFileTagline: UILabel!
    @IBOutlet weak var selectedFileName: UILabel!
    
    @IBOutlet weak var vitaminDInfo: UILabel!
    @IBOutlet weak var melanomaInfo: UILabel!
    
    
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Using genetic file"
        
        // subscribe self as delegate to SQTokenRefreshProtocol
        SQOAuth.instance.refreshTokenDelegate = self
        
        // subscribe self as delegate to SQFileSelectorProtocol
        SQFilesAPI.instance.selectedFileDelegate = self
        SQFilesAPI.instance.closeButton = true
        
        // adjust buttons view
        buttonView.layer.cornerRadius = 5
        buttonView.layer.masksToBounds = true
        segmentedControlView.layer.cornerRadius = 5
        segmentedControlView.layer.masksToBounds = true
        
        selectedFileTagline.hidden = true
        selectedFileName.hidden = true
        getFileInfo.hidden = true
        segmentedControlView.hidden = true
        vitaminDInfo.hidden = true
        melanomaInfo.hidden = true
    }
    
    
    deinit {
        SQOAuth.instance.refreshTokenDelegate = nil
        SQFilesAPI.instance.selectedFileDelegate = nil
    }
    
    
    
    // MARK: - Actions
    @IBAction func loadFilesButtonPressed(sender: AnyObject) {
        self.view.userInteractionEnabled = false
        self.startActivityIndicatorWithTitle("Loading Files")
        
        selectedFileTagline.hidden = true
        selectedFileName.hidden = true
        getFileInfo.hidden = true
        segmentedControlView.hidden = true
        vitaminDInfo.hidden = true
        melanomaInfo.hidden = true
        
        print(self.token)
        if self.token != nil {
            SQFilesAPI.instance.loadFilesWithToken(self.token!.accessToken, success: { (success) in
                dispatch_async(self.kMainQueue) {
                    if success {
                        self.stopActivityIndicator()
                        self.view.userInteractionEnabled = true
                        self.performSegueWithIdentifier(self.FILES_CONTROLLER_SEGUE_ID, sender: nil)
                        
                    } else {
                        self.stopActivityIndicator()
                        self.view.userInteractionEnabled = true
                        self.showAlertWithMessage("Sorry, can't load genetic files")
                    }
                }
            })
        } else {
            self.showAlertWithMessage("Sorry, can't load genetic files > token is empty")
        }
    }
    
    
    
    
    // MARK: - SQFileSelectorProtocolDelegate
    func handleFileSelected(file: NSDictionary) -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
        print(file)
        if file.allKeys.count > 0 {
            dispatch_async(self.kMainQueue) {
                self.stopActivityIndicator()
                self.view.userInteractionEnabled = true
                self.selectedFile = file
                let fileCategory = file.objectForKey("FileCategory") as! String
                var fileName: NSString
                
                if fileCategory.rangeOfString("Community") != nil {
                    fileName = NSString(format: "%@ - %@", file.objectForKey("FriendlyDesc1") as! NSString, file.objectForKey("FriendlyDesc2") as! NSString)
                } else {
                    fileName = NSString(format: "%@", file.objectForKey("Name") as! NSString)
                }
                
                self.selectedFileName.text = fileName as String
                
                self.selectedFileTagline.hidden = false
                self.selectedFileName.hidden = false
                self.getFileInfo.hidden = false
                self.segmentedControlView.hidden = false
            }
        } else {
            dispatch_async(kMainQueue, {
                self.stopActivityIndicator()
                self.view.userInteractionEnabled = true
                self.showAlertWithMessage("Sorry, can't load genetic files")
                
                self.selectedFileTagline.hidden = true
                self.selectedFileName.hidden = true
                self.getFileInfo.hidden = true
                self.segmentedControlView.hidden = true
            })
        }
    }
    
    func closeButtonPressed() -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    // MARK: - Get genetic information
    @IBAction func getGeneticInfoPressed(sender: UISegmentedControl) {
        if self.selectedFile.allKeys.count > 0 {
            if let selectedSegmentItem = sender.titleForSegmentAtIndex(sender.selectedSegmentIndex) {
                
                if selectedSegmentItem.rangeOfString("vitamin") != nil {
                    self.getVitaminDInfo()
                } else {
                    self.getMelanomaInfo()
                }
            }
        } else {
            self.showAlertWithMessage("Please select genetic file above")
        }
    }
    
    
    
    func getVitaminDInfo() -> Void {
        if selectedFile.allKeys.count > 0 && token != nil {
            if let fileID = selectedFile.objectForKey("Id") as! NSString? {
                
                self.view.userInteractionEnabled = false
                self.startActivityIndicatorWithTitle("Loading info...")
                
                dispatch_async(self.kBackgroundQueue, {
                    AppChainsHelper.requestForChain88BasedOnFileID(fileID as String, accessToken: self.token!.accessToken, completion: { (vitaminDValue) in
                        print(vitaminDValue)
                        
                        if vitaminDValue != nil && vitaminDValue?.length > 0 {
                            dispatch_async(self.kMainQueue, {
                                if (vitaminDValue! as String).lowercaseString.rangeOfString("false") != nil {
                                    self.stopActivityIndicator()
                                    self.view.userInteractionEnabled = true
                                    self.vitaminDInfo.hidden = false
                                    self.vitaminDInfo.text = "There is no issue with vitamin D"
                                    
                                } else if (vitaminDValue! as String).lowercaseString.rangeOfString("true") != nil {
                                    self.stopActivityIndicator()
                                    self.view.userInteractionEnabled = true
                                    self.vitaminDInfo.hidden = false
                                    self.vitaminDInfo.text = "There is an issue with vitamin D"
                                    
                                } else {
                                    self.stopActivityIndicator()
                                    self.view.userInteractionEnabled = true
                                    self.vitaminDInfo.hidden = true
                                    self.vitaminDInfo.text = "Sorry, there is invalid vitamin D information"
                                }
                            })
                        } else {
                            dispatch_async(self.kMainQueue, {
                                self.stopActivityIndicator()
                                self.view.userInteractionEnabled = true
                                self.vitaminDInfo.hidden = true
                                self.vitaminDInfo.text = "There is error from the server. Probably it's because you're using demo app parameters.\nPlease get valid CLIENT_ID and CLIENT_SECRET for your app in Developer Center on sequencing.com"
                            })
                        }
                    })
                })
            } else {
                self.view.userInteractionEnabled = true
                self.vitaminDInfo.hidden = true
                self.showAlertWithMessage("Corrupted selected file, can't load vitamin D information.")
            }
        } else {
            self.view.userInteractionEnabled = true
            self.vitaminDInfo.hidden = true
            self.showAlertWithMessage("Corrupted user info, can't load vitamin D information.")
        }
    }
    
    
    func getMelanomaInfo() -> Void {
        if selectedFile.allKeys.count > 0 && token != nil {
            if let fileID = selectedFile.objectForKey("Id") as! NSString? {
                
                self.view.userInteractionEnabled = false
                self.startActivityIndicatorWithTitle("Loading info...")
                
                dispatch_async(kBackgroundQueue, {
                    AppChainsHelper.requestForChain9BasedOnFileID(fileID as String, accessToken: self.token!.accessToken, completion: { (melanomaRiskValue) in
                        print(melanomaRiskValue)
                        
                        if melanomaRiskValue != nil && melanomaRiskValue?.length > 0 {
                            dispatch_async(self.kMainQueue, {
                                self.stopActivityIndicator()
                                self.view.userInteractionEnabled = true
                                self.melanomaInfo.hidden = false
                                self.melanomaInfo.text = NSString(format: "Melanoma issue level is: %@", (melanomaRiskValue! as String).capitalizedString) as String
                            })
                        } else {
                            dispatch_async(self.kMainQueue, {
                                self.stopActivityIndicator()
                                self.view.userInteractionEnabled = true
                                self.melanomaInfo.hidden = true
                                self.showAlertWithMessage("There is error from the server. Probably it's because you're using demo app parameters.\nPlease get valid CLIENT_ID and CLIENT_SECRET for your app in Developer Center on sequencing.com")
                            })
                        }
                    })
                })
            } else {
                dispatch_async(self.kMainQueue, {
                    self.stopActivityIndicator()
                    self.view.userInteractionEnabled = true
                    self.melanomaInfo.hidden = true
                    self.showAlertWithMessage("Corrupted selected file, can't load melanoma information.")
                })
            }
        } else {
            dispatch_async(self.kMainQueue, {
                self.stopActivityIndicator()
                self.view.userInteractionEnabled = true
                self.melanomaInfo.hidden = true
                self.showAlertWithMessage("Corrupted user info, can't load melanoma information.")
            })
        }
    }
    
        
    
    // MARK: - SQTokenRefreshProtocolDelegate
    func tokenIsRefreshed(updatedToken: SQToken) -> Void {
        
    }
    
    
    
    
    // MARK: - Activity indicator
    func startActivityIndicatorWithTitle(title: String) -> Void {
        dispatch_async(kMainQueue) { () -> Void in
            
            self.strLabel = UILabel(frame: CGRect(x: 30, y: 0, width: 90, height: 30))
            self.strLabel.text = title
            self.strLabel.font = UIFont.systemFontOfSize(13)
            self.strLabel.textColor = UIColor.grayColor()
            
            let xPos: CGFloat = self.view.frame.midX - 60
            // let yPos: CGFloat = self.mainVC.view.frame.midY + 50
            self.messageFrame = UIView(frame: CGRect(x: xPos, y: 60, width: 120, height: 30))
            self.messageFrame.layer.cornerRadius = 15
            self.messageFrame.backgroundColor = UIColor.clearColor()
            
            self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
            self.activityIndicator.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            self.activityIndicator.startAnimating()
            
            self.messageFrame.addSubview(self.activityIndicator)
            self.messageFrame.addSubview(self.strLabel)
            self.view.addSubview(self.messageFrame)
        }
    }
    
    
    func stopActivityIndicator() -> Void {
        dispatch_async(kMainQueue) { () -> Void in
            self.activityIndicator.stopAnimating()
            self.messageFrame.removeFromSuperview()
        }
    }
    
    
    // MARK: - Alert message
    func showAlertWithMessage(message: NSString) -> Void {
        let alert = UIAlertController(title: nil, message: message as String, preferredStyle: .Alert)
        let close = UIAlertAction(title: "Close", style: .Default, handler: nil)
        alert.addAction(close)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
