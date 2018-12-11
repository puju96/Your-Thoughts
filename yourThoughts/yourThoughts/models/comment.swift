//
//  comment.swift
//  yourThoughts
//
//  Created by Apple on 07/12/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import Firebase

class Comment {
    
    private (set) var username : String!
    private (set) var time : Date!
    private (set) var comment : String!
    private (set) var documentId : String!
    private (set) var userId : String!
    
    init(username: String, timestamp: Date, comment : String, documentId : String,userId: String) {
        self.username = username
        self.time = timestamp
        self.comment = comment
        self.documentId = documentId
        self.userId = userId
    }
    
   class func parseData(snapshot : QuerySnapshot? ) -> [Comment]{
        var comments = [Comment]()
    guard let dataSnapShot = snapshot else { return comments}
    
    for document in dataSnapShot.documents {
        let data = document.data()
        let username = data[USER_FILED] as? String ?? "Anonymus"
        let comment = data[COMMENT_TXT] as? String ?? ""
        let timestamp = data[TIMESTAMP_FIELD] as? Date ?? Date()
        let documentId = document.documentID
        let userId = data[USER_ID] as? String ?? ""
        let newComment = Comment(username: username, timestamp: timestamp, comment: comment ,documentId : documentId,userId:userId)
        comments.append(newComment)
    }
    
    return comments
    }
}
