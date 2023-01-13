//
//  NetworkManager.swift
//  TrendingRepositories
//
//  Created by Mustafa Ali Akçakır on 13.01.2023.
//

import Foundation

class NetworkManager {
    
    enum ManagerErrors: Error {
        case invalidResponse
        case invalidStatusCode(Int)
    }
    
    enum HttpMethod: String {
        case get
        case post
        
        var method: String {
            rawValue.uppercased()
        }
    }
    
    static let shared = NetworkManager()
    
    func request<T: Decodable>(
        fromURL url: URL, httpMethod: HttpMethod = .get,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        let completionOnMain: (Result<T, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.method
        
        let urlSession = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completionOnMain(.failure(error))
                return
            }
            
            guard let urlResponse = response as? HTTPURLResponse else {
                return completionOnMain(.failure(ManagerErrors.invalidResponse))
            }
            
            let statusCode = urlResponse.statusCode
            if !(200..<300).contains(statusCode) {
                return completionOnMain(.failure(ManagerErrors.invalidStatusCode(statusCode)))
            }
            
            guard let data = data else {
                return
            }
            do {
                let response = try JSONDecoder().decode(T.self, from: data)
                completionOnMain(.success(response))
            } catch {
                debugPrint("Failed while decoding data. Reason: \(error.localizedDescription)")
                completionOnMain(.failure(error))
            }
        }
        
        urlSession.resume()
    }
}
