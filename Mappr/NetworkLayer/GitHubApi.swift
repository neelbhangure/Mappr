//
//  GitHubApi.swift
//  Mappr
//
//  Created by neel on 14/03/20.
//  Copyright © 2020 neel. All rights reserved.
//
import Foundation
public protocol Request {
    var url: String { get }
    func params() -> [(key: String, value: String)]
}
protocol SearchRepositoryService {
    
    func searchRepos(searchWith : String, params: [String: String]?, successHandler: @escaping (_ response: SearchRepositoriesResponse) -> Void, errorHandler: @escaping(_ error: Error) -> Void)
    
    
}
struct GitHubApi : SearchRepositoryService {
    
     private let urlSession = URLSession.shared
    
    public static let shared = GitHubApi()
    private init() {}
    
    
    func searchRepos(searchWith : String, params: [String : String]?, successHandler: @escaping (SearchRepositoriesResponse) -> Void, errorHandler: @escaping (Error) -> Void) {
        guard var urlComponents = URLComponents(string: "\(GitHubApi.baseUrl)/search/repositories") else {
            errorHandler(GitError.invalidEndpoint)
            return
        }
        
        var queryItems = [
            
            URLQueryItem(name: "q", value: searchWith),
            
        ]
        if let params = params {
            queryItems.append(contentsOf: params.map { URLQueryItem(name: $0.key, value: $0.value) })
        }
        
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            errorHandler(GitError.invalidEndpoint)
            return
        }
        
        urlSession.dataTask(with: url) { (data, response, error) in
            if error != nil {
                self.handleError(errorHandler: errorHandler, error: GitError.apiError)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                self.handleError(errorHandler: errorHandler, error: GitError.invalidResponse)
                return
            }
            
            guard let data = data else {
                self.handleError(errorHandler: errorHandler, error: GitError.noData)
                return
            }
            
            do {
                let booksResponse = try GitHubApi.decoder.decode(SearchRepositoriesResponse.self, from: data)
                DispatchQueue.main.async {
                    successHandler(booksResponse)
                }
            } catch {
                self.handleError(errorHandler: errorHandler, error: GitError.serializationError)
            }
        }.resume()
        
    }
    
    func getContributersList(withUrl url : URL, successHandler: @escaping (ContributerList) -> Void, errorHandler: @escaping (Error) -> Void) {
        get(withURL: URLRequest(url: url)) { (data) in
            guard let data = data else {
                self.handleError(errorHandler: errorHandler, error: GitError.noData)
                return
            }
            
            do {
                let booksResponse = try GitHubApi.decoder.decode(ContributerList.self, from: data)
                DispatchQueue.main.async {
                    successHandler(booksResponse)
                }
            } catch {
                self.handleError(errorHandler: errorHandler, error: GitError.serializationError)
            }
        }
    }
    
    private func handleError(errorHandler: @escaping(_ error: Error) -> Void, error: Error) {
        DispatchQueue.main.async {
            errorHandler(error)
        }
    }
    private static var baseUrl = "https://api.github.com"
    
    struct SearchRequest: Request {
        var url: String {
            return baseUrl + "/search/repositories"
        }
        let search: String
        let page: Int
        
        func params() -> [(key: String, value: String)] {
            return [
                (key: "q", value: search),
                (key: "sort", value : "stars"),
                (key: "page", value : "\(page)")
            ]
        }
    }
    
//    func search(with request: SearchRequest, onSuccess: @escaping (SearchRepositoriesResponse) -> Void, onError: @escaping (Error) -> Void) {
//        get(withURL: request) { (data) in
//            do {
//                let response = try self.parse(data)
//                onSuccess(response)
//            } catch {
//                onError(ApiError.failedParse)
//            }
//        }
//    }
//    
//    private func parse(_ data: Data) throws -> SearchRepositoriesResponse {
//        let response: SearchRepositoriesResponse = try JSONDecoder().decode(SearchRepositoriesResponse.self, from: data)
//        return response
//    }
}

extension  GitHubApi {
    func  get(withURL urlRequest: URLRequest, completion: @escaping (_ data: Data?) -> ()) {
    let session = URLSession(configuration: .default)
    
    session.dataTask(with: urlRequest) { (data, response, error) in
        if let data = data, error == nil {
            completion(data)
        }
        completion(nil)
    }.resume()
}
}

extension GitHubApi {
    public static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)
            
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .iso8601)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
            if let date = formatter.date(from: dateStr) {
                return date
            }
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
            if let date = formatter.date(from: dateStr) {
                return date
            }
            throw DecodingError.typeMismatch(Date.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Could not decode date"))
        })
        return decoder
    }
    
    public static var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
        encoder.dateEncodingStrategy = .formatted(formatter)
        return encoder
    }
}

public enum GitError: Error {
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError
}
