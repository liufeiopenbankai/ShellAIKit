//
//  OKLoginResponse.swift
//  OllamaKit
//
//  Created by LiuFei on 2025/4/14.
//
import Foundation

public struct OKLoginResponse: Decodable, Sendable {
    
    public let msg: String
    
    public let code : Int
    
    public let token: String
    
    public let userID: String
}
