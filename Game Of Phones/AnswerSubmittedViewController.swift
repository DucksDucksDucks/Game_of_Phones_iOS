//
//  FourthViewController.swift
//  Game Of Phones
//
//  Created by Joshua Harrold on 12/8/16.
//  Copyright © 2016 Josh Harrold. All rights reserved.
//

import UIKit

class AnswerSubmittedViewController: UIViewController {
    
    let postData = PostData()
    var question : Question!
    var teacher : Teacher!
    
    let teacherIdUrl = "http://mcs.drury.edu/gameofphones/mobilefiles/webservice/isTeacherIDSet.php"
    let questionInfoUrl = "http://mcs.drury.edu/gameofphones/mobilefiles/webservice/getQuestion.php"
    let questionAnswersUrl = "http://mcs.drury.edu/gameofphones/mobilefiles/webservice/getQuestionAnswers.php"
    
    @IBOutlet weak var errorLabel: UILabel!
    
    func activityIndicatorStart(){
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    @IBAction func newQuestion(_ sender: UIButton) {
        
        let questionId = question.getQuestionId()
        
        question = Question()
        
        postData.postData(postString: "deviceID=\(teacher.getTeacherId())", urlString : teacherIdUrl, teacher: teacher, question: question)
        
        postData.postData(postString: "deviceID=\(teacher.getTeacherId())", urlString : questionInfoUrl, teacher: teacher, question: question)
        
        postData.postData(postString: "questionID=\(question.getQuestionId())", urlString: questionAnswersUrl, teacher: teacher, question: question)
        
        if(questionId != question.getQuestionId()){
            if(question.getQuestionType() == "sa"){
                OperationQueue.main.addOperation {
                    self.performSegue(withIdentifier: "displayTextQuestion", sender: self.question.getQuestionAnswers())
                }
            }
            else {
                OperationQueue.main.addOperation {
                    self.performSegue(withIdentifier: "displayQuestion", sender: self.question.getQuestionAnswers())
                }
            }
        } else {
            errorLabel.text = "Waiting for next question. Please try again."
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destViewController : QuestionViewController = segue.destination as? QuestionViewController{
            destViewController.teacher = teacher
            destViewController.question = question
            
        }
        else if let destViewController : TextQuestionViewController = segue.destination as? TextQuestionViewController{
            destViewController.teacher = teacher
            destViewController.question = question
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
