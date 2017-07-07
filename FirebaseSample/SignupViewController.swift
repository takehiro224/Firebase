//
//  SignupViewController.swift
//  FirebaseSample
//
//  Created by tkwatanabe on 2017/06/28.
//  Copyright © 2017年 tkwatanabe. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.delegate = self
        emailTextField.keyboardType = .asciiCapable
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.checkUserVerify() {
            self.transitionToView()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //サインアップボタン
    @IBAction func willSignup() {
        //サインアップのための関数
        signup()
    }
    //ログイン画面への遷移ボタン
    @IBAction func willTransitionToLogin() {
        transitionToLogin()
    }

    @IBAction func	 willLoginWithFacebook() {
        self.willLoginWithFacebook()
    }

    //ログイン画面への遷移
    func transitionToLogin() {
        self.performSegue(withIdentifier: "toLogin", sender: nil)
    }
    //ListViewControllerへの遷移
    func transitionToView() {
        self.performSegue(withIdentifier: "toView", sender: nil)
    }

    //Signupのためのメソッド
    func signup() {
        //2つのTextFieldに文字がなければ離脱
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        //FIRAuth.auth()?.createUserWithEmailでサインアップ
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error == nil {
                user?.sendEmailVerification() { error in
                    if error == nil {
                        //エラーがない場合そのままログイン画面へ
                        self.transitionToLogin()
                    } else {
                        print("\(error!.localizedDescription)")
                    }
                }
            } else {
                print("\(error!.localizedDescription)")
            }
        }
    }

    func checkUserVerify() -> Bool {
        guard let user = Auth.auth().currentUser else {
            return false
        }
        return user.isEmailVerified
    }

}

//MARK: - UITextFieldDelegate
extension SignupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
