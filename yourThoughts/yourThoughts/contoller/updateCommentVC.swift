//
//  updateCommentVC.swift
//  yourThoughts
//
//  Created by Apple on 11/12/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Firebase
class updateCommentVC: UIViewController {
    
    @IBOutlet weak var commentTxt: UITextView!
    @IBOutlet weak var updateBtn: UIButton!
    
    var commentData : (comment: Comment, thought: Thought)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTxt.layer.cornerRadius = 4
        updateBtn.layer.cornerRadius = 4
        commentTxt.text = commentData.comment.comment
    }
    
    @IBAction func updateBtnTapped(_ sender: Any) {
        Firestore.firestore().collection(THOUGHTS_REF).document(commentData.thought.documentId).collection(COMMENTS_REF).document(commentData.comment.documentId).updateData([COMMENT_TXT : commentTxt.text]) { (error) in
            
            if let error = error {
                debugPrint("error \(error)")
            }else {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
}
