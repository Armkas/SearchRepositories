//
//  API.swift
//  SearchRepositories
//
//  Created by user on 2021/12/02.
//

import Foundation

final class Api {
    static let shared = Api()
}

extension Api: ApiProtocol {

    func getRepositories(text: String, completion: @escaping (Repositories?, Error?) -> Void)  {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.github.com"
        urlComponents.path = "/search/repositories"
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: "\(text)"),
                        URLQueryItem(name: "sort", value: "desc"),
                        URLQueryItem(name: "order", value: "best match"),
                        URLQueryItem(name: "page", value: "1"),
                        URLQueryItem(name: "per_page", value: "30"),
        ]
        guard let url = urlComponents.url else { return }
        
        //        var request = URLRequest(url: url)
        //        request.httpMethod = "GET"
        //        request.allHTTPHeaderFields = nil

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print("API Error =", error.localizedDescription)
                completion(nil, error)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                return
            }
            
            switch response.statusCode {
            case 200:
                print("API OK, status: ", response.statusCode)
                guard let data = data else {
                    print("API Get NO Data")
                    return
                }
                do {
//                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
//                    let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                    let repositories = try JSONDecoder().decode(Repositories.self, from: data)
                    print("API Get Data successful")
                    completion(repositories, nil)
                } catch {
                    print("Error", error.localizedDescription)
                    completion(nil, error)
                }
            default:
                print("API Fail, status: ", response.statusCode)
            }
        }.resume()
    }
}
