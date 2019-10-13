//
//  CategoryViewController.swift
//  taskapp
//
//  Created by swans on 2019/10/13.
//  Copyright © 2019 swans. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class CategoryViewController: UIViewController {
    @IBOutlet weak var categoryTextField: UITextField!
    
    let realm = try! Realm()
    var task2: Category!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //背景をタップしたらdismissKeyboardメソッドを呼ぶように設定する
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        categoryTextField.text = task2.category

        // Do any additional setup after loading the view.
    }
    //遷移する際に、画面が非表示になるとき呼ばれるメソッド
    override func viewWillDisappear(_ animated: Bool) {
        try! realm.write {
            self.task2.category = self.categoryTextField.text!
        }
        setNotification(task2: Category)
        super.viewWillDisappear(animated)
    }
    //タスクのローカル通知を登録する
    func setNotification(task2: Category){
        let content = UNMutableNotificationContent()
        //タイトルと内容を設定(中身がない場合メッセージなしで音だけでの通知となるので（xxなし）を表示する)
        
        if task2.category == "" {
            content.summaryArgument = "(カテゴリなし)"
        } else {
            content.summaryArgument = task2.category
        }
        
        content.sound = UNNotificationSound.default
       
    }
    
    @objc func dismissKeyboard() {
        //キーボードを閉じる
        view.endEditing(true)
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
