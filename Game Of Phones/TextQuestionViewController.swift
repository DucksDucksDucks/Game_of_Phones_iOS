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
    var sendAnswerUrl = "http://mcs.drury.edu/gameofphones/mobilefiles/webservice/sendAnswer.php"
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var textAnswer: UITextField!
    
    var teacher : Teacher!
    var question : Question!
    
    var questionText: String = ""
    
    @IBAction func answerSubmit(_ sender: UIButton) {
        
        let bodyData = "answer=" + (textAnswer.text!) + "&deviceID=" + (DeviceId.deviceIdForAnswer) + "&currentQID=" + (question.getQuestionId()) + "&teacherID=" + (teacher.getTeacherId())
        
        postData.postData(postString: bodyData, urlString: sendAnswerUrl, teacher: teacher, question: question)
        
        self.performSegue(withIdentifier: "submitAnswer", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destViewController : AnswerSubmittedViewController = segue.destination as? AnswerSubmittedViewController{
            destViewController.teacher = teacher
            destViewController.question = question
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionLabel.text = question.getQuestionText()
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
