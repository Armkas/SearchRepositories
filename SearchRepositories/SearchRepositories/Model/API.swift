//
//  API.swift
//  SearchRepositories
//
//  Created by user on 2021/12/02.
//

import Foundation

final class API {
    
    static let shared = API()
    
    func getRepositories(_ text: String) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.github.com"
        urlComponents.path = "/search/repositories"
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: "\(text)"),
            //            URLQueryItem(name: "sort", value: "desc"),
            //            URLQueryItem(name: "order", value: "best match"),
            //            URLQueryItem(name: "page", value: "1"),
            //            URLQueryItem(name: "per_page", value: "30"),
        ]
        guard let url = urlComponents.url else { return }
        
        //        var request = URLRequest(url: url)
        //        request.httpMethod = "GET"
        //        request.allHTTPHeaderFields = nil

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print("API Error =", error.localizedDescription)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("API Get Nothing")
                return
            }
            
            if response.statusCode == 200 {
                print("API OK")
                guard let data = data else {
                    print("API Get NO Data")
                    return
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                    print("API Get Data successful" , json)
                } catch {
                    print("API Get Wrong Data")
                }
            }
            print("API Fail", response.statusCode)
        }.resume()
        
    }
}
