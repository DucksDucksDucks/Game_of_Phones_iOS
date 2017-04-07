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

    var postData = PostData()
    var question : Question!
    var teacher : Teacher!
    var sendAnswerUrl = "http://mcs.drury.edu/amerritt/sendAnswer.php"
    var questionText: String = ""
    
    var selectedAnswer = [String:String]()
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBAction func submitAnswer(_ sender: UIButton) {
        var answerId: String!
        for i in (0..<question.getQuestionAnswers().count){
            if(selectedAnswer["Answer"] == question.getQuestionAnswers()[i]["a_text"] as? String){
                answerId = question.getQuestionAnswers()[i]["a_id"] as! String
                break
            }
        }

        
        let bodyData = "answer=" + (answerId) + "&deviceID=" + (DeviceId.deviceIdForAnswer) + "&currentQID=" + (question.getQuestionId())
        postData.postData(postString: bodyData, urlString: sendAnswerUrl, teacher: teacher, question: question)
        
        self.performSegue(withIdentifier: "submitAnswer", sender: self)

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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destViewController : AnswerSubmittedViewController = segue.destination as? AnswerSubmittedViewController{
            destViewController.teacher = teacher
            destViewController.question = question
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        questionLabel.text = question.getQuestionText()
        
         //programmatically add buttons
         //first button
        let frame = CGRect(x: 25, y: 100, width: 200, height: 100);
        let firstRadioButton = createRadioButton(frame: frame, title: question.getQuestionAnswers()[0]["a_text"] as! String, id : question.getQuestionAnswers()[0]["a_id"] as! String, color: swiftColor);
        if(question.getQuestionAnswers()[0]["p_filename"] as? String != nil){
            var imageView: UIImageView
            imageView = UIImageView(frame:CGRect(x:50, y:165, width:50, height:50))
            let url = URL(string: "http://mcs.drury.edu/gameofphones/mobilefiles/images/\(question.getQuestionAnswers()[0]["p_filename"]!)")
            let data = try? Data(contentsOf: url!)
            imageView.image = UIImage(data: data!)
            self.view.addSubview(imageView)
        }
        
        //other buttons
        var i = 0
        var y = 200
        var otherButtons : [DLRadioButton] = [];
        for _ in question.getQuestionAnswers(){
            if(i == 0){
                i += 1
            }
            else{
                let frame = CGRect(x: 25, y: y, width: 200, height: 100);
                let radioButton = createRadioButton(frame: frame, title: question.getQuestionAnswers()[i]["a_text"] as! String, id: question.getQuestionAnswers()[i]["a_id"] as! String, color: swiftColor);
                if(question.getQuestionAnswers()[i]["p_filename"] as? String != nil){
                    var imageView: UIImageView
                    imageView = UIImageView(frame:CGRect(x:100, y:100, width:100, height:100))
                    let url = URL(string: "http://mcs.drury.edu/gameofphones/mobilefiles/images/\(question.getQuestionAnswers()[i]["p_filename"]!)")
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
    }

}
