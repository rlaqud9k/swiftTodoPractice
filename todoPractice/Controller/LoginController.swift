//
//  ViewController.swift
//  todoPractice
//
//  Created by user on 2022/06/05.
//

import UIKit
import FirebaseAuth

class LoginController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            let alert: UIAlertController = UIAlertController(title: "", message: "email/passwordを入力してください。", preferredStyle: .alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler:nil)
            alert.addAction(defaultAction)
            
            if email.isEmpty || password.isEmpty {
                present(alert, animated: true, completion: nil)
            }
            
            Auth.auth().signIn(withEmail: email, password: password) {authResult, error in
                if let error = error {
                    let authError = error as NSError
                    if let errorCode = AuthErrorCode(rawValue: authError.code) {
                        switch errorCode {
                        case .invalidEmail:
                            alert.message = "正しくないemailアドレスです。"
                            break
                        case .wrongPassword:
                            alert.message = "正しくないpasswordです。"
                            break
                        case .userNotFound:
                            alert.message = "存在しないユーザーです。"
                            break
                        default:
                            alert.message = "エラーが発生しています。"
                        }
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                }
                self.navigationController?.popViewController(animated: true)
                
            }
            
        }
    }
}
