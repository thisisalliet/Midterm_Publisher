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
    
    @IBOutlet weak var titleTextField: UITextField!
        
    @IBOutlet weak var categoryTextField: UITextField!
    
    @IBOutlet weak var contentTextField: UITextField!
    
    @IBOutlet weak var postButton: UIButton! {
        
        didSet {
            
            postButton.titleLabel?.text = "POST"
            
            postButton.setTitleColor(.white, for: .normal)
            
            postButton.layer.cornerRadius = 5
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
        setUpNavigationbar()
        
        setUpTabbar()
    }
    
    @IBAction func clickPostButton(_ sender: UIButton) {
        
        addData()
        
        reloadData()
    }
    
    func setUpNavigationbar() {
        
        
        self.navigationController?.navigationItem.title = "Publisher"
        
        self.navigationController?.navigationItem.titleView?.tintColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    func setUpTabbar() {
        
        self.tabBarController?.tabBar.isTranslucent = false
        
        self.tabBarController?.tabBar.backgroundColor = .white

        self.tabBarController?.tabBarItem.image = UIImage(systemName: "square.and.pencil")
    }
    
    func addData() {

        guard let title = titleTextField.text else { return }
        
        guard let category = categoryTextField.text else { return }
        
        guard let content = contentTextField.text else { return }
        
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
        
        titleTextField.reloadInputViews()
        
        categoryTextField.reloadInputViews()
        
        contentTextField.reloadInputViews()
    }
}
