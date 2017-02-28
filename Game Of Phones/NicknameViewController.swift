//
//  ViewController.swift
//  Game Of Phones
//
//  Created by Josh Harrold on 12/4/16.
//  Copyright © 2016 Josh Harrold. All rights reserved.
//

import UIKit

class NicknameViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    
    let url: URL = URL(string: "http://mcs.drury.edu/amerritt/createDeviceID.php")!
    
    
    @IBAction func submitButton(_ sender: UIButton) {
        
        let postString = "nickname=\(nameField.text!)"
        

        var request = URLRequest(url: URL(string: "http://mcs.drury.edu/amerritt/createDeviceID.php")!)
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
            
            self.getDeviceId(data: data)
            
        }
        task.resume()
        
    }
    
    func getDeviceId(data: Data){
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
            if let deviceIdArray = json["deviceID"] as? [[String:AnyObject]]{
                DeviceId.deviceIdForAnswer = deviceIdArray[0]["device_id"] as! String
                print(DeviceId.deviceIdForAnswer)
            }
        }
        catch let error as NSError {
            print(error)
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

