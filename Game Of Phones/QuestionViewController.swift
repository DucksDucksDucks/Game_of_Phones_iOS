//
//  ThirdViewController.swift
//  Game Of Phones
//
//  Created by Josh Harrold on 12/4/16.
//  Copyright © 2016 Josh Harrold. All rights reserved.
//
import UIKit
import DLRadioButton

class QuestionViewController: UIViewController {

    @IBOutlet weak var scroll: UIScrollView!
    
    @IBOutlet weak var question: UILabel!
    
    var questionAnswers = [[String:AnyObject]]()
    var selectedAnswer = [String:String]()
    var questionText: String = ""
    var answerId = ""
    var questionId = ""
    var deviceId = ""
    var teacherId = ""
    
    @IBAction func submitAnswer(_ sender: UIButton) {
        for _ in questionAnswers{
            if(selectedAnswer["Answer"] == questionAnswers[0]["a_text"] as? String){
                answerId = questionAnswers[0]["a_id"] as! String
            }
        }
        let bodyData = "answer=" + (answerId) + "&deviceID=" + (deviceId) + "&currentQID=" + (questionId)
        
        var request = URLRequest(url: URL(string: "http://mcs.drury.edu/amerritt/sendAnswer.php")!)
        request.httpMethod = "POST"
        //request.httpBody = postString.data(using: .utf8)
        request.httpBody = bodyData.data(using: .utf8)
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
            
            OperationQueue.main.addOperation {
                self.performSegue(withIdentifier: "submitAnswer", sender: self.teacherId)
            }
            
        }
        task.resume()
    }
    
    let swiftColor = UIColor(red: 181/255, green: 181/255, blue: 181/255, alpha: 1)
    let radioIndicatorColor = UIColor(red:1, green: 174/255, blue: 40/255, alpha: 1)
    
    private func createRadioButton(frame : CGRect, title : String, id : String, color : UIColor) -> DLRadioButton {
        
        let radioButton = DLRadioButton(frame: frame);
        radioButton.titleLabel!.font = UIFont.systemFont(ofSize: 14);
        radioButton.setTitle(title, for: UIControlState.normal);
        radioButton.setTitleColor(color, for: UIControlState.normal);
        radioButton.iconColor = swiftColor;
        radioButton.indicatorColor = radioIndicatorColor;
        radioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left;
        radioButton.addTarget(self, action: #selector(QuestionViewController.logSelectedButton), for: UIControlEvents.touchUpInside);
        self.view.addSubview(radioButton);
        return radioButton;
    }

    @objc @IBAction private func logSelectedButton(radioButton : DLRadioButton) {
            selectedAnswer["Answer"] = radioButton.selected()!.titleLabel!.text!
            print(selectedAnswer["Answer"]!);
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destViewController : AnswerSubmittedViewController = segue.destination as? AnswerSubmittedViewController{
            destViewController.teacherId = teacherId
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        question.text = questionText
        
        // programmatically add buttons
        // first button
        let frame = CGRect(x: 25, y: 100, width: 100, height: 100);
        let firstRadioButton = createRadioButton(frame: frame, title: questionAnswers[0]["a_text"] as! String, id : questionAnswers[0]["a_id"] as! String, color: swiftColor);
        if(questionAnswers[0]["p_filename"] as? String != nil){
            var imageView: UIImageView
            imageView = UIImageView(frame:CGRect(x:50, y:165, width:50, height:50))
            let url = URL(string: "http://mcs.drury.edu/gameofphones/mobilefiles/images/\(questionAnswers[0]["p_filename"]!)")
            let data = try? Data(contentsOf: url!)
            imageView.image = UIImage(data: data!)
            self.view.addSubview(imageView)
        }
        
        //other buttons
        var i = 0
        var y = 200
        var otherButtons : [DLRadioButton] = [];
        for _ in questionAnswers{
            if(i == 0){
                i += 1
            }
            else{
                let frame = CGRect(x: 25, y: y, width: 100, height: 100);
                let radioButton = createRadioButton(frame: frame, title: questionAnswers[i]["a_text"] as! String, id: questionAnswers[i]["a_id"] as! String, color: swiftColor);
                if(questionAnswers[i]["p_filename"] as? String != nil){
                    var imageView: UIImageView
                    imageView = UIImageView(frame:CGRect(x:100, y:100, width:100, height:100))
                    let url = URL(string: "http://mcs.drury.edu/gameofphones/mobilefiles/images/\(questionAnswers[i]["p_filename"]!)")
                    let data = try? Data(contentsOf: url!)
                    imageView.image = UIImage(data: data!)
                    self.view.addSubview(imageView)
                }
                y += 100
                i += 1
                otherButtons.append(radioButton)
            }
        }
        
        firstRadioButton.otherButtons = otherButtons;
        activityIndicator.stopAnimating()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
