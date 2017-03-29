//
//  Nickname.swift
//  Game Of Phones
//
//  Created by Josh Harrold on 3/1/17.
//  Copyright © 2017 Josh Harrold. All rights reserved.
//

import Foundation

//struct Nickname{
//    
//    public static var nickname: String = ""
//    
//
//    
//}

class Nickname{
    
    public var nickname: String = ""
    
    
    public func getNickname() -> String{
        return nickname
    }
    
    public func setNickname(nickname : String){
        self.nickname = nickname
    }
}
