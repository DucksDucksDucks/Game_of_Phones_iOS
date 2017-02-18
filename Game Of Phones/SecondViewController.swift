//
//  SecondViewController.swift
//  Game Of Phones
//
//  Created by Josh Harrold on 12/4/16.
//  Copyright © 2016 Josh Harrold. All rights reserved.
//

import UIKit

var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()

class SecondViewController: UIViewController {
    
    
    var questionInfoDict = [String:String]()

    @IBOutlet weak var teacherId: UITextField!
    
    
    func activityIndicatorStart(){
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    @IBAction func submitButton(_ sender: UIButton) {
        
        activityIndicatorStart()
        
        let postString = "deviceID=\(teacherId.text!)"
        
        
        var request = URLRequest(url: URL(string: "http://mcs.drury.edu/amerritt/isTeacherIDSet.php")!)
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
            
            self.postDeviceId(data: data)

        }
        task.resume()
    
    }
    
    func postDeviceId(data: Data){
        var deviceId = ""
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
            if let deviceIdArray = json["question_info"] as? [[String:AnyObject]]{
                deviceId = deviceIdArray[0]["m_device_id"] as! String
            }
        }
        catch let error as NSError {
            print(error)
        }
        var request = URLRequest(url: URL(string: "http://mcs.drury.edu/amerritt/getQuestion.php")!)
        let deviceIdData = "deviceID=\(deviceId)"
        print(deviceIdData)
        request.httpMethod = "POST"
        request.httpBody = deviceIdData.data(using: .utf8)
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
            
            self.getQuestionInfo(data: data)
            
        }
        task.resume()
    }
    
    func getQuestionInfo(data:Data){
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
            if let questionInfo = json["question_info"] as? [[String:AnyObject]]{
                //let questionId = questionInfo[0]["q_id"] as! String
                let questionText = questionInfo[0]["q_text"] as? String
                //let questionType = questionInfo[0]["q_type"] as! String
                //let questionCorrectId = questionInfo[0]["q_correct_id"] as! String
                //let questionPicture = questionInfo[0]["p_filename"] as! String
                
                questionInfoDict["Question"] = questionText
                performSegue(withIdentifier: "displayQuestion", sender: questionInfoDict["Question"])
            }
        }
        catch let error as NSError {
            print(error)
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destViewController : ThirdViewController = segue.destination as? ThirdViewController{
            if (sender as? String) != nil {
                destViewController.questionText = questionInfoDict["Question"]!
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
