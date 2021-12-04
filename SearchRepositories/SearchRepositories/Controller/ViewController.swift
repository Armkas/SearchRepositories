//
//  ViewController.swift
//  SearchRepositories
//
//  Created by user on 2021/12/01.
//

import UIKit
import Foundation

final class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var timer: Timer?
    var searchRepository: [NSDictionary] = []
    private var lastSearchedText = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupTableView()
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
//        searchBar.isSearchResultsButtonSelected = true
//        searchBar.showsSearchResultsButton = true
//        searchBar.showsCancelButton = true
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "Cell", bundle: .main), forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
    }
    
    @objc func getRepositories() {
        if let text = searchBar.text,
           text != lastSearchedText,
           text != "" {
            API.shared.getRepositories(text)
            lastSearchedText = text
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
    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        timer?.invalidate()
//        timer = Timer.scheduledTimer(
//            timeInterval: 0.5,
//            target: self,
//            selector: #selector(self.getRepositories),
//            userInfo: nil,
//            repeats: false
//        )
//    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchRepository.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell
        let dictionary: NSDictionary = searchRepository[indexPath.row]
        cell.textLabel?.text = dictionary["name"] as? String
        cell.detailTextLabel?.text = dictionary["full_name"] as? String
        return cell
    }
}
