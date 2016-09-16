//
//  SQAuthResult.swift
//  Copyright © 2015-2016 Sequencing.com. All rights reserved
//

import Foundation


public class SQAuthResult: NSObject {
    
    
    // MARK: - Token var with setter
    public var token: SQToken = SQToken() {
        
        willSet(newToken) {
            token.accessToken = newToken.accessToken
            token.expirationDate = newToken.expirationDate
            token.tokenType = newToken.tokenType
            token.scope = newToken.scope
            
            /*
             * DO NOT OVERRIDE REFRESH_TOKEN HERE
             * (after refresh token request it comes as null)
             */
            if newToken.refreshToken != "" {
                token.refreshToken = newToken.refreshToken
            }
        }
        
        didSet(oldToken) {
            if token.refreshToken == "" {
                token.refreshToken = oldToken.refreshToken
            }
        }
    }
    
    
    // MARK: - Initializer
    public static let instance = SQAuthResult()
    
    
}
