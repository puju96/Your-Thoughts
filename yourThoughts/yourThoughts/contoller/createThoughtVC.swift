//
//  createThoughtVC.swift
//  yourThoughts
//
//  Created by Apple on 04/12/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Firebase

let DB_REF = Firestore.firestore()



class createThoughtVC: UIViewController  {

    @IBOutlet weak var segmentCategory: UISegmentedControl!
    @IBOutlet weak var postBtn: UIButton!
   
    @IBOutlet weak var thoughtTxt: UITextView!
    @IBOutlet weak var usernameTxt: UITextField!
    
    var selectedCategory = "funny"
    
    override func viewDidLoad() {
        super.viewDidLoad()
     postBtn.layer.cornerRadius = 3
    thoughtTxt.layer.cornerRadius = 3
        thoughtTxt.text = "My Random thoughts..."
        thoughtTxt.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        thoughtTxt.delegate = self
       
    }
    

    @IBAction func postBtnTapped(_ sender: Any) {
        DB_REF.collection(THOUGHTS_REF).addDocument(data: [
            CAT_FIELD : selectedCategory ,
            THOUGHT_FILED : thoughtTxt.text,
            LIKES_FIELD : 0,
            COMMENTS_FIELD : 0,
            TIMESTAMP_FIELD : FieldValue.serverTimestamp(),
            USER_FILED : usernameTxt.text
                 ]) { (error) in
            
            if let error = error {
                print("error while creating document\(error)")
            }else{
                self.navigationController?.popViewController(animated: true)
            }
            
        }
        
    }
    

    @IBAction func categorySelected(_ sender: Any) {
        switch segmentCategory.selectedSegmentIndex {
        case 0:
            selectedCategory = ThoughtCategory.funny.rawValue
        case 1:
            selectedCategory = ThoughtCategory.serious.rawValue
        
        default:
            selectedCategory = ThoughtCategory.crazy.rawValue
        }
    }
}

extension createThoughtVC : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
}
