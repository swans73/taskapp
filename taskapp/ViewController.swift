//
//  ViewController.swift
//  taskapp
//
//  Created by swans on 2019/09/23.
//  Copyright © 2019 swans. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet weak var tableView: UITableView!
    //Realmインスタンスを取得する
    let realm = try! Realm()
    //DB内のタスクが格納されるリスト。
    //日付近い順\順でソート：降順
    //以降内容をアップデートするとリスト内容は自動的に更新される。
    var taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: false)
    var taskCategory = try! Realm().objects(Task.self).filter("category = %@", "searchBar.text")
    
    // segueで画面遷移するときに呼ばれる
    override func prepare(for segue:UIStoryboardSegue, sender: Any?) {
        let inputViewController:InputViewController = segue.destination as! InputViewController
        if segue.identifier == "cellSegue" {
            let indexPath = self.tableView.indexPathForSelectedRow
            inputViewController.task = taskArray[indexPath!.row]
        } else {
            let task = Task()
            task.date = Date()
            
            let allTasks = realm.objects(Task.self)
            if allTasks.count != 0 {
                task.id = allTasks.max(ofProperty: "id")! + 1
            }
            inputViewController.task = task
        }
    }
    // 入力画面から戻ってきたときに TableView を更新させる
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
    @IBOutlet weak var searchBar: UISearchBar!
    var searchFlag: Bool = false
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchFlag = true
        if let kensaku = searchBar.text {
            let jyutugo = NSPredicate(format: "category = %@", kensaku)
            taskCategory = try! Realm().objects(Task.self).filter(jyutugo)
            tableView.reloadData()
        } else {
            tableView.reloadData()
        }
        
    }
//    //検索バーを押した時の処理
//    func searchBarTextDidEditing(searchBar: UISearchBar) {
//
//    }
    //検索をキャンセルした時の処理
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchFlag = false
    }
    // MARK: UITableViewDataSourceプロトコルのメソッド
    // データの数（＝セルの数）を返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchFlag == true {
            return taskCategory.count
        } else {
            return taskArray.count
        }
        
    }
    // 各セルの内容を返すメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 再利用可能なcellを得る
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        // Cellに値を設定する
        if searchFlag == true {
            let task = taskCategory[indexPath.row]
            cell.textLabel?.text = "\(task.title) \(task.category)"
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateString:String = formatter.string(from: task.date)
            cell.detailTextLabel?.text = dateString
            return cell
        } else {
        let task = taskArray[indexPath.row]
        cell.textLabel?.text = "\(task.title) \(task.category)"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString:String = formatter.string(from: task.date)
        cell.detailTextLabel?.text = dateString
        }
        return cell
    }
    //MARK: UITableViewDelegateプロトコルのメソッド
    //各セルを選択したときに実行されるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "cellSegue", sender: nil)
    }
    // セルが削除可能なことを伝えるメソッド
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    //Deleteボタンが押されたときに呼ばれるメソッド
    func tableView(_ tableView:UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       
        if editingStyle == .delete {
            // 削除するタスクを取得する
            let task = self.taskArray[indexPath.row]
            //ローカル通知をキャンセルする
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [String(task.id)])
            //データベースから削除する
            try! realm.write {
                self.realm.delete(self.taskArray[indexPath.row])
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            //未通知のローカル通知一覧をログ出力
            center.getPendingNotificationRequests {(requests: [UNNotificationRequest]) in
                for request in requests {
                    print("/------------")
                    print(request)
                    print("------------/")
                }
            }
        }
    }
}

