//
//  commentVC.swift
//  yourThoughts
//
//  Created by Apple on 07/12/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class commentVC: UIViewController , commentDelegate {
    
    
    
    var thought : Thought!
    var commentArray = [Comment]()
    var thoughtRef : DocumentReference!
    var userName : String!
    var commentListner :ListenerRegistration!
   
    
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var commentTxt: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        commentTxt.bindToKeyboard()
        addBtn.bindToKeyboard()
        thoughtRef =    Firestore.firestore().collection(THOUGHTS_REF).document(thought.documentId)
        
        if let name = Auth.auth().currentUser?.displayName {
            userName = name
        }
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        commentListner = Firestore.firestore().collection(THOUGHTS_REF).document(thought.documentId).collection(COMMENTS_REF).order(by: TIMESTAMP_FIELD, descending: false).addSnapshotListener({ (snapShot, error) in

            if let error = error {
                debugPrint("Error while adding comment \(error)")
            }
            else{
                self.commentArray.removeAll()
               
                self.commentArray = Comment.parseData(snapshot: snapShot!)
               
                self.tableView.reloadData()

            }
        })
        
        
    }
    
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        commentListner.remove()
    }
    
    func commentOptionTapped(comment: Comment) {
        
        // code for alert
        let alert = UIAlertController(title: "Edit Comment", message: "you can edit or delete", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { (action) in
            // delete action
            let docRef = Firestore.firestore().collection(THOUGHTS_REF).document(self.thought.documentId)
            
            Firestore.firestore().runTransaction({ (transaction, error) -> Any? in
                
                let thoughDocument : DocumentSnapshot
                do {
                    try thoughDocument = transaction.getDocument(docRef)
                }catch let fetchError as NSError{
                    debugPrint("error while reading data\(fetchError)")
                    return nil
                }
                
                guard let oldCommentNum = thoughDocument.data()![COMMENTS_FIELD] as? Int else { return nil}
                
                transaction.updateData([COMMENTS_FIELD : oldCommentNum - 1], forDocument: self.thoughtRef)
                return nil
                
            }) { (obj, err) in
                if let error = err {
                    debugPrint("Transaction failed \(error)")
                }
                else{
                    docRef.collection(COMMENTS_REF).document(comment.documentId).delete(completion: { (error) in
                        if let error = error {
                            debugPrint("error \(error)")
                        }
                        else {
                            alert.dismiss(animated: true, completion: nil)
                        }
                    })
                }
                
            }
            
            
            
        }
        let editAction = UIAlertAction(title: "Edit", style: .default) { (action) in
            // edit action
            self.performSegue(withIdentifier: "updateComment", sender: (comment , self.thought))
            
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(deleteAction)
        alert.addAction(editAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? updateCommentVC {
            if let commentData = sender as? (comment: Comment , thought: Thought) {
                destinationVC.commentData = commentData
            }
        }
    }
    
    @IBAction func AddBtnTapped(_ sender: Any) {
        guard let commenTxt = commentTxt.text else { return }
        
        let docRef = Firestore.firestore().collection(THOUGHTS_REF).document(self.thought.documentId)
        
        Firestore.firestore().runTransaction({ (transaction, error) -> Any? in
            
            let thoughDocument : DocumentSnapshot
            do {
                try thoughDocument = transaction.getDocument(docRef)
            }catch let fetchError as NSError{
                debugPrint("error while reading data\(fetchError)")
                return nil
            }
            
            guard let oldCommentNum = thoughDocument.data()![COMMENTS_FIELD] as? Int else { return nil}
            
            transaction.updateData([COMMENTS_FIELD : oldCommentNum + 1], forDocument: self.thoughtRef)
            
            let newCommentRef =   Firestore.firestore() .collection(THOUGHTS_REF).document(self.thought.documentId).collection(COMMENTS_REF).document()
            
            transaction.setData([
                COMMENT_TXT : commenTxt,
                TIMESTAMP_FIELD : FieldValue.serverTimestamp(),
                USER_FILED : self.userName,
                USER_ID : Auth.auth().currentUser?.uid
                ], forDocument: newCommentRef)
            
            return nil
        }) { (obj, err) in
            if let error = err {
                debugPrint("Transaction failed \(error)")
            }
            else{
                self.commentTxt.text = ""
                print("comment added successfully")
            }
            
        }
        
        
    }
    
}

extension commentVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as? commentCell else { return UITableViewCell() }
        
        cell.configureCell(comment: commentArray[indexPath.row] , delegate: self)
        return cell
    }
    
    
}
