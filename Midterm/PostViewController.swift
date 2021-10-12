//
//  PostViewController.swift
//  Midterm
//
//  Created by Allie T on 2021/10/12.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class PostViewController: UIViewController {
    
    var db: Firestore!
    
    let timeStamp = Timestamp(date: Date())
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var postButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
    }
    
    @IBAction func clickPostButton(_ sender: UIButton) {
        
        addData()
        reloadData()
    }
    
    func addData() {
        
        guard let title = titleLabel.text else { return }
        
        guard let category = categoryLabel.text else { return }
        
        guard let content = contentTextView.text else { return }
        
        let id = db.collection(CollectionName.articles.rawValue).document().documentID
        
        let newPost = Post(
            author: "Allie",
            category: category,
            content: content,
            time: timeStamp,
            title: title)
        
        do {
            try db.collection(CollectionName.articles.rawValue).document(id).setData(from: newPost)
            
        } catch let error {
            
            print(error)
        }
    }
    
    func reloadData() {
        
        titleLabel.reloadInputViews()
        
        categoryLabel.reloadInputViews()
        
        contentTextView.reloadInputViews()
    }
}
