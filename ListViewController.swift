//
//  ListViewController.swift
//  FirebaseSample
//
//  Created by tkwatanabe on 2017/07/07.
//  Copyright © 2017年 tkwatanabe. All rights reserved.
//

import UIKit
import Firebase

class ListViewController: UIViewController {

    @IBOutlet weak var table: UITableView!

    //Fetchしたデータを格納する配列(TableViewで表示するデータ)
    var contentArray: [DataSnapshot] = []

    var snap: DataSnapshot!

    //変更時用変数(セルタップ時にデータを格納する)
    var selectSnap: DataSnapshot!

    //Firebase Databaseのルートを指定
    let ref = Database.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.read()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //Cellの高さを調整
        table.estimatedRowHeight = 56
        table.rowHeight = UITableViewAutomaticDimension
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //画面が消えたときに、Firebaseのデータ読み取りのObserverを削除しておく
        ref.removeAllObservers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: - アプリケーションロジック
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        self.transition()
    }

    func transition() {
        self.performSegue(withIdentifier: "PushToDetail", sender: self)
    }

    func read() {
        ref.child((Auth.auth().currentUser?.uid)!)
            .observe(.value, with: { snapShots in
                if snapShots.children.allObjects is [DataSnapshot] {
                    print("snapShots.children...\(snapShots.childrenCount)")
                    print("snapShots...\(snapShots)")
                    self.snap = snapShots
                }
                self.reload(snap: self.snap)
            })
    }

    func reload(snap: DataSnapshot) {
        if snap.exists() {
            print(snap)
            contentArray.removeAll()
            for item in snap.children {
                contentArray.append(item as! DataSnapshot)
            }
            //ローカルデータベースを更新
            ref.child((Auth.auth().currentUser?.uid)!).keepSynced(true)
            //テーブルビューをリロード
            self.table.reloadData()
        }
    }

    //timestampで保存されている投稿時間を年月日に表示形式を変換する
    func getDate(number: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: number)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter.string(from: date)
    }

    func didSelectRow(selectedIndexPath indexPath: IndexPath) {
        //ルートからのchildをユーザIDに指定
        //ユーザIDからのchildを選択されたCellのデータのIDに指定
        self.selectSnap = self.contentArray[indexPath.row]
        self.transition()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PushToDetail" {
            let view = segue.destination as! ViewController
            if let snap = self.selectSnap {
                view.selectSnap = snap
            }
        }
    }
}

extension ListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "ListCell") as! ListTableViewCell

        //配列の該当のデータをitemという定数に代入
        let item = contentArray[indexPath.row]
        //itemの中身を辞書型に変換
        let content = item.value as! Dictionary<String, AnyObject>
        //contentという添字で保存していた投稿内容を表示
        cell.contentLabel.text = String(describing: content["context"]!)
        //dateという添字で保存していた投稿時間をtimeという定数に代入
        let time = content["date"] as! TimeInterval
        //getDate関数を使って、時間をtimestampから年月日に変換して表示
        cell.postDateLabel.text = self.getDate(number: time/1000)


        return cell
    }
}

extension ListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.didSelectRow(selectedIndexPath: indexPath)
    }
}
