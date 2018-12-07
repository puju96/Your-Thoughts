//
//  loginVC.swift
//  yourThoughts
//
//  Created by Apple on 05/12/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

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
    }
    
    
    @IBAction func createBtnTapped(_ sender: Any) {
    }
    
}
