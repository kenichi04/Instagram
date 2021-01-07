//
//  TabBarController.swift
//  Instagram
//
//  Created by takashimakenichi on 2021/01/05.
//  Copyright © 2021 takashimakenichi. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // タブアイコンの色
        self.tabBar.tintColor = UIColor(red: 1.0, green: 0.44, blue: 0.11, alpha: 1)
        // タブバーの背景色
        self.tabBar.barTintColor = UIColor(red: 0.96, green: 0.91, blue: 0.87, alpha: 1)
        // UITabBarControllerDelegateプロトコルのメソッドをこのクラスで処理
        self.delegate = self
    }
    
    // タブバーのアイコンがタップされた時に呼ばれるdelegateメソッド,タブを切り返して良いか否かを返す
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        // ImageSelectViewControllerは、タブ切り替えでなくモーダル画面遷移
        // viewControllerに切り替え先のviewが入っているので、クラスを判断する
        if viewController is ImageSelectViewController {
            let imageSelectViewController = storyboard!.instantiateViewController(identifier: "ImageSelect")
            
            present(imageSelectViewController, animated: true)
            
            return false
            
        } else {
            // その他のviewControllerは通常のタブ切り替え
            return true
        }
    }

}
