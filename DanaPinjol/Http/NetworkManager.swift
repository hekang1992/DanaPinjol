//
//  NetworkManager.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/16.
//

import Alamofire

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    private let getSession: Session = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 10
        config.timeoutIntervalForResource = 10
        return Session(configuration: config)
    }()
    
    private let postSession: Session = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 30
        return Session(configuration: config)
    }()
}

extension NetworkManager {
    
    func getRequest<T: BaseModel>(
        url: String,
        parameters: [String: Any]? = nil
    ) async throws -> T {
        
        let data = try await getSession
            .request(
                url,
                method: .get,
                parameters: parameters
            )
            .validate()
            .serializingData()
            .value
        
        let model = try JSONDecoder().decode(T.self, from: data)
        return model
    }
}

extension NetworkManager {
    
    func postRequest<T: BaseModel>(
        url: String,
        parameters: [String: Any]
    ) async throws -> T {
        
        let data = try await postSession
            .upload(
                multipartFormData: { multipart in
                    
                    for (key, value) in parameters {
                        let data = "\(value)".data(using: .utf8)!
                        multipart.append(data, withName: key)
                    }
                    
                },
                to: url
            )
            .validate()
            .serializingData()
            .value
        
        let model = try JSONDecoder().decode(T.self, from: data)
        return model
    }
}

extension NetworkManager {
    
    func uploadImage<T: BaseModel>(
        url: String,
        imageData: Data,
        parameters: [String: Any]? = nil
    ) async throws -> T {
        
        let data = try await postSession
            .upload(
                multipartFormData: { multipart in
                    
                    if let params = parameters {
                        for (key, value) in params {
                            let data = "\(value)".data(using: .utf8)!
                            multipart.append(data, withName: key)
                        }
                    }
                    
                    multipart.append(
                        imageData,
                        withName: "file",
                        fileName: "image.jpg",
                        mimeType: "image/jpeg"
                    )
                    
                },
                to: url
            )
            .validate()
            .serializingData()
            .value
        
        let model = try JSONDecoder().decode(T.self, from: data)
        return model
    }
}
