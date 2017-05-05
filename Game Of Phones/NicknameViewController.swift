//
//  ViewController.swift
//  Game Of Phones
//
//  Created by Josh Harrold on 12/4/16.
//  Copyright © 2016 Josh Harrold. All rights reserved.
//

import UIKit

class NicknameViewController: UIViewController {
    
    let nickname = Nickname()
    let teacher = Teacher()
    let question = Question()

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func submitButton(_ sender: UIButton) {
        let postData = PostData()
        if (nameField.text?.trimmingCharacters(in: .whitespaces).isEmpty)! || (nameField.text?.isEmpty)!{
            errorLabel.text = "Please enter a nickname."
        } else {
            nickname.setNickname(nickname: nameField.text!)
            let postNicknameString = "nickname=\(nickname.getNickname())"
            postData.postData(postString: postNicknameString, urlString: DataSource.createDeviceIdUrl, teacher: teacher, question: question)
            OperationQueue.main.addOperation {
                self.performSegue(withIdentifier: "setNickname", sender: self)
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destViewController : TeacherIDViewController = segue.destination as? TeacherIDViewController{
            destViewController.nickname = nickname

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

