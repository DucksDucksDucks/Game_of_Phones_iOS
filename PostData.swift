//
//  PostData.swift
//  Game Of Phones
//
//  Created by Josh Harrold on 3/1/17.
//  Copyright © 2017 Josh Harrold. All rights reserved.
//

import Foundation

class PostData{
    
    var question = Question()
    var teacher = Teacher()
    var test = NicknameViewController()
    
    func postData(postString : String, urlString : String){
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
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
            
            self.getJsonResponse(data: data)
            
        }
        task.resume()
    }
    
    func getJsonResponse(data:Data){
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
            if let deviceIdArray = json["deviceID"] as? [[String:AnyObject]]{
                DeviceId.deviceIdForAnswer = deviceIdArray[0]["device_id"] as! String
                print(DeviceId.deviceIdForAnswer)
                print("It's working")
            }
                
            else if let questionInfo = json["question_info"] as? [[String:AnyObject]]{
                
                //let teacher = Teacher()
                teacher.setTeacherId(teacherId: questionInfo[0]["m_device_id"] as! String)
                
                //let question = Question()
                question.setQuestionId(questionId: questionInfo[0]["q_id"] as! String)
//                question.setQuestionText(questionText: questionInfo[0]["q_text"] as! String)
//                question.setQuestionType(questionType: questionInfo[0]["q_type"] as! String)
//                question.setQuestionImage(questionImage: questionInfo[0]["p_filename"] as! String)
            }
                
            else if let questionAnswers = json["question_answers"] as? [[String:String]]{
                //let question = Question()
                question.setQuestionAnswers(questionAnswers: questionAnswers)
            }
        }
        catch let error as NSError {
            print(error)
        }
        print("Here it is: " + teacher.getTeacherId())
    }
    
}
