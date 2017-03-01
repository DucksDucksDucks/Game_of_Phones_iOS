//
//  Teacher.swift
//  Game Of Phones
//
//  Created by Josh Harrold on 3/1/17.
//  Copyright © 2017 Josh Harrold. All rights reserved.
//

import Foundation

struct Teacher{
    
    public var teacherId: String = ""
    
    func getTeacherId() -> String{
        return teacherId
    }
    
    mutating func setTeacherId(teacherId : String){
        self.teacherId = teacherId
    }
}
