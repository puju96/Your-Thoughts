//
//  thoughtCell.swift
//  yourThoughts
//
//  Created by Apple on 04/12/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Firebase
class thoughtCell: UITableViewCell {

    @IBOutlet weak var nameTxt: UILabel!
    
    @IBOutlet weak var timeTxt: UILabel!
    
    @IBOutlet weak var thoughtTxt: UILabel!
    
    @IBOutlet weak var likeImg: UIImageView!
    @IBOutlet weak var likesnum: UILabel!
    
    private var thought : Thought!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        likeImg.addGestureRecognizer(tap)
        likeImg.isUserInteractionEnabled = true
    }
    
    @objc func likeTapped() {
        
    Firestore.firestore().document("Thoughts/\(thought.documentId!)").updateData([LIKES_FIELD : thought.likes + 1 ])
        
        
    }
    
    func configureCell (thought : Thought){
        self.thought = thought
        nameTxt.text = thought.username
        thoughtTxt.text = thought.thoughtMsg
        likesnum.text = String(thought.likes)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, hh:mm"
        let timestamp = formatter.string(from: thought.timestamp)
        timeTxt.text = timestamp
    }
    
}
