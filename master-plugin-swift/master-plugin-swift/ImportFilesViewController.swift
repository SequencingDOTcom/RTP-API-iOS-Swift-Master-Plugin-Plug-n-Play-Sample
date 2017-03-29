//
//  ImportFilesViewController.swift
//  Copyright © 2017 Sequencing.com. All rights reserved.
//

import UIKit
import QuartzCore



class ImportFilesViewController: UIViewController {

    @IBOutlet weak var emailAddressField: UITextField!
    
    @IBOutlet weak var andMeButton: UIButton!
    @IBOutlet weak var andMeButtonView: UIView!
    @IBOutlet weak var ancestryButton: UIButton!
    @IBOutlet weak var ancestryButtonView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Import genetic file"
        
        // adjust buttons view
        andMeButtonView.layer.cornerRadius = 5
        andMeButtonView.layer.masksToBounds = true
        andMeButtonView.layer.borderColor = UIColor.init(colorLiteralRed: 35/255.0, green: 121/255.0, blue: 254/255.0, alpha: 1.0).cgColor
        andMeButtonView.layer.borderWidth = 1.0
        
        ancestryButtonView.layer.cornerRadius = 5
        ancestryButtonView.layer.masksToBounds = true
        ancestryButtonView.layer.borderColor = UIColor.init(colorLiteralRed: 35/255.0, green: 121/255.0, blue: 254/255.0, alpha: 1.0).cgColor
        ancestryButtonView.layer.borderWidth = 1.0
    }

    
    
    @IBAction func connectToButtonPressed(_ sender: Any) {
        let file1: NSDictionary = ["name"     : "NA12877.vcf.gz",
                                   "type"     : "0",
                                   "url"      : "ftp://platgene_ro@ussd-ftp.illumina.com/2016-1.0/hg38/small_variants/NA12877/NA12877.vcf.gz",
                                   "hashType" : "0",
                                   "hashValue": "0",
                                   "size"     : "0"]
        let filesArray: NSArray = [file1]
        
        let connetManager = SQConnectTo.init()
        connetManager.connectToSequencing(withCliendSecret: SQOAuth.sharedInstance(),
                                          userEmail: emailAddressField!.text,
                                          filesArray: filesArray as! [Any],
                                          viewControllerDelegate: self)
    }
    
    
    @IBAction func andMeButtonPressed(_ sender: Any) {
        let importAPI: SQ3rdPartyImportAPI = SQ3rdPartyImportAPI.init()
        importAPI.importFrom23AndMe(withToken: SQOAuth.sharedInstance(),
                                    viewControllerDelegate: self)
    }
    
    
    @IBAction func ancestryButtonPressed(_ sender: Any) {
        let importAPI: SQ3rdPartyImportAPI = SQ3rdPartyImportAPI.init()
        importAPI.importFromAncestry(withToken: SQOAuth.sharedInstance(),
                                     viewControllerDelegate: self)
    }

}
