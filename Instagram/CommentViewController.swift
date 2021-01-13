//
//  CommentViewController.swift
//  Instagram
//
//  Created by takashimakenichi on 2021/01/12.
//  Copyright © 2021 takashimakenichi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import SVProgressHUD

class CommentViewController: UIViewController {
    var postData: PostData!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var commentTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postData.id + ".jpg")
        postImageView.sd_setImage(with: imageRef)

        if let name = postData.name, let caption = postData.caption {
            postTextLabel.text = "\(name) : \(caption)"
        }
    }
    
    // コメントボタン
    @IBAction func hundleCommentButton(_ sender: Any) {
        // documentIDを使用して、すでに保存されている投稿データを上書きしたい
        
        if let comment = commentTextField.text {
            if comment.isEmpty {
                SVProgressHUD.showError(withStatus: "コメントが入力されていません。")
                return
            }
            
            // 投稿データはpostDataに入っているため、ID取得できるのでは？
             if let postData = postData {
                 // Firestoreのインスタンス
                let db = Firestore.firestore()
                let postRef = db.collection(Const.PostPath).document(postData.id)
                 
                // コメントユーザー取得したい
                if let commentUserName = Auth.auth().currentUser?.displayName {
                    
                    let commentDic = [commentUserName:comment]
                    
                    // コメントは配列で複数保存したい / コメントユーザーのIDも保持したい
                    var updateValue: FieldValue
                    updateValue = FieldValue.arrayUnion([commentDic])
                    postRef.updateData(["comments": updateValue])
                    
                    // コメント完了
                    SVProgressHUD.showSuccess(withStatus: "コメントしました")
                    dismiss(animated: true, completion: nil)
                    
                    
                }
                
                

             }
        }
        
        
    }
    
    // キャンセルボタン
    @IBAction func hundleCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
