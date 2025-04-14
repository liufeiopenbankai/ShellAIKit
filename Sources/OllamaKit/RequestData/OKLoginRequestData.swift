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
    
    
    
    public init(identityToken: String) {
        self.identityToken = identityToken
    }
}
