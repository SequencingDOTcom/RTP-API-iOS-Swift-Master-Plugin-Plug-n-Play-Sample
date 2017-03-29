//
//  AppChainsHelper.swift
//  Copyright © 2017 Sequencing.com. All rights reserved.
//

import Foundation


class AppChainsHelper: NSObject {
    
    // Genetic chains protocol v2
    func requestForChain88BasedOnFileID(fileID: String, tokenProvider: SQOAuth, completion: @escaping (_ vitaminDValue: NSString?) -> Void) -> Void {
        print("starting request for chains88: vitaminDValue")
        
        tokenProvider.token { (token, accessToken) in
            if accessToken != nil {
                
                if let appChainsManager = AppChains.init(token: accessToken!, withHostName: "api.sequencing.com") {
                    
                    appChainsManager.getReportWithApplicationMethodName("Chain88", withDatasourceId: fileID, withSuccessBlock: { (result) in
                        
                        let resultReport: Report = result as Report!
                        completion(self.parseReportForChain88(resultReport: resultReport))
                        
                    }) { (error) in
                        print("[appChain88 Error] vitaminD value is absent.")
                        completion(nil)
                    }
                }
            } else {
                completion(nil)
            }
        }
    }
    
    
    
    func requestForChain9BasedOnFileID(fileID: String, tokenProvider: SQOAuth, completion: @escaping (_ melanomaRiskValue: NSString?) -> Void) -> Void {
        print("starting request for chains9: melanomaRiskValue")
        
        tokenProvider.token { (token, accessToken) in
            if accessToken != nil {
                
                if let appChainsManager = AppChains.init(token: accessToken!, withHostName: "api.sequencing.com") {
                    
                    appChainsManager.getReportWithApplicationMethodName("Chain9", withDatasourceId: fileID, withSuccessBlock: { (result) in
                        let resultReport: Report = result as Report!;
                        completion(self.parseReportForChain9(resultReport: resultReport))
                        
                    }) { (error) in
                        print("[appChain9 Error] melanoma info is absent.")
                        completion(nil)
                    }
                }
            } else {
                completion(nil)
            }
        }
    }
    
    
    
    func batchRequestForChain88AndChain9BasedOnFileID(fileID: String, tokenProvider: SQOAuth, completion: @escaping (_ appchainsResults: NSArray?) -> Void) -> Void {
        print("starting batch request for chains88 (vitaminDValue) and chains9 (melanomaRiskValue)")
        
        tokenProvider.token { (token, accessToken) in
            if accessToken != nil {
                
                if let appChainsManager = AppChains.init(token: accessToken!, withHostName: "api.sequencing.com") {
                    
                    let appChainsForRequest: NSArray = [["Chain88", fileID],
                                                        ["Chain9", fileID]]
                    
                    appChainsManager.getBatchReport(withApplicationMethodName: appChainsForRequest as [AnyObject], withSuccessBlock: { (resultsArray) in
                        
                        let reportResultsArray = resultsArray! as NSArray
                        let appChainsResultsArray = NSMutableArray()
                        
                        for appChainReport in reportResultsArray {
                            let appChainReportDict = appChainReport as! NSDictionary
                            let resultReport: Report = appChainReportDict.object(forKey: "report") as! Report;
                            let appChainID: NSString = appChainReportDict.object(forKey: "appChainID") as! NSString;
                            var appChainValue: NSString = ""
                            
                            if appChainID.isEqual(to: "Chain88") {
                                appChainValue = self.parseReportForChain88(resultReport: resultReport)
                                print(appChainValue)
                                
                            } else if appChainID.isEqual(to: "Chain9") {
                                appChainValue = self.parseReportForChain9(resultReport: resultReport)
                                print(appChainValue)
                            }
                            
                            let reportItem: NSDictionary = ["appChainID": appChainID,
                                                            "appChainValue": appChainValue]
                            appChainsResultsArray.add(_ : reportItem)
                        }
                        completion(appChainsResultsArray)
                        
                    }, withFailureBlock: { (error) in
                        print("batch request error.")
                        completion(nil)
                    })
                }
            } else {
                completion(nil)
            }
        }
    }
    
    
    
    func parseReportForChain88(resultReport: Report) -> NSString {
        var vitaminDValue = "" as NSString
        
        if resultReport.isSucceeded() {
            let vitaminDKey = "result"
            
            if resultReport.getResults() != nil {
                for item in resultReport.getResults() {
                    
                    let resultObj = item as! Result
                    let resultValue: ResultValue = resultObj.getValue()
                    
                    if resultValue.getType() == ResultType.text {
                        print(resultObj.getName() + " = " + (resultValue as! TextResultValue).getData())
                        
                        if resultObj.getName().lowercased() == vitaminDKey {
                            if let vitaminDRawValue = (resultValue as! TextResultValue).getData() {
                                
                                if vitaminDRawValue.lowercased().range(of: "no") != nil {
                                    vitaminDValue = "False"
                                    
                                } else {
                                    vitaminDValue = "True"
                                }
                            }
                        }
                    }
                }
            }
        }
        return vitaminDValue
    }
    
    
    
    func parseReportForChain9(resultReport: Report) -> NSString {
        var riskValue = "" as NSString
        
        if resultReport.isSucceeded() {
            let riskKey = "riskdescription"
            
            if resultReport.getResults() != nil {
                for item in resultReport.getResults() {
                    
                    let resultObj = item as! Result
                    let resultValue: ResultValue = resultObj.getValue()
                    
                    if resultValue.getType() == ResultType.text {
                        print(resultObj.getName() + " = " + (resultValue as! TextResultValue).getData())
                        
                        if resultObj.getName().lowercased() == riskKey {
                            
                            if let riskRawValue = (resultValue as! TextResultValue).getData() {
                                riskValue = riskRawValue as NSString
                            }
                        }
                    }
                }
            }
        }
        return riskValue
    }
    

}
