//
//  HomeViewController.swift
//  Instagram
//
//  Created by takashimakenichi on 2021/01/04.
//  Copyright © 2021 takashimakenichi. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    // 投稿データを格納する配列
    var postArray: [PostData] = []
    
    // Firestoreのリスナー: Firestoreのデータ更新の監視を行うためのリスナー
    var listener: ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        // カスタムセルを登録
        // xibファイルを読み込み
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        // セルを登録
        tableView.register(nib, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG_PRINT: viewWillAppear")
        
        // Firestoreから投稿データを読み込み、postArrayに格納する処理
        if Auth.auth().currentUser != nil {
            // ログイン済みの場合、データの読み込み（監視）を開始する
            if listener == nil {
                // listener未登録なら、登録してスナップショットを受信する
                // データベースの参照場所と取得順序を指定したクエリの作成
                let postsRef = Firestore.firestore().collection(Const.PostPath).order(by: "date", descending: true)
                // postsRefで取得できるドキュメントをaddSnapshotListenerメソッドで監視
                // → メソッドに指定したクロージャは、ドキュメントが追加されたり更新されたりするたびに何度も更新される
                listener = postsRef.addSnapshotListener() { (querySnapshot, error) in
                    if let error = error {
                        print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                        return
                    }
                    // 取得したdocumentをもとにPostDataを生成し、postArrayの配列にする。
                    // クロージャのquerySnapshotに最新データが入っており、そのdocumentsプロパティにドキュメント（QueryDosumentSnapshot型）の一覧が配列として入っている
                    self.postArray = querySnapshot!.documents.map { document in
                        print("DEBUG_PRINT: documentの取得 \(document.documentID)")
                        let postData = PostData(document: document)
                        return postData
                    }
                    // tableViewの表示を更新
                    self.tableView.reloadData()
                }
            }
            
        } else {
            // ログイン未（またはログアウト済み）
            if listener != nil {
                // listener登録済みの場合、削除してpostArrayをクリアする
                listener.remove()
                listener = nil
                postArray = []
                tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得してデータを設定
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        cell.setPostData(postArray[indexPath.row])
        
        // セル内のいいねボタンのアクションをソースコードで設定
        cell.likeButton.addTarget(self, action: #selector(handleButton(_:forEvent:)), for: .touchUpInside)
        // コメントボタンのアクションを設定
        cell.commentButton.addTarget(self, action: #selector(handleCommentButton(_:forEvent:)), for: .touchUpInside)
        
        return cell
    }
    
    // セル内のいいねボタンがタップされた時に呼ばれるメソッド
    @objc func handleButton(_ sender: UIButton, forEvent event: UIEvent) {
        print("DEBUG_PRINT: likeボタンがタップされました。")
        
        // タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        // タッチした座標(tableView内の座標)を割り出す
        let point = touch!.location(in: self.tableView)
        // タッチした座標がtableView内のどのindexPath内になるかを取得
        let indexPath = tableView.indexPathForRow(at: point)
        
        // 配列からタップされたインデックスのデータを取り出す
        let postData = postArray[indexPath!.row]
        
        // likesを更新する
        if let myid = Auth.auth().currentUser?.uid {
            // 更新データを作成する
            var updateValue: FieldValue
            if postData.isLiked {
                // すでにいいね済みの場合は、いいね解除のためmyidを取り除く更新データを作成
                updateValue = FieldValue.arrayRemove([myid])
            } else {
                // 新たにいいねを押した場合は、myidを追加する更新データを作成
                updateValue = FieldValue.arrayUnion([myid])
            }
            
            // likesに更新データを書き込む
            let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
            postRef.updateData(["likes": updateValue])
        }
    }
    
    // セル内のコメントボタンがタップされた時に呼ばれる
    @objc func handleCommentButton(_ sender: UIButton, forEvent event: UIEvent) {
        print("DEBUG_PRINT: commentボタンがタップされました。")
        
        // タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        // タッチした座標(tableView内の座標)を割り出す
        let point = touch!.location(in: self.tableView)
        // タッチした座標がtableView内のどのindexPath内になるかを取得
        let indexPath = tableView.indexPathForRow(at: point)
        
        // 配列からタップされたインデックスのデータを取り出す
        let postData = postArray[indexPath!.row]
//        print(postData.caption)
        
        if let storyboard = storyboard {
            let commentViewController = storyboard.instantiateViewController(identifier: "Comment") as! CommentViewController
            commentViewController.postData = postData
            present(commentViewController, animated: true, completion: nil)
        }
        

    }

}
