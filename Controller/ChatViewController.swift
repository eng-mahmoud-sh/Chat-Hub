//
//  ChatViewController.swift
//  Chat Hub
//
//  Created by Apple on 25/02/2024.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class ChatViewController: UIViewController {
    
    var messages = [Message]()
    let db = Firestore.firestore()
    
    @IBOutlet weak var messageTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        messageTextField.delegate=self
        tableView.separatorStyle = .none
        
        tableView.register(UINib(nibName: "SenderTableViewCell", bundle: nil), forCellReuseIdentifier: "SenderCell")
        tableView.register(UINib(nibName: "RecieverTableViewCell", bundle: nil), forCellReuseIdentifier: "RecieverCell")
        
        
        readMessage()
        navigationItem.setHidesBackButton(true, animated: true)
    }
    
    
    @IBAction func signoutPressed(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        Task { @MainActor in
            print(messageTextField.text!)
            
            let message = Message(sender: Auth.auth().currentUser?.email , body: messageTextField.text!)
            await saveMessage(message)
            //messages.append(message)
            //tableView.reloadData()
            messageTextField.text=nil
        }
    }
    
}
extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if messages[indexPath.row].sender == Auth.auth().currentUser?.email {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SenderCell", for: indexPath) as! SenderTableViewCell
            cell.label.text = messages[indexPath.row].body
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecieverCell", for: indexPath) as! ReceiverTableViewCell
            cell.label.text = messages[indexPath.row].body
            return cell
        }
    }

        
        func saveMessage(_ message: Message) async{
            
            do {
                let ref = try await db.collection("messages").addDocument(data: [
                    "body": message.body!,
                    "sender": message.sender!,
                    "time": Date().timeIntervalSince1970
                ])
                print("Document added with ID: \(ref.documentID)")
            } catch {
                print("Error adding document: \(error)")
            }
        }
        
        
        func readMessage() {
            db.collection("messages").order(by: "time").addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                self.messages.removeAll()
                for doc in documents {
                    let msgBody = doc.data()["body"] as! String
                    let msgSender =  doc.data()["sender"] as! String
                    
                    let msg = Message(sender: msgSender, body: msgBody)
                    self.messages.append(msg)
                }
                self.tableView.reloadData()
            }
            
            let indexPath = IndexPath(row: self.messages.count-1, section: 0)
            if indexPath.row > 5{
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
            
        }
    }
    
extension ChatViewController: UITextFieldDelegate{
    private func textFieldShouldReturn(_ textField: UITextField) async -> Bool {
        let message = Message (sender: Auth.auth () .currentUser?.email, body:
                                messageTextField.text!)
        
        await saveMessage (message)
        
        messageTextField.text=nil
        return true
    }
}
