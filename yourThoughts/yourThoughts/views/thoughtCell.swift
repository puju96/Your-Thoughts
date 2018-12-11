//
//  thoughtCell.swift
//  yourThoughts
//
//  Created by Apple on 04/12/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

//when we click on option button then altert should come for that we need delegate

protocol thoughtDelegate {
    func thoughtOptionTapped(thought :Thought)
}

class thoughtCell: UITableViewCell {

    @IBOutlet weak var optionMenu: UIImageView!
    @IBOutlet weak var commentNum: UILabel!
    @IBOutlet weak var nameTxt: UILabel!
    @IBOutlet weak var commentImg: UIImageView!
    
    @IBOutlet weak var timeTxt: UILabel!
    
    @IBOutlet weak var thoughtTxt: UILabel!
    
    @IBOutlet weak var likeImg: UIImageView!
    @IBOutlet weak var likesnum: UILabel!
    
    private var thought : Thought!
    private var delegate : thoughtDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        likeImg.addGestureRecognizer(tap)
        likeImg.isUserInteractionEnabled = true
    }
    
    @objc func likeTapped() {
        
    Firestore.firestore().document("Thoughts/\(thought.documentId!)").updateData([LIKES_FIELD : thought.likes + 1 ])
        
        
    }
    
    func configureCell (thought : Thought , delegate :thoughtDelegate){
        optionMenu.isHidden = true
        self.thought = thought
        self.delegate = delegate
        nameTxt.text = thought.username
        thoughtTxt.text = thought.thoughtMsg
        likesnum.text = String(thought.likes)
        commentNum.text = String(thought.comments)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, hh:mm"
        let timestamp = formatter.string(from: thought.timestamp)
        timeTxt.text = timestamp
        
        if thought.userId == Auth.auth().currentUser?.uid{
            optionMenu.isHidden = false
            let tap = UITapGestureRecognizer(target: self, action: #selector(thoughtoptionTapped))
            optionMenu.isUserInteractionEnabled = true
            optionMenu.addGestureRecognizer(tap)
        }
    }
    
    @objc func thoughtoptionTapped() {
        delegate?.thoughtOptionTapped(thought: thought)
        
    }
    
}
