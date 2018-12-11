//
//  createUserVC.swift
//  yourThoughts
//
//  Created by Apple on 05/12/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class createUserVC: UIViewController {

    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var createBtn: UIButton!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        createBtn.layer.cornerRadius = 4
        cancelBtn.layer.cornerRadius = 4
        
    }
    
    @IBAction func createBtnTapped(_ sender: Any) {
        let email = emailTxt.text
        let password = passTxt.text
        let username = usernameTxt.text
        Auth.auth().createUser(withEmail: email!, password: password!) { (AuthDataResult, error) in
            let user = AuthDataResult?.user
            if let error = error {
                debugPrint(error)
            }
            
            let changeRequest = user?.createProfileChangeRequest()
            changeRequest?.displayName = username
            changeRequest?.commitChanges(completion: { (error) in
                if let error = error {
                    debugPrint("there is an error \(error.localizedDescription)")
                }
            })
            
            guard let userId = user?.uid  else { return }
            
            Firestore.firestore().collection(USER_REF).document(userId).setData([ USER_FILED : username!,
                DATE_CREATED : FieldValue.serverTimestamp()
                            ],
                completion: { (error) in
                if let error = error {
                    debugPrint(error)
                }
                else {
                    self.dismiss(animated: true, completion: nil)
                    }
            })
        }
        
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
