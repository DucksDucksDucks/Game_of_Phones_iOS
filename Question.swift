//
//  Question.swift
//  Game Of Phones
//
//  Created by Josh Harrold on 3/1/17.
//  Copyright © 2017 Josh Harrold. All rights reserved.
//

import Foundation

//struct Question {
//    
//    public static var questionText: String = ""
//    
//    public static var questionId : String = ""
//    
//    public static var questionType : String = ""
//    
//    public static var questionImage : String = ""
//    
//    public static var questionAnswers = [[String:AnyObject]]()
//
//}

class Question {
    
    public var questionText : String = ""
    
    public var questionId : String = ""
    
    public var questionType : String = ""
    
    public var questionImage : String = ""
    
    public var questionAnswers = [[String:AnyObject]]()
    
    public func getQuestionText() -> String{
        return self.questionText
    }
    
    public func setQuestionText(questionText : String){
        self.questionText = questionText
    }
    
    public func getQuestionId() -> String{
        return self.questionId
    }
    
    public func setQuestionId(questionId : String){
        self.questionId = questionId
    }
    
    public func getQuestionType() -> String {
        return self.questionType
    }
    
    public func setQuestionType(questionType : String){
        self.questionType = questionType
    }
    
    public func getQuestionImage() -> String{
        return self.questionImage
    }
    
    public func setQuestionImage(questionImage : String){
        self.questionImage = questionImage
    }
    
    public func getQuestionAnswers() -> [[String:AnyObject]]{
        return self.questionAnswers
    }
    
    public func setQuestionAnswers(questionAnswers : [[String:AnyObject]]){
        self.questionAnswers = questionAnswers
    }
}
