//
//  ViewController.swift
//  Midterm
//
//  Created by Allie T on 2021/10/11.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class BrowseViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var scrollToTopButton: UIButton! {
        
        didSet {
            
            scrollToTopButton.imageView?.contentMode = .scaleAspectFill
        }
    }
    
    var db: Firestore!
        
    var postList = [Post]() {
        
        didSet {
            tableview.reloadData()
        }
    }
    
    let timestamp = "\(Timestamp(date: Date()))"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
        setUpNavigationBar()
        
        setUpTabBar()
        
        tableview.dataSource = self
        
        tableview.delegate = self
        
        fetchData()
        
        monitorData()
    }
    
    @IBAction func clickAddButton(_ sender: UIButton) {
        
        let indexPath = IndexPath(row: 0, section: 0)
        
        tableview.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    func setUpNavigationBar() {
        
        self.navigationController?.navigationBar.isTranslucent = false

        self.navigationController?.navigationItem.title = "Publisher"
        
        self.navigationController?.navigationItem.titleView?.tintColor = .white
    }
    
    func setUpTabBar() {
        
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
            
            self.showPost()
        }
    }
    
    func showPost() {
        
        db.collection(CollectionName.articles.rawValue).getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            let allPost = snapshot.documents.compactMap { snapshot in
                try? snapshot.data(as: Post.self)
            }
            print(allPost)
            self.postList = allPost
        }
    }
}


extension BrowseViewController: UITableViewDataSource {
    
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


extension BrowseViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 128
    }
}

