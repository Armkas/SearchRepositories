//
//  DataProvider.swift
//  SearchRepositoriesTests
//
//  Created by user on 2021/12/05.
//

import Foundation

class DataProvider {
    static func jsonData(from filename: String) -> Data? {
        guard let filePath = Bundle(for: DataProvider.self).path(forResource: filename, ofType: "json") else {
            return nil
        }
        do {
            let contents = try Data(contentsOf: URL(fileURLWithPath: filePath))
            return contents
        } catch {
            return nil
        }
    }
}
