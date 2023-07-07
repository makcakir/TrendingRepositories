//
//  NetworkManager.swift
//  TrendingRepositories
//
//  Created by Mustafa Ali Akçakır on 13.01.2023.
//

import Alamofire
import Foundation

protocol NetworkProtocol {

    func request<T: Decodable>(endPoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void)
}

final class NetworkManager {

    static let shared = NetworkManager()

    private init() {}
}

// MARK: - NetworkProtocol

extension NetworkManager: NetworkProtocol {

    func request<T: Decodable>(endPoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void) {
        let url = endPoint.baseURL + endPoint.path
        let method = HTTPMethod(rawValue: endPoint.method.rawValue.uppercased())
        AF.request(url, method: method, parameters: endPoint.parameters)
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
