//
//  OKLoginRequestData.swift
//  OllamaKit
//
//  Created by LiuFei on 2025/4/12.
//

import Foundation

public struct OKLoginRequestData: Encodable, Sendable {
    /// A string representing the identifier of the source model to be copied.
    public let identityToken: String
    
    /// A string indicating the identifier for the destination or the new copy of the model.
    public let authorizationCode: String
    
    public let userIdentifier: String
    
    public let loginType: String
    
    public init(identityToken: String, authorizationCode: String, userIdentifier: String, loginType: String) {
        self.identityToken = identityToken
        self.authorizationCode = authorizationCode
        self.userIdentifier = userIdentifier
        self.loginType = loginType
    }
}
