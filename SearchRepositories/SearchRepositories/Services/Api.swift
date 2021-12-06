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
        guard let url = Url.init(text).url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
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
