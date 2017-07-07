//
//  LoginViewController.swift
//  FirebaseSample
//
//  Created by tkwatanabe on 2017/07/07.
//  Copyright © 2017年 tkwatanabe. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.delegate = self
        emailTextField.keyboardType = .alphabet
        emailTextField.text = "mogu.224@gmail.com"
        passwordTextField.delegate = self
        passwordTextField.text = "tkwatanabe"
        passwordTextField.isSecureTextEntry = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //ログインボタン
    @IBAction func didRegisterUser() {
        //ログインのためのメソッド
        login()
    }

    //ログイン完了後に、ListViewControllerへの遷移のためのメソッド
    func transitionToView()  {
        self.performSegue(withIdentifier: "toVC", sender: self)
    }

    //Signupのためのメソッド
    func login() {
        //2つのTextFieldに文字がなければ離脱
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        //FIRAuth.auth()?.createUserWithEmailでサインアップ
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error == nil {
                if let loginUser = user {
                    //メールアドレスのバリデーションチェック
                    if self.checkUserValidate(user: loginUser) {
                        print(Auth.auth().currentUser!)
                        self.transitionToView()
                    } else {
                        self.presentValidateAlert()
                    }
                }
            } else {
                print("\(error!.localizedDescription)")
            }
        }
    }
    func checkUserValidate(user: User) -> Bool {
        return user.isEmailVerified
    }
    func presentValidateAlert() {
        let alert = UIAlertController(title: "メール認証", message: "メール認証を行ってください", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}

//MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
