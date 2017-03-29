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
    let teacherIdUrl = "http://mcs.drury.edu/amerritt/isTeacherIDSet.php"
    let questionInfoUrl = "http://mcs.drury.edu/amerritt/getQuestion.php"
    let questionAnswersUrl = "http://mcs.drury.edu/amerritt/getQuestionAnswers.php"
    
    var questionInfoDict = [String:String]()
    var questionAnswerDict = [String:String]()
    var questionAnswersArray = [[String:AnyObject]]()

    @IBOutlet weak var teacherId: UITextField!
    
    
    func activityIndicatorStart(){
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    @IBAction func submitButton(_ sender: UIButton) {
        activityIndicatorStart()

        teacher.setTeacherId(teacherId: teacherId.text!)
        
        postData.postData(postString: "deviceID=\(teacher.getTeacherId())", urlString : teacherIdUrl, teacher: teacher, question: question)
        
        postData.postData(postString: "deviceID=\(teacher.getTeacherId())", urlString : questionInfoUrl, teacher: teacher, question: question)

        
        postData.postData(postString: "questionID=\(question.getQuestionId())", urlString: questionAnswersUrl, teacher: teacher, question: question)

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
