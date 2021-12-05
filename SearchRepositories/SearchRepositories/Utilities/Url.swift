//
//  Url.swift
//  SearchRepositories
//
//  Created by user on 2021/12/06.
//

import Foundation

struct Url {
    var scheme: String = "https"
    var host: String = "api.github.com"
    var path: String = "/search/repositories"
    var queryItems: [URLQueryItem]
    var url: URL?
}

extension Url {
    init(_ q: String) {
        queryItems = [
            URLQueryItem(name: "q", value: "\(q)"),
            URLQueryItem(name: "sort", value: "desc"),
            URLQueryItem(name: "order", value: "best match"),
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "per_page", value: "30"),
        ]
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = queryItems
        
        self.url = urlComponents.url
    }
}
