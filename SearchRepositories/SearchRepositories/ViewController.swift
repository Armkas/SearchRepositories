//
//  ViewController.swift
//  SearchRepositories
//
//  Created by user on 2021/12/01.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        textField.addTarget(self, action: #selector(self.textDidChange(_:)), for: .editingChanged)
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "Cell", bundle: .main), forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @objc private func textDidChange(_ sender: UITextField) {
       print("!@#1")
        //这里设定显示小菊花,小菊花消失了才访问服务器,免得重复访问
        getData()
    }
    
    func getData() {
        
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

extension ViewController: UITableViewDelegate {

}

