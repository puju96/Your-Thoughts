//
//  Thought.swift
//  yourThoughts
//
//  Created by Apple on 04/12/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import Firebase

class Thought {
    
    private (set) public var documentId : String!
    private (set) public var username : String!
    private (set) public var timestamp : Date!
    private (set) public var thoughtMsg : String!
    private (set) public var likes : Int!
    private (set) public var comments : Int!
    
    init(documentId : String , name: String, time : Date , thought : String, likesNum : Int , commentsNum : Int) {
        self.documentId = documentId
        self.username = name
        self.timestamp = time
        self.thoughtMsg = thought
        self.likes = likesNum
        self.comments = commentsNum
    }
    
    class func parseData (snapshot : QuerySnapshot?) -> [Thought] {
        var thoughtArray = [Thought]()
        guard let dataSnapshot = snapshot else {return thoughtArray}
        let documents = dataSnapshot.documents
        for document in documents {
            let data = document.data()
            let name = data[USER_FILED] as? String ?? "Anonymus"
            let thought = data[THOUGHT_FILED] as? String ?? ""
            let like = data[LIKES_FIELD] as? Int ?? 0
            let comment = data[COMMENTS_FIELD] as? Int ?? 0
            let category = data[CAT_FIELD] as? String ?? ""
            let time = data[TIMESTAMP_FIELD] as? Date ?? Date()
            let documentId = document.documentID
            
            let newThought = Thought(documentId : documentId, name: name, time: time, thought: thought, likesNum: like, commentsNum: comment)
            thoughtArray.append(newThought)
        }
        return thoughtArray
    }
}

