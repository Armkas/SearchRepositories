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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(_ repository: Repository) {
        self.title.text = repository.name
        self.detail.text = repository.full_name
    }
}
