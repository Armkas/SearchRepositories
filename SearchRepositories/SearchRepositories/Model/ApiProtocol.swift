//
//  ApiProtocol.swift
//  SearchRepositories
//
//  Created by user on 2021/12/05.
//

import Foundation

protocol ApiProtocol {
    func getRepositories(text: String, completion: @escaping (Repositories?, Error?) -> Void)
}
