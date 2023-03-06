//
//  NetworkManager.swift
//  TrendingRepositories
//
//  Created by Mustafa Ali Akçakır on 13.01.2023.
//

import Alamofire
import Foundation

final class NetworkManager {
    
    enum Method: String {
        case get
        case post
    }
    
    static let shared = NetworkManager()
    
    func request<T: Decodable>(
        _ url: String, method: Method = .get, parameters: [String: Any]? = nil,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        AF.request(url, method: HTTPMethod(rawValue: method.rawValue.uppercased()), parameters: parameters)
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let response):
                    completion(.success(response))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
