//
//  loginVC.swift
//  yourThoughts
//
//  Created by Apple on 05/12/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import FirebaseAuth

class loginVC: UIViewController {

    @IBOutlet weak var createBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var passTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createBtn.layer.cornerRadius = 4
        loginBtn.layer.cornerRadius = 4
        
    }
    
    @IBAction func loginBtnTapped(_ sender: Any) {
        let email = emailTxt.text
        let password = passTxt.text
        Auth.auth().signIn(withEmail: email!, password: password!) { (authResult, error) in
            if let error = error {
                debugPrint("error \(error)")
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @IBAction func createBtnTapped(_ sender: Any) {
    }
    
}
