//
//  MockAPI.swift
//  SearchRepositoriesTests
//
//  Created by user on 2021/12/05.
//

import Foundation
@testable import SearchRepositories

class MockApi {
    var shouldReturnError = false
    var wasGot = false
    
    func reset() {
        shouldReturnError = false
        wasGot = false
    }
        
    convenience init() {
        self.init(false)
    }
    
    init(_ shouldReturnError: Bool) {
        self.shouldReturnError = shouldReturnError
    }
    
}

extension MockApi: ApiProtocol {
    func getRepositories(text: String, completion: @escaping (Repositories?, Error?) -> Void) {
        wasGot = true
        do {
            let data = DataProvider.jsonData(from: "MockData")
            let repositories: Repositories = try JSONDecoder().decode(Repositories.self, from: data!)
            completion(repositories, nil)
        } catch {
            completion(nil, error)
        }
    }
}
