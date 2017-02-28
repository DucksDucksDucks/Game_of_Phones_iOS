//
//  TextQuestionViewController.swift
//  Game Of Phones
//
//  Created by Joshua Harrold on 2/27/17.
//  Copyright © 2017 Josh Harrold. All rights reserved.
//

import UIKit

class TextQuestionViewController: UIViewController {
    
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var textAnswer: UITextField!
    
    var questionText: String = ""
    var questionId: String = ""
    var deviceId: String = ""
    var teacherId: String = ""
    
    @IBAction func answerSubmit(_ sender: UIButton) {
        
        let bodyData = "answer=" + (textAnswer.text!) + "&deviceID=" + (deviceId) + "&currentQID=" + (questionId)
        
        var request = URLRequest(url: URL(string: "http://mcs.drury.edu/amerritt/sendAnswer.php")!)
        request.httpMethod = "POST"
        //request.httpBody = postString.data(using: .utf8)
        request.httpBody = bodyData.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
            
            OperationQueue.main.addOperation {
                self.performSegue(withIdentifier: "submitAnswer", sender: self.teacherId)
            }
            
        }
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destViewController : AnswerSubmittedViewController = segue.destination as? AnswerSubmittedViewController{
            destViewController.teacherId = teacherId
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        question.text = questionText
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
