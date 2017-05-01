//
//  Teacher.swift
//  Game Of Phones
//
//  Created by Josh Harrold on 3/1/17.
//  Copyright © 2017 Josh Harrold. All rights reserved.
//

import Foundation

class Teacher{
    
    public var teacherId : String = ""
    
    public func getTeacherId() -> String{
        return self.teacherId
    }
    
    public func setTeacherId(teacherId : String){
        self.teacherId = teacherId
    }
}
