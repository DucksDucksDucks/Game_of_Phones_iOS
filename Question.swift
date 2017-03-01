//
//  Question.swift
//  Game Of Phones
//
//  Created by Josh Harrold on 3/1/17.
//  Copyright © 2017 Josh Harrold. All rights reserved.
//

import Foundation

struct Question {
    
    public var questionText: String = ""
    
    public var questionId : String = ""
    
    public var questionType : String = ""
    
    public var questionImage : String = ""
    
    public var questionAnswers = [[String:String]]()
    
    func getQuestionText() -> String{
        return questionText
    }
    
    mutating func setQuestionText(questionText : String){
        self.questionText = questionText
    }
    
    func getQuestionId() -> String{
        return questionId
    }
    
    mutating func setQuestionId(questionId : String){
        self.questionId = questionId
    }
    
    func getQuestionType() -> String{
        return questionType
    }
    
    mutating func setQuestionType(questionType : String){
        self.questionType = questionType
    }
    
    func getQuestionImage() -> String{
        return questionImage
    }
    
    mutating func setQuestionImage(questionImage : String){
        self.questionImage = questionImage
    }
    
    func getQuestionAnswers() -> [[String:String]]{
        return questionAnswers 
    }
    
    mutating func setQuestionAnswers(questionAnswers : [[String:String]]){
        self.questionAnswers = questionAnswers
    }
}
