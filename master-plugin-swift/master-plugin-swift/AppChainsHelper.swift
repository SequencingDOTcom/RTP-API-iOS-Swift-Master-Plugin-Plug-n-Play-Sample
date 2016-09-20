//
//  AppChainsHelper.swift
//  Copyright © 2016 Plexteq. All rights reserved.
//

import Foundation
import sequencing_app_chains_api_swift


class AppChainsHelper: NSObject {
    
    
    // Genetic chains
    class func requestForChain88BasedOnFileID(fileID: String, accessToken: String, completion: (vitaminDValue: NSString?) -> Void) -> Void {
        print("starting request for chains88: vitaminDValue")
        
        let appChainsManager = AppChains.init(token: accessToken as String, chainsHostname: "api.sequencing.com")
        let returnValue: ReturnValue<Report> = appChainsManager.getReport("StartApp", applicationMethodName: "Chain88", datasourceId: fileID as String)
        
        switch returnValue {
            
            case .Success(let value):
                let report: Report = value
                let vitaminDKey = "result"
                var vitaminDValue = "" as NSString
                
                for result: Result in report.results {
                    let resultValue: ResultValue = result.value
                    
                    if resultValue.type == ResultType.TEXT {
                        print(result.name + " = " + (resultValue as! TextResultValue).data)
                        
                        if result.name.lowercaseString == vitaminDKey {
                            let vitaminDRawValue = (resultValue as! TextResultValue).data
                            
                            if (vitaminDRawValue as NSString).length > 0 {
                                if vitaminDRawValue.lowercaseString.rangeOfString("no") != nil {
                                    vitaminDValue = "False"
                                } else {
                                    vitaminDValue = "True"
                                }
                                
                            }
                        }
                    }
                }
                
                if vitaminDValue.length > 0 {
                    completion(vitaminDValue: vitaminDValue)
                } else {
                    print("[appChain88 Error] vitaminD value is absent")
                    completion(vitaminDValue: nil)
                }
            
            case .Failure(let error):
                print("[appChain88 Error] vitaminD value is absent. " + error)
                completion(vitaminDValue: nil)
        }
    }
    
    
    
    class func requestForChain9BasedOnFileID(fileID: String, accessToken: String, completion: (melanomaRiskValue: NSString?) -> Void) -> Void {
        print("starting request for chains9: melanomaRiskValue")
        
        let appChainsManager = AppChains.init(token: accessToken as String, chainsHostname: "api.sequencing.com")
        let returnValue = appChainsManager.getReport("StartApp", applicationMethodName: "Chain9", datasourceId: fileID as String)
        
        switch returnValue {
            
        case .Success(let value):
            let report: Report = value
            let riskKey = "riskdescription"
            var riskValue = "" as NSString
            
            for result: Result in report.results {
                let resultValue: ResultValue = result.value
                
                if resultValue.type == ResultType.TEXT {
                    print(result.name + " = " + (resultValue as! TextResultValue).data)
                    
                    if result.name.lowercaseString == riskKey {
                        riskValue = (resultValue as! TextResultValue).data
                    }
                }
            }
            
            if riskValue.length > 0 {
                completion(melanomaRiskValue: riskValue)
            } else {
                print("[appChain9 Error] melanoma info is absent")
                completion(melanomaRiskValue: nil)
            }
            
        case .Failure(let error):
            print("[appChain9 Error] melanoma info is absent. " + error)
            completion(melanomaRiskValue: nil)
        }
    }
    
    

}
