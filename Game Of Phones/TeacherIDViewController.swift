//
//  SecondViewController.swift
//  Game Of Phones
//
//  Created by Josh Harrold on 12/4/16.
//  Copyright © 2016 Josh Harrold. All rights reserved.
//

import UIKit

var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()


class TeacherIDViewController: UIViewController {
    
    let teacher = Teacher()
    let question = Question()
    let postData = PostData()
    var nickname : Nickname!
    
    var questionInfoDict = [String:String]()
    var questionAnswerDict = [String:String]()
    var questionAnswersArray = [[String:AnyObject]]()

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var teacherId: UITextField!
    
    @IBAction func submitButton(_ sender: UIButton) {

        if (teacherId.text?.trimmingCharacters(in: .whitespaces).isEmpty)! || (teacherId.text?.isEmpty)! || teacherId.text == "0"{
            errorLabel.text = "Please enter a valid Teacher ID."
        } else {
            teacher.setTeacherId(teacherId: teacherId.text!)
            
            postData.postData(postString: "deviceID=\(teacher.getTeacherId())", urlString : DataSource.teacherIdUrl, teacher: teacher, question: question)
            
            if(teacher.getTeacherId() == "Teacher ID not found"){
                errorLabel.text = "Please enter a valid Teacher ID."
            } else {
            
                postData.postData(postString: "deviceID=\(teacher.getTeacherId())", urlString : DataSource.questionInfoUrl, teacher: teacher, question: question)

                
                postData.postData(postString: "questionID=\(question.getQuestionId())", urlString: DataSource.questionAnswersUrl, teacher: teacher, question: question)

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
            }
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
        teacherId.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
