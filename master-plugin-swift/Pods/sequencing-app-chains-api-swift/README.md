# CocoaPod-iOS-App-Chains-Swift
App Chains are the easy way to code Real Time Personalization (RTP) into your app. 
Easily add an ```App-Chains``` functionality using this CocoaPods plugin for iOS apps coded in Swift


Contents
=========================================
* Introduction
* Example (of an app using RTP)
* CocoaPods plugin integration
* Configuration
* Troubleshooting
* Resources
* Maintainers
* Contribute


Introduction
=========================================
Search and find app chains -> https://sequencing.com/app-chains/

An app chain is an integration of an API call and an analysis of an app user's genes. Each app chain provides information about a specific trait, condition, disease, supplement or medication. App chains are used to provide genetically tailored content to app users so that the user experience is instantly personalized at the genetic level. This is called [Real Time Personalization (RTP)](https://sequencing.com/developer-documentation/what-is-real-time-personalization-rtp).

Each app chain consists of:

1. **API call**
 * API call that triggers an app hosted by Sequencing.com to perform genetic analysis on your app user's genes
2. **API response**
 * the straightforward, easy-to-use results are sent to your app as the API response
3. **Personalzation**
 * your app uses this information, which is obtained directly from your app user's genes in real-time, to create a truly personalized user experience

For example
* App Chain: It is very important for this person's health to apply sunscreen with SPF +30 whenever it is sunny or even partly sunny.
* Possible responses: Yes, No, Insufficient Data, Error

While there are already app chains to personalize most apps, if you need something but don't see an app chain for it, tell us! (ie email us: gittaca@sequencing.com).

