//
//  InputViewController.swift
//  taskapp
//
//  Created by swans on 2019/09/25.
//  Copyright © 2019 swans. All rights reserved.
//

import UIKit
import RealmSwift
class InputViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    let realm = try! Realm()
    var task: Task!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //背景をタップしたらdismissKeyboardメソッドを呼ぶように設定する
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        titleTextField.text = task.title
        contentsTextView.text = task.contents
        datePicker.date = task.date

        // Do any additional setup after loading the view.
    }
    @objc func dismissKeyboard(){
        //キーボードを閉じる
        view.endEditing(true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        try! realm.write {
            self.task.title = self.titleTextField.text!
            self.task.date = self.datePicker.date
            self.realm.add(self.task, update: true)
        }
        super.viewWillDisappear(animated)
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
