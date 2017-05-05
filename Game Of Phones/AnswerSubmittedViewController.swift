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
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func newQuestion(_ sender: UIButton) {
        
        let questionId = question.getQuestionId()
        
        question = Question()
        
        postData.postData(postString: "deviceID=\(teacher.getTeacherId())", urlString : DataSource.teacherIdUrl, teacher: teacher, question: question)
        
        postData.postData(postString: "deviceID=\(teacher.getTeacherId())", urlString : DataSource.questionInfoUrl, teacher: teacher, question: question)
        
        postData.postData(postString: "questionID=\(question.getQuestionId())", urlString: DataSource.questionAnswersUrl, teacher: teacher, question: question)
        
        if(questionId != question.getQuestionId()){
            if(question.getQuestionType() == "sa"){
                OperationQueue.main.addOperation {
                    self.performSegue(withIdentifier: "displayTextQuestion", sender: self.question.getQuestionAnswers())
                }
            }
            else if(question.getQuestionType() == "draw"){
                OperationQueue.main.addOperation {
                    self.performSegue(withIdentifier: "displayDrawQuestion", sender: self.question.getQuestionAnswers())
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
        else if let destViewController : DrawViewController = segue.destination as? DrawViewController{
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
