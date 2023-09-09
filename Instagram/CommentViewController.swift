//
//  CommentViewController.swift
//  Instagram
//
//  Created by mawincommon on 2023/09/07.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import SVProgressHUD

class CommentViewController: UIViewController{
     
    var postId: String!
        
    @IBOutlet weak var commentTextField: UITextField!
    
    
    /*
     コメント入力画面でキャンセルが押されたときの動作
     */
    @IBAction func hundleCommentCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
     コメント画面で投稿のボタンが押されたときの動作
     */
    @IBAction func hundleComment(_ sender: Any) {
        
        // HUDで投稿処理中の表示を開始
        SVProgressHUD.show()
        
        if let submitText = commentTextField.text {
            
            // コメント入力欄のチェックとメッセージ
            if submitText.isEmpty {
                SVProgressHUD.showError(withStatus: "コメントを入力して下さい")
                return
            }
            
            // ユーザーIDと名前の取得
            let postRef = Firestore.firestore().collection(Const.PostPath).document(postId)
            let userName = Auth.auth().currentUser?.displayName
            
            // 更新データ作成
            let commentData:Dictionary = ["name":userName,"content":submitText]
            let updateValue = FieldValue.arrayUnion([commentData])
            
            postRef.updateData(["comments":updateValue])
            // HUDで投稿完了を表示
            SVProgressHUD.showSuccess(withStatus: "投稿しました")
  
            // 投稿処理完了後、先頭画面に戻る
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            let window = windowScene?.windows.first
            window?.rootViewController?.dismiss(animated: true, completion: nil)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

}
