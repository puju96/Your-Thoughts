//
//  Dataservice.swift
//  yourThoughts
//
//  Created by Apple on 04/12/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import Firebase


let  thoughtCollectionRef = Firestore.firestore().collection(THOUGHTS_REF)
class Dataservice {
    
    static let instance = Dataservice()

    
    func getAllThoughts(handler: @escaping (_ thoughts: [Thought]) ->()) {
        var thoughtArray = [Thought]()
        
        thoughtCollectionRef.addSnapshotListener { (dataSnapshot, error) in
                        if let error = error {
                            debugPrint("Error in feching data \(error)")
                        }
                        else{
                             guard let dataSnapshot = dataSnapshot else {return}
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
                        }
            handler(thoughtArray)
            
        }

}
}
        
//        thoughtCollectionRef.getDocuments { (dataSnapshot, error) in
//            if let error = error {
//                debugPrint("Error in feching data \(error)")
//            }
//            else{
//                 guard let dataSnapshot = dataSnapshot else {return}
//                let documents = dataSnapshot.documents
//                for document in documents {
//                    let data = document.data()
//                    let name = data[USER_FILED] as? String ?? "Anonymus"
//                    let thought = data[THOUGHT_FILED] as? String ?? ""
//                    let like = data[LIKES_FIELD] as? Int ?? 0
//                    let comment = data[COMMENTS_FIELD] as? Int ?? 0
//                    let category = data[CAT_FIELD] as? String ?? ""
//                    let time = data[TIMESTAMP_FIELD] as? Date ?? Date()
//                    let documentId = document.documentID
//
//                    let newThought = Thought(documentId : documentId, name: name, time: time, thought: thought, likesNum: like, commentsNum: comment)
//                    thoughtArray.append(newThought)
//                    }
//            }
//
//            handler(thoughtArray)
//        }
        

