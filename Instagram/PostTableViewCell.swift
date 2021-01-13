//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by takashimakenichi on 2021/01/10.
//  Copyright © 2021 takashimakenichi. All rights reserved.
//

import UIKit
import FirebaseUI

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // PostDataオブジェクトの内容をセルに表示する
    func setPostData(_ postData: PostData) {
        // 画像の表示（CloudStorageからダウンロード）
        // 画像ダウンロード中であることを示すインジケーターを表示（今回はグレー）
        postImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postData.id + ".jpg")
        // 引数にCloudStorageの画像保存場所を指定することで、UIImageViewに表示）
        // 一度ダウンロードした画像はローカルストレージにキャッシュされるため、２回目以降はキャッシュを使用して素早く表示される
        postImageView.sd_setImage(with: imageRef)
        
        // キャプションの表示
        self.captionLabel.text = "\(postData.name!) : \(postData.caption!)"
        // コメントがある場合は追加する
        if let comments: [[String:String]] = postData.comments {
            if comments.isEmpty {
                commentLabel.text = ""

            } else {
                commentLabel.text! = "< コメント\(comments.count)件 >"
                for comment in comments {
                    
                    for (key, value)  in comment {
                        commentLabel.text! += "\n  (\(key)) \(value)"
                    }
                }
            }

        }
        
        // 日時の表示
        self.dateLabel.text = ""
        if let date = postData.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateString = formatter.string(from: date)
            self.dateLabel.text = dateString
        }
        
        // いいね数の表示
        let likeNumber = postData.likes.count
        likeLabel.text = "\(likeNumber)"
        
        // いいねボタンの表示
        if postData.isLiked {
            // 自分がいいねを押している場合
            let buttonImage = UIImage(named: "like")
            self.likeButton.setImage(buttonImage, for: .normal)
            
        } else {
            let buttonImage = UIImage(named: "like_none")
            self.likeButton.setImage(buttonImage, for: .normal)
        }
        
    }
}
