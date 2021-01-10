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
    }
    
    // キャンセルボタンタップ時
    @IBAction func handleCancelButton(_ sender: Any) {
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