To code Real Time Personalization (RTP) technology into apps, developers may [register for a free account](https://sequencing.com/user/register/) at Sequencing.com. App development with RTP is always free.


Example (of an app using RTP)
======================================
What types of apps can you personalize with app chains? Any type of app... even a weather app. 
* The open source [Weather My Way +RTP app](https://github.com/SequencingDOTcom/Weather-My-Way-RTP-App/) differentiates itself from all other weather apps because it uses app chains to provide genetically tailored content in real-time to each app user.
* Experience it yourself using one of the fun sample genetic data files. These sample files are provided for free to all apps that use app chains.


CocoaPods plugin integration
======================================
Please follow this guide to install App-Chain module in your existed or new project

* see general CocoaPods instruction: ```https://cocoapods.org > getting started```
	
* "App-Chains" CocoaPods plugin prepared as separate module, but it depends on a Token object from OAuth plugin. And it needed fileID which you can get with selecting genetic file via File Selector plugin. 
App-Chains can execute request to server for genetic information with token object and fileID value.
Thus you need 3 modules to be installed and set up: ```OAuth```, ```File Selector``` and ```App-Chains```

* reference to [OAuth plugin Swift (CocoaPods plugin)](https://github.com/SequencingDOTcom/CocoaPod-iOS-OAuth-Swift)
* reference to [File Selector plugin Swift (CocoaPods plugin)](https://github.com/SequencingDOTcom/CocoaPod-iOS-File-Selector-Swift)
	
* create a new project in Xcode
	
* create Podfile in your project directory: 

	```
	$ pod init
	```
		
* specify following parameters in Podfile: 

	```
	pod 'sequencing-app-chains-api-swift', '~> 2.1.0'
	```		
		
* install the dependency in your project: 

	```
	$ pod install
	```
		
* always open the Xcode workspace instead of the project file: 

	```
	$ open *.xcworkspace
	```


Configuration
======================================
* set up OAuth plugin: reference to [OAuth plugin Swift (CocoaPods plugin)](https://github.com/SequencingDOTcom/CocoaPod-iOS-OAuth-Swift)
* set up File Selector plugin: [File Selector plugin Swift (CocoaPods plugin)](https://github.com/SequencingDOTcom/CocoaPod-iOS-File-Selector-Swift)

* configuration for App-Chains: code snippets below contain the following three placeholders. Please make sure to replace each of the placeholders with real values:
* ```<your token>``` 
 * replace with the oAuth2 access token value obtained from OAuth plugin
  * the code snippet for enabling Sequencing.com's oAuth2 authentication for your app can be found in the [oAuth2 code and demo repo](https://github.com/SequencingDOTcom/oAuth2-code-and-demo)
  * [OAuth plugin Swift (CocoaPods plugin)](https://github.com/SequencingDOTcom/CocoaPod-iOS-OAuth-Swift)

* ```<chain id>``` 
 * replace with the App Chain ID obtained from the list of [App Chains](https://sequencing.com/app-chains)

* ```<file id>``` 
 * replace with the file ID selected by the user while using your app
  * the code snippet for enabling Sequencing.com's File Selector for your app can be found in the [File Selector code repo](https://github.com/SequencingDOTcom/File-Selector-code)
  * [File Selector plugin Swift (CocoaPods plugin)](https://github.com/SequencingDOTcom/CocoaPod-iOS-File-Selector-Swift)


### Swift

AppChain module contains framework with encapsulated logic inside (build on Objective-C language).
AppChains Swift API overview

Method  | Purpose | Arguments | Description
------------- | ------------- | ------------- | -------------
`init(token: String, withHostName: String)`  | Constructor | **token** - security token provided by sequencing.com <br> **Hostname** - API server hostname. api.sequencing.com by default | Constructor used for creating AppChains class instance in case reporting API is needed and where security token is required
`func getReportWithApplicationMethodName(applicationMethodName: String!, withDatasourceId: String!, withSuccessBlock: ((Report!) -> Void)!, withFailureBlock: ((NSError!) -> Void)!)`   | Reporting API | **applicationMethodName** - name of data processing routine<br><br>**datasourceId** - input data identifier<br><br>**success** - callback executed on success operation, results with `Report` object<br><br>**failure** - callback executed on operation failure
`func getBatchReportWithApplicationMethodName(appChainsParams: [AnyObject]!, withSuccessBlock: ReportsArray!, withFailureBlock: ((NSError!) -> Void)!)`   | Reporting API with batch request | **appChainsParams** - array of params for batch request.<br>Each param should be an array with 2 items:<br>first object - `applicationMethodName`<br>last object - `datasourceId`<br><br>**success** - callback executed on success operation, results with ReportsArray as array of dictionaries.<br>Each dictionary has following keys and objects:<br>`appChainID` - appChain ID string<br>`report` - Report object<br><br>**failure** - callback executed on operation failure

Adding code to the project:

* first of all you need to create bridging header file.
	Select File > New > File > Header File > name it as

	```
	project-name-Bridging-Header.h
	```

* add AppChains class import in the bridging header file

	```
	#import <AppChainsLibrary/AppChains.h>
	```

* register your bridging header file in the project settings.
	Select your project > project target > Build Settings > Objective-C Bridging Header
	specify path for bridging header file

	```
	$(PROJECT_DIR)/project-name-Bridging-Header.h
	```

After that you can start utilizing Reporting API for single chain request, example:

```
let appChainsManager = AppChains.init(token: accessToken as String, withHostName: "api.sequencing.com")

appChainsManager.getReportWithApplicationMethodName("Chain88", withDatasourceId: fileID, withSuccessBlock: { (result) in
            let resultReport: Report = result as Report!
            
            if resultReport.isSucceeded() {    
                if resultReport.getResults() != nil {
                    for item: AnyObject in resultReport.getResults() {
                        
                        let resultObj = item as! Result
                        let resultValue: ResultValue = resultObj.getValue()
                        
                        if resultValue.getType() == ResultType.Text {
                            print(resultObj.getName() + " = " + (resultValue as! TextResultValue).getData())
                        }
                    }
                }   
            } else {
                print("Error occured while getting genetic information")
            }
            
            

            
            }) { (error) in
            	print("Error occured while getting genetic information. " + error.localizedDescription)
        }
        
```


Example of using batch request API for several chains:

```
let appChainsManager = AppChains.init(token: accessToken as String, withHostName: "api.sequencing.com")

let appChainsForRequest: NSArray = [["Chain88", fileID],
									["Chain9", fileID]]

appChainsManager.getBatchReportWithApplicationMethodName(appChainsForRequest as [AnyObject], withSuccessBlock: { (resultsArray) in
            let reportResultsArray = resultsArray as NSArray
            
            for appChainReport in reportResultsArray {
                let appChainReportDict = appChainReport as! NSDictionary
                let resultReport: Report = appChainReportDict.objectForKey("report") as! Report;
                let appChainID: NSString = appChainReportDict.objectForKey("appChainID") as! NSString;
                
                if appChainID.isEqualToString("Chain88") {
                    appChainValue = self.parseReportForChain88(resultReport) // your own method to parse report object
                    print(appChainValue)
                    
                } else if appChainID.isEqualToString("Chain9") {
                    appChainValue = self.parseReportForChain9(resultReport) // your own method to parse report object
                    print(appChainValue)
                }   
            }
            
        }) { (error) in
            print("batch request error. " + error.localizedDescription)
            completion(appchainsResults: nil)
        }
```




Troubleshooting
======================================
Each app chain code should work straight out-of-the-box without any configuration requirements or issues. 

Other tips

* Ensure that the following three placeholders have been substituted with real values:

1. ```<your token>```
  * replace with the oAuth2 access token value obtained from OAuth plugin
  * the code snippet for enabling Sequencing.com's oAuth2 authentication for your app can be found in the [oAuth2 code and demo repo](https://github.com/SequencingDOTcom/oAuth2-code-and-demo)
  * [OAuth plugin Swift (CocoaPods plugin)](https://github.com/SequencingDOTcom/CocoaPod-iOS-OAuth-Swift)

2. ```<chain id>```
  * replace with the App Chain ID obtained from the list of [App Chains](https://sequencing.com/app-chains)

3. ```<file id>```
  * replace with the file ID selected by the user while using your app. 
   * the code snippet for enabling Sequencing.com's File Selector for your app can be found in the [File Selector code repo](https://github.com/SequencingDOTcom/File-Selector-code)
  * [File Selector plugin Swift (CocoaPods plugin)](https://github.com/SequencingDOTcom/CocoaPod-iOS-File-Selector-Swift)
   
* [Developer Documentation](https://sequencing.com/developer-documentation/)

* [OAuth2 guide](https://sequencing.com/developer-documentation/oauth2-guide/)

* Review the [Weather My Way +RTP app](https://github.com/SequencingDOTcom/Weather-My-Way-RTP-App/), which is an open-source weather app that uses Real-Time Personalization to provide genetically tailored content

* Confirm you have the latest version of the code from this repository.


Resources
======================================
* [App chains](https://sequencing.com/app-chains)
* [File selector code](https://github.com/SequencingDOTcom/File-Selector-code)
* [Developer center](https://sequencing.com/developer-center)
* [Developer Documentation](https://sequencing.com/developer-documentation/)

Maintainers
======================================
This repo is actively maintained by [Sequencing.com](https://sequencing.com/). Email the Sequencing.com bioinformatics team at gittaca@sequencing.com if you require any more information or just to say hola.

Contribute
======================================
We encourage you to passionately fork us. If interested in updating the master branch, please send us a pull request. If the changes contribute positively, we'll let it ride.

