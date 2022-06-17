//
//  SignUpController.swift
//  todoPractice
//
//  Created by user on 2022/06/12.
//

import UIKit
import FirebaseAuth

class SignUpController: UIViewController {
    
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
            
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                let authError = error as NSError
                if let errorCode = AuthErrorCode(rawValue: authError.code) {
                    print(errorCode.rawValue)
                    switch errorCode {
                    case .invalidEmail:
                        alert.message = "正しくないemailアドレスです。"
                        break
                    case .weakPassword:
                        alert.message = "passwordが短いです。６文字以上にしてください。"
                        break
                    case .credentialAlreadyInUse:
                        alert.message = "すでに存在しているemailです。"
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
