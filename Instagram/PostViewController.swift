//
//  PostViewController.swift
//  Instagram
//
//  Created by takashimakenichi on 2021/01/04.
//  Copyright © 2021 takashimakenichi. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class PostViewController: UIViewController {
    // imageSelectViewControllerでimageに画像が格納される
    var image: UIImage!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // imageSelectViewControllerから受け取ったimageを設定する
        imageView.image = image
    }
    
    // 投稿ボタンタップ時
    @IBAction func handlePostButton(_ sender: Any) {
        // 画像をjpeg形式に変換
        let imageData = image.jpegData(compressionQuality: 0.75)
        // 画像と投稿データの保存場所を定義
        /* Firestoreに保存する投稿データの保存場所
           Firestore.firestore()でインスタンス初期化
           Cloudstoreはデータをドキュメントに保存.ドキュメントはコレクションに保存される
        */
        let postRef = Firestore.firestore().collection(Const.PostPath).document()
        /* Storageに保存する画像の保存場所
           referenceメソッドで参照を作成（≒クラウド内のファイルへのポインタ）
           既存の参照でchildメソッドを使い、ツリーの下位への参照を作成
        */
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postRef.documentID + ".jpg")
        
        // HUDで投稿処理中の表示を開始
        SVProgressHUD.show()
        // Storageに画像をアップロード
        // ファイル形式を指定
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        // putdataメソッドは、アップロード完了すると呼び出されるクロージャを最終引数に指定
        imageRef.putData(imageData!, metadata: metadata) { (metadata, error) in
            if error != nil {
                // 画像のアップロード失敗
                print(error!)
                SVProgressHUD.showError(withStatus: "画像のアップロードが失敗しました")
                // 投稿をキャンセルし、先頭画面に戻る
                UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
                return
            }
            
            // Firestoreに投稿データを保存
            let name = Auth.auth().currentUser?.displayName
            //
            let postDic = [
                "name": name!,
                "caption": self.textField.text!,
                "date": FieldValue.serverTimestamp(),  // Firestoreのサーバー上の時計を使用して日時を保存
                ] as [String: Any]
            // 保存するデータを辞書の形で引数に渡すことで、firestoreにデータを保存できる
            postRef.setData(postDic)
            
            // HUDで投稿完了を表示
            SVProgressHUD.showSuccess(withStatus: "投稿しました")
            // 投稿が完了したので先頭画面に戻る
            UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    // キャンセルボタンタップ時
    @IBAction func handleCancelButton(_ sender: Any) {
        // ひとつ前の加工画面に戻し、追加編集できるようにする
        self.dismiss(animated: true, completion: nil)
    }

}
