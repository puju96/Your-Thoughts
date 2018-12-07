//
//  ViewController.swift
//  yourThoughts
//
//  Created by Apple on 04/12/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Firebase

enum ThoughtCategory : String {
    case funny = "funny"
    case serious = "serious"
    case crazy = "crazy"
    case popular = "popular"
}


class mainVC: UIViewController  {
   
   
    @IBOutlet weak var thoughtCategory: UISegmentedControl!
    @IBOutlet weak var tableview: UITableView!
    var thoughtArray = [Thought]()
    var selectedCategory = ThoughtCategory.funny.rawValue
    var thoughtCollectionRef : CollectionReference!
    var thoughtListner : ListenerRegistration!

 
    
    override func viewDidLoad() {
        super.viewDidLoad()
       tableview.delegate = self
        tableview.dataSource = self
        thoughtCollectionRef = Firestore.firestore().collection(THOUGHTS_REF)
        print("didload array \(thoughtArray)")
        
    }
    override func viewWillAppear(_ animated: Bool) {
//
        setLisner()
          tableview.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        thoughtListner.remove()
    }
    
    @IBAction func categoryChanged(_ sender: Any) {
        switch thoughtCategory.selectedSegmentIndex {
        case 0:
            selectedCategory = ThoughtCategory.funny.rawValue
        case 1:
            selectedCategory = ThoughtCategory.serious.rawValue
        case 2:
            selectedCategory = ThoughtCategory.crazy.rawValue
        default:
            selectedCategory = ThoughtCategory.popular.rawValue
        }
        thoughtListner.remove()
        setLisner()
    }
   


}

extension mainVC : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
      return  1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return thoughtArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableview.dequeueReusableCell(withIdentifier: "thoughtCell", for: indexPath) as? thoughtCell else  { return UITableViewCell() }
        cell.configureCell(thought: thoughtArray[indexPath.row])
        return cell
    }
    
    
}

extension mainVC {
    
    func setLisner() {
        if selectedCategory == ThoughtCategory.popular.rawValue {
            thoughtListner = thoughtCollectionRef.order(by: LIKES_FIELD, descending: true).addSnapshotListener { (dataSnapshot, error) in
                if let error = error {
                    debugPrint("Error in feching data \(error)")
                }
                else{
                    self.thoughtArray.removeAll()
                    self.thoughtArray = Thought.parseData(snapshot: dataSnapshot)
                    self.tableview.reloadData()
                }
                
            }
        }
        else {
            thoughtListner = thoughtCollectionRef.whereField(CAT_FIELD, isEqualTo: selectedCategory).order(by: TIMESTAMP_FIELD, descending: true).addSnapshotListener { (dataSnapshot, error) in
                if let error = error {
                    debugPrint("Error in feching data \(error)")
                }
                else{
                    self.thoughtArray.removeAll()
                    self.thoughtArray = Thought.parseData(snapshot: dataSnapshot)
                    self.tableview.reloadData()
                }
                
            }
        }
     
        
    }
}

