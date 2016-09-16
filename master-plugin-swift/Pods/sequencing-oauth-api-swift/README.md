# CocoaPods plugin for quickly adding Sequencing.com's OAuth2 and File Selector to iOS apps coded in Swift

=========================================
This repo contains CocoaPods plugin code for implementing Sequencing.com's OAuth2 authentication and File Selector for your Swift iOS app so that your app can securely access [Sequencing.com's](https://sequencing.com/) API and app chains.

* oAuth flow is explained [here](https://github.com/SequencingDOTcom/OAuth2-code-with-demo)
* Example that uses this Pod is located [here](https://github.com/SequencingDOTcom/OAuth2-code-with-demo/tree/master/swift)

Contents
=========================================
* Cocoa Pod integration
* Resources
* Maintainers
* Contribute

Cocoa Pod integration
======================================

You need to follow instruction below if you want to install and use OAuth logic and file selector logic in your existed or new project.

* create a new project in Xcode
* install pod (see instruction here https://cocoapods.org > getting started)
	* create Podfile in your project directory:
```$ pod init```
	* don't forget to uncomment the row (as this is swift pod) ```use_frameworks!```
	* specify "sequencing-oauth-api-swift" pod parameters:
```pod 'sequencing-oauth-api-swift', '~> 1.0.1'```
	* install the dependency in your project:
```$ pod install```
	* always open the Xcode workspace instead of the project file:
```$ open *.xcworkspace```
* register application parameters
	* add pod import (pay attention to substitute original dash characters in title to underscore characters) ```import sequencing_oauth_api_swift```
	* for authorization you need to specify your application parameters in String format (BEFORE using authorization methods)
	
		```
		let CLIENT_ID: String		= "your CLIENT_ID here"
		let CLIENT_SECRET: String	= "your CLIENT_SECRET here"
		let REDIRECT_URI: String    = "REDIRECT_URI here"
		let SCOPE: String           = "SCOPE here"
		```		
		
	* parameters registration method is available in "SQOAuth" public class via "instance" init (singleton)
	
		```
		SQOAuth.instance.registrateApplicationParametersClientID(
			self.CLIENT_ID,
			ClientSecret: self.CLIENT_SECRET,
			RedirectUri: self.REDIRECT_URI,
			Scope: self.SCOPE)
		```
		
* use authorization method(s)
	* authorization methods are available in "SQOAuth" public class via "instance" init (singleton)
	* you can authorize your user (e.g. via "login" button). For authorization you can use either "authorizeUserWithResult" or "authorizeUserWithTokenResult" method:
	
		1.
		
		```
		SQOAuth.instance.authorizeUserWithResult { (authResult) -> Void in
			// your code here
		}
		```
		
		"authorizeUserWithResult" will return a closure (block in objc) with "SQAuthResult" shared instance.
		"SQAuthResult" shared instance contains 2 properties:
		* ```var token: SQToken```		- it is a always up-to-date token
		* ```var isAuthorized: Bool```	- property that sais if user is authorized
		Pay attention that you do not need to care about token refresh. It's handled automatically in auth logic.
		There is an internal method that verifies if token is expired and refreshes it.
		
		2.
		
		```
		SQOAuth.instance.authorizeUserWithTokenResult { (token) -> Void in
			// your code here
		}
		```
		
		"authorizeUserWithTokenResult" will return a closure (block in objc) with object of SQToken class directly.
		SQToken object contains following 5 properties with clear titles for usage:
		
		```
		var accessToken:	String
		var expirationDate:	NSDate
		var tokenType:		String
		var scope:			String
		var refreshToken:	String
		```
* use file selector method(s)
	* file selector methods are available in "SQAPI" public class via "instance" init (singleton)
	* you can load/get files (list of own files or list of sample files) via "loadOwnFiles" and "loadSampleFiles" methods:
	
		```
		SQAPI.instance.loadOwnFiles { (files) -> Void in
            // your code here
        }
		```
		
        "loadOwnFiles" will return a closure with NSArray of dictionary objects with file details inside.
		
		```
    	SQAPI.instance.loadSampleFiles { (files) -> Void in
            // your code here
        }
		```
		
		"loadSampleFiles" will return a closure with NSArray of dictionary objects with file details inside.
	
	* each file contains following keys and values:
		```
		DateAdded:		"string value"
		Ext:			"string value"
		FileCategory:	"string value"
		FileSubType:	"string value"
		FileType:		"string value"
		FriendlyDesc1:	"string value"
		FriendlyDesc2:	"string value"
		Id:				"string value"
		Name:			"string value"
		Population:		"string value"
		Sex:			"string value"
		```

Resources
======================================
* [App chains](https://sequencing.com/app-chains)
* [File selector code](https://github.com/SequencingDOTcom/File-Selector-code)
* [Developer center](https://sequencing.com/developer-center)
* [Developer documentation](https://sequencing.com/developer-documentation/)

Maintainers
======================================
This repo is actively maintained by [Sequencing.com](https://sequencing.com/). Email the Sequencing.com bioinformatics team at gittaca@sequencing.com if you require any more information or just to say hola.

Contribute
======================================
We encourage you to passionately fork us. If interested in updating the master branch, please send us a pull request. If the changes contribute positively, we'll let it ride.
