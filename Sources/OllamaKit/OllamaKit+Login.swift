//
//  Untitled.swift
//  OllamaKit
//
//  Created by LiuFei on 2025/4/12.
//

import Foundation

extension OllamaKit {
    /// Asynchronously requests the Ollama API to copy a model.
    ///
    /// This method sends a request to the Ollama API to copy a model based on the provided ``OKCopyModelRequestData``.
    ///
    /// ```swift
    /// let ollamaKit = OllamaKit()
    /// let requestData = OKCopyModelRequestData(/* parameters */)
    /// try await ollamaKit.copyModel(data: requestData)
    /// ```
    ///
    /// - Parameter data: The ``OKCopyModelRequestData`` containing the details needed to copy the model.
    /// - Throws: An error if the request to copy the model fails.
    public func login(data: OKLoginRequestData) async throws -> Void {
        let request = try OKRouter.login(data: data).asURLRequest(with: baseURL)
        
        try await OKHTTPClient.shared.send(request: request)
    }
}
