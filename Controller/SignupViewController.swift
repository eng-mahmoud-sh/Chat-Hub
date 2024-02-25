//
//  signupViewController.swift
//  Chat Hub
//
//  Created by Apple on 24/02/2024.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class SignupViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func signupPressed(_ sender: UIButton) {
        let email=emailTextField.text!
        let password=passwordTextField.text!
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if error == nil {
                print("the user has signed succesfully")
                self.performSegue(withIdentifier: "signupToChat", sender: self)
            } else {
                print(error.debugDescription)
                self.errorLabel.text=error?.localizedDescription
            }
        }
    }
    

}
