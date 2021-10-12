//
//  ViewController.swift
//  Midterm
//
//  Created by Allie T on 2021/10/11.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class ViewController: UIViewController {
    
    var db: Firestore!
        
    let timestamp = "\(Timestamp(date: Date()))"
    
    var postList = [Post]()

    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
        setUpNavigationbar()
        
        setUpTabbar()
        
        tableview.dataSource = self
        
        tableview.delegate = self
        
        fetchData()
        
        monitorData()
    }
    
    func setUpNavigationbar() {
        
        self.navigationController?.navigationBar.isTranslucent = false

        self.navigationController?.navigationItem.title = "Publisher"
        
        self.navigationController?.navigationItem.titleView?.tintColor = .white
    }
    
    func setUpTabbar() {
        
        self.tabBarController?.tabBar.isTranslucent = false
        
        self.tabBarController?.tabBar.backgroundColor = .white

        self.tabBarController?.tabBarItem.image = UIImage(systemName: "book")
    }
    
    func fetchData() {

        db.collection(CollectionName.articles.rawValue).getDocuments { snapshot, error in

            guard let snapshot = snapshot else { return }

            snapshot.documents.forEach { snapshot in

                guard let post = try? snapshot.data(as: Post.self) else { return }
                print("""
                        title: \(post.title)
                        author: \(post.author)
                        category: \(post.category)
                        content: \(post.content)
                        time: \(post.time)
                        ==============================================
                """)
            }
        }
    }
    
    func monitorData() {
        db.collection(CollectionName.articles.rawValue).addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else { return }
            snapshot.documentChanges.forEach { documentChange in
                switch documentChange.type {
                case .added:
                    guard let post = try? documentChange.document.data(as: Post.self) else { break }
                    print("""
                        title: \(post.title)
                        author: \(post.author)
                        category: \(post.category)
                        content: \(post.content)
                        time: \(post.time)
                        ==============================================
                """)
                case .modified:
                    print("modified")
                case .removed:
                    print("removed")
                }
            }
        }
    }
}


extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return postList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        
        cell.titleLabel.text = postList[indexPath.row].title
        
        cell.authorLabel.text = postList[indexPath.row].author
        
        cell.timeLabel.text = "\(postList[indexPath.row].time)"
        
        cell.contentLabel.text =  postList[indexPath.row].content
        
        cell.categoryLabel.text = postList[indexPath.row].category

        return cell
    }
}


extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 128
    }
}

