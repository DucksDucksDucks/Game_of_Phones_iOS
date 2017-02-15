//
//  ViewController.swift
//  Game Of Phones
//
//  Created by Josh Harrold on 12/4/16.
//  Copyright © 2016 Josh Harrold. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

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
            
            self.getDeviceId(data: data)
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
        }
        task.resume()
        
    }
    
    func getDeviceId(data: Data) -> Any{
        var deviceId = ""
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
            if let deviceIdArray = json["deviceID"] as? [[String:AnyObject]]{
                deviceId = deviceIdArray[0]["device_id"] as! String
                print(deviceId)
            }
        }
        catch let error as NSError {
            print(error)
        }
        return deviceId
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

