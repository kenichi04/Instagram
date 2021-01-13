//
//  PostData.swift
//  Instagram
//
//  Created by takashimakenichi on 2021/01/10.
//  Copyright © 2021 takashimakenichi. All rights reserved.
//

import UIKit
import Firebase

class PostData: NSObject {
    var id: String
    var name: String?
    var caption: String?
    var date: Date?
    var likes: [String] = []
    var isLiked: Bool = false

    var comments: [[String:String]] = []
    
    init(document: QueryDocumentSnapshot) {
        self.id = document.documentID
        
        // data()メソッドで辞書形式のデータ取得
        let postDic = document.data()
        
        self.name = postDic["name"] as? String
        self.caption = postDic["caption"] as? String
        let timestamp = postDic["date"] as? Timestamp
        self.date = timestamp?.dateValue()
        
        if let likes = postDic["likes"] as? [String] {
            self.likes = likes
        }
        if let myid = Auth.auth().currentUser?.uid {
            // likesの配列の中にmyidが含まれているかチェックすることで、自分がいいねを押しているか判断
            if self.likes.firstIndex(of: myid) != nil {
                // myidが含まれていれば、いいねを押していると認識
                self.isLiked = true
            }
        }
        
        if let comments = postDic["comments"] as? [[String:String]] {
            self.comments = comments
        }
    }
}
