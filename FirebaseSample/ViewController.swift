//
//  ViewController.swift
//  FirebaseSample
//
//  Created by tkwatanabe on 2017/06/28.
//  Copyright © 2017年 tkwatanabe. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    //Firebase Databaseのルートを指定
    let ref = Database.database().reference()

    var selectSnap: DataSnapshot!

    //投稿のためのTextField
    @IBOutlet weak var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        textField.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func post(_ sender: UIButton) {
        create()
    }

    func create() {
        //textFieldに何も書かれていない場合は離脱
        guard let text = self.textField.text else {
            return
        }
        self.ref
            .child((Auth.auth().currentUser?.uid)!)
            .childByAutoId()
            .setValue([
                "user": (Auth.auth().currentUser?.uid)!,
                "context": text,
                "date": ServerValue.timestamp()
                ])
    }

    func logout() {
        do {
            //ログアウト処理
            try Auth.auth().signOut()
            //先頭のNavigationControllerを取得
            let storyboard: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Nav")
            //遷移
            self.present(storyboard, animated: true, completion: nil)
        } catch let error as NSError {
            print("\(error.localizedDescription)")
        }
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
