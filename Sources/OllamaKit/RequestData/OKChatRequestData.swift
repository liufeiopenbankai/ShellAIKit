//
//  OKChatRequestData.swift
//
//
//  Created by Augustinas Malinauskas on 12/12/2023.
//

import Foundation
import CryptoKit

/// A structure that encapsulates data for chat requests to the Ollama API.
public struct OKChatRequestData: Sendable {
    private let stream: Bool
    
    /// A string representing the model identifier to be used for the chat session.
    public let model: String
    
    /// An array of ``Message`` instances representing the content to be sent to the Ollama API.
    public let messages: [Message]
    
    /// An optional array of ``OKJSONValue`` representing the tools available for tool calling in the chat.
    public let tools: [OKJSONValue]?

    /// Optional ``OKJSONValue`` representing the JSON schema for the response.
    /// Be sure to also include "return as JSON" in your prompt
    public let format: OKJSONValue?

    /// Optional ``OKCompletionOptions`` providing additional configuration for the chat request.
    public var options: OKCompletionOptions?
    
    /// A random 6-digit string for request identification
    public let nonce: String
    
    /// Timestamp of the request
    public let timestamp: Int
    
    /// Signature of the request
    public let signature: String
    
    public init(model: String, messages: [Message], tools: [OKJSONValue]? = nil, format: OKJSONValue? = nil) {
        self.stream = tools == nil
        self.model = model
        self.messages = messages
        self.tools = tools
        self.format = format
        
        // Generate nonce
        self.nonce = String(format: "%06d", Int.random(in: 0...999999))
        
        // Set timestamp
        self.timestamp = Int(Date().timeIntervalSince1970)
        
        // Calculate signature
        self.signature = Self.calculateSignature(
            stream: self.stream,
            nonce: self.nonce,
            model: model,
            timestamp: self.timestamp,
            messages: messages,
            tools: tools,
            format: format,
            options: options
        )
    }
    
    private static func calculateSignature(
        stream: Bool,
        nonce: String,
        model: String,
        timestamp: Int,
        messages: [Message],
        tools: [OKJSONValue]?,
        format: OKJSONValue?,
        options: OKCompletionOptions?
    ) -> String {
        // Create dictionary of parameters
        var params: [String: String] = [
            "stream": String(stream),
            "nonce": nonce,
            "model": model,
            "timestamp": String(timestamp)
        ]
        
        // Add messages if not empty
        if !messages.isEmpty {
            let messagesString = messages.map { "\($0.role.rawValue):\($0.content)" }.joined(separator: ",")
            params["messages"] = messagesString
        }
        
        // Sort parameters by key
        let sortedKeys = params.keys.sorted()
        
        // Create string1
        let string1 = sortedKeys.compactMap { key -> String? in
            guard let value = params[key] else { return nil }
            return "\(key)=\(value)"
        }.joined(separator: "&")
        
        // Calculate SHA1
        let data = string1.data(using: .utf8)!
        let digest = Insecure.SHA1.hash(data: data)
        return digest.map { String(format: "%02hhx", $0) }.joined()
    }
    
    /// A structure that represents a single message in the chat request.
    public struct Message: Encodable, Sendable {
        /// A ``Role`` value indicating the sender of the message (system, assistant, user).
        public let role: Role
        
        /// A string containing the message's content.
        public let content: String
        
        /// An optional array of base64-encoded images.
        public let images: [String]?
        
        public init(role: Role, content: String, images: [String]? = nil) {
            self.role = role
            self.content = content
            self.images = images
        }
        
        /// An enumeration that represents the role of the message sender.
        public enum Role: String, Encodable, Sendable {
            /// Indicates the message is from the system.
            case system
            
            /// Indicates the message is from the assistant.
            case assistant
            
            /// Indicates the message is from the user.
            case user
        }
    }
}

extension OKChatRequestData: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(stream, forKey: .stream)
        try container.encode(model, forKey: .model)
        try container.encode(messages, forKey: .messages)
        try container.encodeIfPresent(tools, forKey: .tools)
        try container.encodeIfPresent(format, forKey: .format)
        try container.encode(nonce, forKey: .nonce)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(signature, forKey: .signature)

        if let options {
            try options.encode(to: encoder)
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case stream, model, messages, tools, format, nonce, timestamp, signature
    }
}
