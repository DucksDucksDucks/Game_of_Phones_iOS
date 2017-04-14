//
//  PostData.swift
//  Game Of Phones
//
//  Created by Josh Harrold on 3/1/17.
//  Copyright © 2017 Josh Harrold. All rights reserved.
//

import Foundation

class PostData{
    
    var loopCount = 0
    
    func postData(postString : String, urlString : String, teacher : Teacher, question : Question){
        let semaphore = DispatchSemaphore(value: 0)
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            self.getJsonResponse(data: data, teacher: teacher, question: question)
            semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
    }
    
    func getJsonResponse(data:Data, teacher : Teacher, question : Question){
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
            if let deviceIdArray = json["deviceID"] as? [[String:AnyObject]]{
                if loopCount == 0{
                    DeviceId.deviceIdForAnswer = deviceIdArray[0]["device_id"] as! String
                    print(DeviceId.deviceIdForAnswer)
                } else{
                    teacher.setTeacherId(teacherId: deviceIdArray[0]["device_id"] as! String)
                }
            }
                
            else {
                
                if let questionAnswers = json["question_answers"] as? [[String:AnyObject]]{
                    question.setQuestionAnswers(questionAnswers: questionAnswers)
                }
            
                if let questionInfo = json["question_info"] as? [[String:AnyObject]]{
                    
                    if(questionInfo.isEmpty){
                        teacher.setTeacherId(teacherId: "Teacher ID not found")
                    } else {
                
                        if(questionInfo[0]["m_device_id"] != nil){
                            teacher.setTeacherId(teacherId: questionInfo[0]["m_device_id"] as! String)
                            question.setQuestionId(questionId: questionInfo[0]["q_id"] as! String)
                        }
                        
                        if(questionInfo[0]["q_type"] != nil){
                            question.setQuestionText(questionText: questionInfo[0]["q_text"] as! String)
                            question.setQuestionType(questionType: questionInfo[0]["q_type"] as! String)
                            if (questionInfo[0]["p_filename"] as? String) != nil{
                                question.setQuestionImage(questionImage: questionInfo[0]["p_filename"] as! String)
                            }
                        }
                    }
                }
            }
        }
        catch let error as NSError {
            print(error)
        }
        loopCount += 1
        
    }
    
}
