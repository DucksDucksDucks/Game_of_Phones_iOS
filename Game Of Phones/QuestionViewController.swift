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
    var sendAnswerUrl = "http://mcs.drury.edu/gameofphones/mobilefiles/webservice/sendAnswer.php"
    var questionText: String = ""
    
    var selectedAnswer = [String:String]()
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    func submit(sender: UIButton){
        var answerId: String!
        for i in (0..<question.getQuestionAnswers().count){
            if(selectedAnswer["Answer"] == question.getQuestionAnswers()[i]["a_text"] as? String){
                answerId = question.getQuestionAnswers()[i]["a_id"] as! String
                break
            }
        }
        
        let bodyData = "answer=" + (answerId) + "&deviceID=" + (DeviceId.deviceIdForAnswer) + "&currentQID=" + (question.getQuestionId()) + "&teacherID=" + (teacher.getTeacherId())
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
        //radioButton.titleLabel?.lineBreakMode = .byWordWrapping
        radioButton.titleLabel?.numberOfLines = 0
        radioButton.contentVerticalAlignment = .top
        scrollView.addSubview(radioButton);
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
    
    func displayRadioButtons(questionImage : UIImageView) -> Int{
        //first button
        let frame = CGRect(x: 25, y: Int(questionImage.frame.height), width: Int(questionLabel.frame.width), height: 100);
        let firstRadioButton = createRadioButton(frame: frame, title: question.getQuestionAnswers()[0]["a_text"] as! String, id : question.getQuestionAnswers()[0]["a_id"] as! String, color: swiftColor);
        firstRadioButton.titleLabel?.sizeToFit()
        scrollView.contentSize.height = 100
        if(question.getQuestionAnswers()[0]["p_filename"] as? String != nil){
            var imageView: UIImageView
            imageView = UIImageView(frame:CGRect(x:50, y: firstRadioButton.titleLabel!.frame.height + questionImage.frame.height + 10, width:50, height:50))
            let url = URL(string: "http://mcs.drury.edu/gameofphones/mobilefiles/images/\(question.getQuestionAnswers()[0]["p_filename"]!)")
            let data = try? Data(contentsOf: url!)
            imageView.image = UIImage(data: data!)
            imageView.contentMode = .scaleAspectFit
            scrollView.contentSize.height = scrollView.contentSize.height + 100
            scrollView.addSubview(imageView)
        }
        //other buttons
        var i = 0
        var y = Int(questionImage.frame.height) + 100
        var otherButtons : [DLRadioButton] = [];
        for _ in question.getQuestionAnswers(){
            if(i == 0){
                i += 1
            }
            else{
                let frame = CGRect(x: 25, y: y, width: Int(questionLabel.frame.width), height: 100);
                let radioButton = createRadioButton(frame: frame, title: question.getQuestionAnswers()[i]["a_text"] as! String, id: question.getQuestionAnswers()[i]["a_id"] as! String, color: swiftColor);
                radioButton.titleLabel?.sizeToFit()
                scrollView.contentSize.height = scrollView.contentSize.height + 100
                if(question.getQuestionAnswers()[i]["p_filename"] as? String != nil){
                    var imageView: UIImageView
                    imageView = UIImageView(frame:CGRect(x:50, y: radioButton.titleLabel!.frame.height + questionImage.frame.height + 10, width:50, height:50))
                    let url = URL(string: "http://mcs.drury.edu/gameofphones/mobilefiles/images/\(question.getQuestionAnswers()[i]["p_filename"]!)")
                    let data = try? Data(contentsOf: url!)
                    imageView.image = UIImage(data: data!)
                    imageView.contentMode = .scaleAspectFit
                    scrollView.contentSize.height = scrollView.contentSize.height + 100
                    scrollView.addSubview(imageView)
                }
                y += 100
                i += 1
                otherButtons.append(radioButton)
            }
        }
        firstRadioButton.otherButtons = otherButtons;
        return y
    }
    
    func createSubmitButton(questionImage : UIImageView, questionLabelWidth : CGFloat){
        let submitButton = UIButton(frame: CGRect(x: Int((view.frame.width - questionLabelWidth) / 2), y: displayRadioButtons(questionImage: questionImage) + 10, width: Int(questionLabelWidth), height: 30))
        submitButton.setTitle("Submit", for: .normal)
        submitButton.setTitleColor(view.backgroundColor, for: .normal)
        submitButton.backgroundColor = radioIndicatorColor
        submitButton.addTarget(self, action: #selector(submit), for: .touchUpInside)
        scrollView.addSubview(submitButton)
    }
    
    func checkForQuestionImage(questionImage: UIImageView){
        if(question.getQuestionImage() != ""){
            let url = URL(string: "http://mcs.drury.edu/gameofphones/mobilefiles/images/\(question.getQuestionImage())")
            let data = try? Data(contentsOf: url!)
            questionImage.image = UIImage(data: data!)
            questionImage.contentMode = .scaleAspectFit
            questionLabel.addSubview(questionImage)
//            let constraintTop = NSLayoutConstraint(item: questionImage, attribute: .bottom, relatedBy: .equal, toItem: scrollView, attribute: .top, multiplier: 1, constant: -23)
            let questionLabelTopConstraint = NSLayoutConstraint(item: questionLabel, attribute: .top, relatedBy: .equal, toItem: topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 41)
            let questionLabelBottomConstraint = NSLayoutConstraint(item: questionLabel, attribute: .bottom, relatedBy: .equal, toItem: scrollView, attribute: .top, multiplier: 1, constant: 23)
            let questionLabelConstraint = NSLayoutConstraint(item: scrollView, attribute: .top, relatedBy: .equal, toItem: questionLabel, attribute: .bottom, multiplier: 1, constant: 23)
            let questionImageConstraint = NSLayoutConstraint(item: scrollView, attribute: .top, relatedBy: .equal, toItem: questionImage, attribute: .bottom, multiplier: 1, constant: 23)
            let constraintBottom = NSLayoutConstraint(item: scrollView, attribute: .bottom, relatedBy: .equal, toItem: bottomLayoutGuide, attribute: .top, multiplier: 1, constant: 0)
            let constraintLeft = NSLayoutConstraint(item: scrollView, attribute: .leading, relatedBy: .equal, toItem: nil, attribute: .leading, multiplier: 1, constant: 0)
            let constraintRight = NSLayoutConstraint(item: scrollView, attribute: .trailing, relatedBy: .equal, toItem: nil, attribute: .trailing, multiplier: 1, constant: 0)
//            if(question.getQuestionImage() == ""){
                NSLayoutConstraint.activate([questionLabelConstraint, constraintBottom, constraintLeft, constraintRight, questionLabelTopConstraint, questionLabelBottomConstraint])
//            } else {
//                NSLayoutConstraint.activate([questionImageConstraint, constraintBottom, constraintLeft, constraintRight])
//            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.contentSize.height = 0
        questionLabel.text = question.getQuestionText()
        let questionLabelWidth = questionLabel.frame.width
        questionLabel.sizeToFit()
        let questionImage = UIImageView(frame:CGRect(x:50, y: questionLabel.frame.height, width:50, height:50))
        checkForQuestionImage(questionImage: questionImage)
        displayRadioButtons(questionImage: questionImage)
        createSubmitButton(questionImage: questionImage, questionLabelWidth : questionLabelWidth)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
