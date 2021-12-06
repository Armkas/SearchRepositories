//
//  Cell.swift
//  SearchRepositories
//
//  Created by user on 2021/12/02.
//

import Foundation
import UIKit

class Cell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var detail: UILabel!
    
    private var urlString: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        urlString = ""
    }
    
    func configure(_ repository: Repository) {
        self.title.text = repository.name
        self.detail.text = repository.full_name
        self.urlString = repository.html_url
    }
    
    func openUrl(callBack: () -> Void) {
        // Open url by Safari
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
            callBack()
        }
    }
}
