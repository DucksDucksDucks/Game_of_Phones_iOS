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
    let urlString = "http://mcs.drury.edu/amerritt/createDeviceID.php"
    @IBOutlet weak var nameField: UITextField!
    
    @IBAction func submitButton(_ sender: UIButton) {
        let postData = PostData()
        if nameField.text?.isEmpty == false{
//            Nickname.nickname = nameField.text!
            //let postNicknameString = "nickname=\(Nickname.nickname)"
            //postData.postData(postString: postNicknameString, urlString: urlString)
            
            
            nickname.setNickname(nickname: nameField.text!)
            let postNicknameString = "nickname=\(nickname.getNickname())"
            postData.postData(postString: postNicknameString, urlString: urlString, teacher: teacher, question: question)
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

