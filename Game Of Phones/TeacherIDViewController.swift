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
    
    var question = Question()
    var teacher = Teacher()
    let postData = PostData()
    let urlString = "http://mcs.drury.edu/amerritt/isTeacherIDSet.php"
    
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
        let postTeacherId = "deviceID=\(teacher.getTeacherId())"
        postData.postData(postString: postTeacherId, urlString : urlString)
        print(postData.question.getQuestionText())
//        if(question.getQuestionType() == "sa"){
//            OperationQueue.main.addOperation {
//                self.performSegue(withIdentifier: "displayTextQuestion", sender: self.question)
//            }
//        }
//        else {
//            OperationQueue.main.addOperation {
//                self.performSegue(withIdentifier: "displayQuestion", sender: self.question)
//            }
//        }
    }
    
        
//        let postString = "deviceID=\(teacherId.text!)"
//        
//        
//        var request = URLRequest(url: URL(string: "http://mcs.drury.edu/amerritt/isTeacherIDSet.php")!)
//        request.httpMethod = "POST"
//        request.httpBody = postString.data(using: .utf8)
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data, error == nil else {
//                // check for fundamental networking error
//                print("error=\(error)")
//                return
//            }
//            
//            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
//                print("statusCode should be 200, but is \(httpStatus.statusCode)")
//                print("response = \(response)")
//            }
//            
//            let responseString = String(data: data, encoding: .utf8)
//            print("responseString = \(responseString)")
//            
//            self.postDeviceId(data: data)
//
//        }
//        task.resume()
//    
//    }
//    
//    func postDeviceId(data: Data){
//        var deviceId = ""
//        do {
//            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
//            if let deviceIdArray = json["question_info"] as? [[String:AnyObject]]{
//                deviceId = deviceIdArray[0]["m_device_id"] as! String
//            }
//        }
//        catch let error as NSError {
//            print(error)
//        }
//        var request = URLRequest(url: URL(string: "http://mcs.drury.edu/amerritt/getQuestion.php")!)
//        let deviceIdData = "deviceID=\(deviceId)"
//        print(deviceIdData)
//        request.httpMethod = "POST"
//        request.httpBody = deviceIdData.data(using: .utf8)
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data, error == nil else {
//                // check for fundamental networking error
//                print("error=\(error)")
//                return
//            }
//            
//            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
//                print("statusCode should be 200, but is \(httpStatus.statusCode)")
//                print("response = \(response)")
//            }
//            
//            let responseString = String(data: data, encoding: .utf8)
//            print("responseString = \(responseString)")
//            
//            self.getQuestionInfo(data: data)
//            
//        }
//        task.resume()
//    }
//    
//    func getQuestionInfo(data:Data){
//        do {
//            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
//            if let questionInfo = json["question_info"] as? [[String:AnyObject]]{
//
//                let questionText = questionInfo[0]["q_text"] as? String
//                questionInfoDict["Question"] = questionText
//                
//                let questionId = questionInfo[0]["q_id"] as? String
//                questionInfoDict["Question Id"] = questionId
//                
//                let questionType = questionInfo[0]["q_type"] as? String
//                questionInfoDict["Type"] = questionType
//                
//                if questionInfo[0]["p_filename"] != nil{
//                    //questionInfoDict["Question Image"] = questionInfo[0]["p_filename"] as! String?
//                }
//            }
//        }
//        catch let error as NSError {
//            print(error)
//        }
//        postQuestionId(data: data)
//        
//    }
//    
//    func postQuestionId(data:Data){
//        var questionId = ""
//        do {
//            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
//            if let deviceIdArray = json["question_info"] as? [[String:AnyObject]]{
//                questionId = deviceIdArray[0]["q_id"] as! String
//            }
//        }
//        catch let error as NSError {
//            print(error)
//        }
//        var request = URLRequest(url: URL(string: "http://mcs.drury.edu/amerritt/getQuestionAnswers.php")!)
//        let deviceIdData = "questionID=\(questionId)"
//        print(deviceIdData)
//        request.httpMethod = "POST"
//        request.httpBody = deviceIdData.data(using: .utf8)
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data, error == nil else {
//                // check for fundamental networking error
//                print("error=\(error)")
//                return
//            }
//            
//            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
//                print("statusCode should be 200, but is \(httpStatus.statusCode)")
//                print("response = \(response)")
//            }
//            
//            let responseString = String(data: data, encoding: .utf8)
//            print("responseString = \(responseString)")
//            
//            self.getQuestionAnswers(data: data)
//            
//        }
//        task.resume()
//    }
//    
//    func getQuestionAnswers(data:Data){
//        do {
//            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
//            if let questionAnswers = json["question_answers"] as? [[String:AnyObject]]{
//                questionAnswersArray = questionAnswers
//                if(questionInfoDict["Type"] == "sa"){
//                    OperationQueue.main.addOperation {
//                        self.performSegue(withIdentifier: "displayTextQuestion", sender: self.questionAnswersArray)
//                    }
//                } else {
//                    OperationQueue.main.addOperation {
//                        self.performSegue(withIdentifier: "displayQuestion", sender: self.questionAnswersArray)
//                    }
//                }
//            }
//        }
//        catch let error as NSError {
//            print(error)
//        }
//
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let destViewController : QuestionViewController = segue.destination as? QuestionViewController{
//                destViewController.questionText = questionInfoDict["Question"]!
//                destViewController.questionAnswers = questionAnswersArray
//                destViewController.deviceId = DeviceId.deviceIdForAnswer
//                destViewController.questionId = questionInfoDict["Question Id"]!
//                destViewController.teacherId = teacherId.text!
//        } else if let destViewController : TextQuestionViewController = segue.destination as? TextQuestionViewController{
//            destViewController.questionText = questionInfoDict["Question"]!
//            destViewController.questionId = questionInfoDict["Question Id"]!
//            destViewController.deviceId = DeviceId.deviceIdForAnswer
//            destViewController.teacherId = teacherId.text!
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destViewController : QuestionViewController = segue.destination as? QuestionViewController{
                destViewController.questionText = question.getQuestionText()
                destViewController.questionAnswers = question.getQuestionAnswers() as [[String : AnyObject]]
                destViewController.deviceId = DeviceId.deviceIdForAnswer
                destViewController.questionId = question.getQuestionId()
                destViewController.teacherId = teacher.getTeacherId()
        } else if let destViewController : TextQuestionViewController = segue.destination as? TextQuestionViewController{
            destViewController.questionText = question.getQuestionText()
            destViewController.questionId = question.getQuestionId()
            destViewController.deviceId = DeviceId.deviceIdForAnswer
            destViewController.teacherId = teacher.getTeacherId()
        }
    }

}
