//
//  ViewController.swift
//  SearchRepositories
//
//  Created by user on 2021/12/01.
//

import UIKit
import Foundation
import Network

final class ViewController: UIViewController {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    private var timer: Timer?
    private var repositories: [Repository] = []
    private var lastSearchedText = ""
    private var isOnline: Bool = true {
        didSet {
            DispatchQueue.main.async { [self] in
                if isOnline {
                    searchBar.isUserInteractionEnabled = true
                    statusLabel.text = "All Ready!"
                    statusLabel.textColor = .systemGreen
                } else {
                    searchBar.isUserInteractionEnabled = false
                    statusLabel.text = "You are offline please check the network"
                    statusLabel.textColor = .systemRed
                }
            }
        }
    }
    private var isRequesting: Bool = false {
        didSet {
            DispatchQueue.main.async { [self] in
                if isRequesting {
                    statusLabel.text = "Searching..."
                    statusLabel.textColor = .systemYellow
                } else {
                    statusLabel.text = "All Ready!"
                    statusLabel.textColor = .systemGreen
                }
            }
        }
    }
    private var isKeyboardShow = false
    let monitor = NWPathMonitor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupTableView()
        setupNotification()
        setupNetWorkMonitor()
    }
    
    private func setupNotification() {
        // Change the tableView height to prevent coverd by the keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChangeFrame), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
    }
    
    private func setupSearchBar() {
        searchBar.keyboardType = .webSearch // BecauseThe Github repository name must be English
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
                if let repositories = repositories {
                    self.repositories = repositories.items
                    DispatchQueue.main.async { [self] in
                        self.tableView.reloadData()
                    }
                }
                if let error = error {
                    DispatchQueue.main.async { [self] in
                        self.showToast(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard !isKeyboardShow else { return }
        isKeyboardShow = true
        updateKeyboardHeight(notification: notification)
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        guard isKeyboardShow else { return }
        isKeyboardShow = false
        updateKeyboardHeight(notification: notification)
    }
    
    @objc private func keyboardDidChangeFrame(notification: Notification) {
        guard isKeyboardShow else { return }
        updateKeyboardHeight(notification: notification)
    }
    
    private func updateKeyboardHeight(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        let duration : TimeInterval = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        let keyboardHeight: CGFloat = {
            if isKeyboardShow {
                return (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size.height
            } else {
                return 0
            }
        }()
        UIView.animate(withDuration: duration, animations: {
            self.view.layoutIfNeeded()
        })
        tableViewBottomConstraint.constant = keyboardHeight - self.view.safeAreaInsets.bottom
    }
    
    private func setupNetWorkMonitor() {
        monitor.pathUpdateHandler = { [self] path in
            isOnline = path.status == .satisfied
        }
        let queue = DispatchQueue(label: "InternetConnectionMonitor")
        monitor.start(queue: queue)
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            timeInterval: 0.5, // Stop editing for more than 0.5 seconds before requesting the API
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
            cell.openUrl {
                self.searchBar.text = lastSearchedText // When open successfully, corrects the entered text in the search box
            }
        }
    }
}
