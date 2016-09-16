//
//  SelectFileViewController.swift
//  master-plugin-swift
//
//  Created by Bogdan Laukhin on 9/16/16.
//  Copyright © 2016 Sequencing.com. All rights reserved.
//

import UIKit

// ADD THIS POD IMPORT
import sequencing_oauth_api_swift
import sequencing_file_selector_api_swift
import sequencing_app_chains_api_swift
    

class SelectFileViewController: UIViewController {
    
    
    let kMainQueue = dispatch_get_main_queue()
    let SELECT_FILES_CONTROLLER_SEGUE_ID = "SELECT_FILES"
    
    var token: SQToken?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
