//
//  commentCell.swift
//  yourThoughts
//
//  Created by Apple on 07/12/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import FirebaseAuth

protocol commentDelegate {
    func commentOptionTapped(comment: Comment)
}

class commentCell: UITableViewCell {

    @IBOutlet weak var optionMenu: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    
    @IBOutlet weak var timestampLbl: UILabel!
    
    @IBOutlet weak var commentLbl: UILabel!
    
    private var comment : Comment!
    private var delegate : commentDelegate?
    
    func configureCell(comment : Comment , delegate : commentDelegate) {
        optionMenu.isHidden = true
        usernameLbl.text = comment.username
        commentLbl.text = comment.comment
        self.comment = comment
        self.delegate = delegate
        let formatter = DateFormatter()
        formatter.dateFormat = "MM d, hh:mm"
        let time = formatter.string(from: comment.time)
        timestampLbl.text = time
        
        if comment.userId == Auth.auth().currentUser?.uid {
            optionMenu.isHidden = false
            optionMenu.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(commentoptionTapped))
            optionMenu.addGestureRecognizer(tap)
        }
       
        
    }
    
    @objc func commentoptionTapped() {
        delegate?.commentOptionTapped(comment: comment)
    }
    

}
