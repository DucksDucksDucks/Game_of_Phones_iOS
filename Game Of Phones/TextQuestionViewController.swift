//
//  TextQuestionViewController.swift
//  Game Of Phones
//
//  Created by Joshua Harrold on 2/27/17.
//  Copyright © 2017 Josh Harrold. All rights reserved.
//

import UIKit

class TextQuestionViewController: UIViewController {
    
    var postData = PostData()
    var sendAnswerUrl = "http://mcs.drury.edu/amerritt/sendAnswer.php"
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var textAnswer: UITextField!
    
    var teacher : Teacher!
    var question : Question!
    
    var questionText: String = ""
    
    @IBAction func answerSubmit(_ sender: UIButton) {
        
//        let bodyData = "answer=" + (textAnswer.text!) + "&deviceID=" + (DeviceId.deviceIdForAnswer) + "&currentQID=" + (Question.questionId)
//        
//        postData.postData(postString: bodyData, urlString: sendAnswerUrl)
//        
//        OperationQueue.main.addOperation {
//            self.performSegue(withIdentifier: "submitAnswer", sender: self)
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionLabel.text = questionText
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
