//
//  Repositories.swift
//  SearchRepositories
//
//  Created by user on 2021/12/04.
//

import Foundation

struct Repositories: Codable {
    let total_count: Int
    let incomplete_results: Bool
    let items: [Repository]
}

struct Repository: Codable {
    let name: String
    let full_name: String
    let html_url: String
}
