//
//  NetworkManager.swift
//  DanaPinjol
//
//  Created by Ethan Parker on 2026/3/16.
//

import Alamofire

let h5_url = "http://8.215.5.252:11303"
let base_url = "http://8.215.5.252:11303/aah"

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
        
        let apiUrl = URLParameterHelper.shared.getFullURL(baseURL: base_url + url)
        
        let data = try await getSession
            .request(
                apiUrl,
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
        
        let apiUrl = URLParameterHelper.shared.getFullURL(baseURL: base_url + url)
        
        let data = try await postSession
            .upload(
                multipartFormData: { multipart in
                    
                    for (key, value) in parameters {
                        let data = "\(value)".data(using: .utf8)!
                        multipart.append(data, withName: key)
                    }
                    
                },
                to: apiUrl
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
        
        let apiUrl = URLParameterHelper.shared.getFullURL(baseURL: base_url + url)
        
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
                        withName: "senhimture",
                        fileName: "image.jpg",
                        mimeType: "image/jpeg"
                    )
                    
                },
                to: apiUrl
            )
            .validate()
            .serializingData()
            .value
        
        let model = try JSONDecoder().decode(T.self, from: data)
        return model
    }
}
