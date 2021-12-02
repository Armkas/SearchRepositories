//
//  ViewController.swift
//  SearchRepositories
//
//  Created by user on 2021/12/01.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "Cell", bundle: .main), forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
    }
    
    @objc func getRepositories(_ searchBar: UISearchBar) {
        print("!@#$")
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            timeInterval: 0.5,
            target: self,
            selector: #selector(self.getRepositories(_:)),
            userInfo: nil,
            repeats: false
        )
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell
    }
}
