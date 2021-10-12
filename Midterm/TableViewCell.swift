//
//  TableViewCell.swift
//  Midterm
//
//  Created by Allie T on 2021/10/12.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class TableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var authorLabel: UILabel! {
        
        didSet {
            
            authorLabel.text = "Allie"
        }
    }
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!

}
