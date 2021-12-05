//
//  ViewController.swift
//  SearchRepositories
//
//  Created by user on 2021/12/01.
//

import UIKit
import Foundation

final class ViewController: UIViewController {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private var timer: Timer?
    private var repositories: [Repository] = []
    private var lastSearchedText = ""
    private var isRequesting: Bool = false {
        didSet {
            DispatchQueue.main.async { [self] in
                statusLabel.text = isRequesting ? "Searching..." : ""
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupTableView()
    }
    
    private func setupSearchBar() {
        searchBar.keyboardType = .webSearch
        searchBar.delegate = self
        searchBar.autocapitalizationType = .none
//        searchBar.isSearchResultsButtonSelected = true
//        searchBar.showsSearchResultsButton = true
//        searchBar.showsCancelButton = true
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "Cell", bundle: .main), forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func getKeyword() -> String? {
        // Remove space at the beginning and end of keyword, eg: "  abc  " -> "abc"
        // Guard empty string, eg: ""
        // Guard string that only has whitespace, eg: "   "
        guard let text = searchBar.text else { return nil }
        let keyword = text.trimmingCharacters(in: .whitespaces)
        guard !keyword.isEmpty else { return nil }
        return keyword
    }
    
    @objc func getRepositories() {
        if !isRequesting, // Wait for the server to respond before making the next request
           let text = getKeyword(),
           text != lastSearchedText {
            isRequesting = true
            Api.shared.getRepositories(text: text) { [self] repositories, error in
                self.lastSearchedText = text
                self.isRequesting = false
//                self.searchBar.text = text
                if let repositories = repositories {
                    self.repositories = repositories.items 
                    DispatchQueue.main.async { [self] in
                        self.tableView.reloadData()
                    }
                }
                if let error = error {
                    self.showToast(error.localizedDescription)
                }
            }
        }
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            timeInterval: 0.5,
            target: self,
            selector: #selector(self.getRepositories),
            userInfo: nil,
            repeats: false
        )
    }

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell
        cell.configure(repositories[indexPath.row])
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell: Cell = tableView.cellForRow(at: indexPath) as? Cell {
            cell.openUrl()
        }
    }
}
