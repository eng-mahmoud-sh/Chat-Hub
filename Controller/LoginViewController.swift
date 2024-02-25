//
//  loginViewController.swift
//  Chat Hub
//
//  Created by Apple on 24/02/2024.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var paswordTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        let email=emailTextField.text!
        let password=paswordTextField.text!
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
          // ...
            if error == nil {
                print("login successful")
                self?.performSegue(withIdentifier: "loginToChat", sender: self)
            } else {
                print(error?.localizedDescription)
                self!.errorLabel.text=error?.localizedDescription
            }
        }
    }
    
    

}
