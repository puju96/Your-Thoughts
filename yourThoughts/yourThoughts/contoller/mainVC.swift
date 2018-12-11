//
//  ViewController.swift
//  yourThoughts
//
//  Created by Apple on 04/12/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

enum ThoughtCategory : String {
    case funny = "funny"
    case serious = "serious"
    case crazy = "crazy"
    case popular = "popular"
}


class mainVC: UIViewController ,thoughtDelegate {
   
    
    @IBOutlet weak var thoughtCategory: UISegmentedControl!
    @IBOutlet weak var tableview: UITableView!
    var thoughtArray = [Thought]()
    var selectedCategory = ThoughtCategory.funny.rawValue
    var thoughtCollectionRef : CollectionReference!
    var thoughtListner : ListenerRegistration!
    var handler : AuthStateDidChangeListenerHandle!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
       tableview.delegate = self
        tableview.dataSource = self
        thoughtCollectionRef = Firestore.firestore().collection(THOUGHTS_REF)
        print("didload array \(thoughtArray)")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        handler = Auth.auth().addStateDidChangeListener({ (auth, user) in
            
            if user == nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginvc = storyboard.instantiateViewController(withIdentifier: "loginVC") as! loginVC
                self.present(loginvc, animated: true, completion: nil)
                
            }else{
                self.setLisner()
            }
        })

        
         
    }
    override func viewWillDisappear(_ animated: Bool) {
        if thoughtListner != nil {
             thoughtListner.remove()
        }
      
    }
    
    func thoughtOptionTapped(thought: Thought) {
        //  code for alert
        
        
        let alert = UIAlertController(title: "Delete", message: "do you want to delete ", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete Thought", style: .default) { (action) in
            self.delete(collection: Firestore.firestore().collection(THOUGHTS_REF).document(thought.documentId).collection(COMMENTS_REF))
            
            Firestore.firestore().collection(THOUGHTS_REF).document(thought.documentId).delete(completion: { (error) in
                if let error = error {
                    debugPrint("error while deleting thought\(error)")
                }else {
                    alert.dismiss(animated: true, completion: nil)
                }
            })
            
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func delete(collection: CollectionReference, batchSize: Int = 100) {
        // Limit query to avoid out-of-memory errors on large collections.
        // When deleting a collection guaranteed to fit in memory, batching can be avoided entirely.
        collection.limit(to: batchSize).getDocuments { (docset, error) in
            // An error occurred.
            let docset = docset
            
            let batch = collection.firestore.batch()
            docset?.documents.forEach { batch.deleteDocument($0.reference) }
            
            batch.commit {_ in
                self.delete(collection: collection, batchSize: batchSize)
            }
        }
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
   
    @IBAction func logoutBtnTapped(_ sender: Any) {
        do{
            try  Auth.auth().signOut()
        }catch {
            print(error)
        }
       
        
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
        cell.configureCell(thought: thoughtArray[indexPath.row] , delegate: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "commentVC", sender: thoughtArray[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "commentVC" {
            if let destinationVC = segue.destination as? commentVC {
                if let thought = sender as? Thought{
                    destinationVC.thought = thought
                }
            }
        }
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
                    print("parse thought array \(self.thoughtArray)")
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

