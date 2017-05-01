//
//  TextQuestionViewController.swift
//  Game Of Phones
//
//  Created by Joshua Harrold on 2/27/17.
//  Copyright © 2017 Josh Harrold. All rights reserved.
//

import UIKit

class TextQuestionViewController: UIViewController {
    
    var postData = PostData()
    var sendAnswerUrl = "http://mcs.drury.edu/gameofphones/mobilefiles/webservice/sendAnswer.php"
    var questionImageUrl = "http://mcs.drury.edu/gameofphones/mobilefiles/images/"
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var textAnswer: UITextField!
    
    var teacher : Teacher!
    var question : Question!
    let SPACING_BETWEEN_QUESION_AND_IMAGE : CGFloat = 15
    let SPACING_BETWEEN_QUESION_AND_ANSWERS : CGFloat = 25
    let LEADING_SPACE : CGFloat = 20
    let IMAGE_HEIGHT : CGFloat = 190
    let IMAGE_WIDTH : CGFloat = 300
    
    var questionText: String = ""
    var contentHeight : CGFloat!
    
    @IBAction func answerSubmit(_ sender: UIButton) {
        
        if !(textAnswer.text?.trimmingCharacters(in: .whitespaces).isEmpty)! || !((textAnswer.text?.isEmpty)!){
            let bodyData = "answer=" + (textAnswer.text!) + "&deviceID=" + (DeviceId.deviceIdForAnswer) + "&currentQID=" + (question.getQuestionId()) + "&teacherID=" + (teacher.getTeacherId())
            
            postData.postData(postString: bodyData, urlString: sendAnswerUrl, teacher: teacher, question: question)
            
            self.performSegue(withIdentifier: "submitAnswer", sender: self)
        }
        
    }
    
    func createQuestionImage(){

        var topConstraint : CGFloat = 0.0
        var leadingConstraint : CGFloat = 0.0
        var trailingConstraint : CGFloat = 0.0
        for constraint in view.constraints{
            if constraint.identifier == "questionLabelTop"{
                topConstraint = constraint.constant
            } else if constraint.identifier == "questionLabelLeading"{
                leadingConstraint = constraint.constant
            } else if constraint.identifier == "questionLabelTrailing"{
                trailingConstraint = constraint.constant
            }
        }
        contentHeight = questionLabel.frame.height + topConstraint
        if(question.getQuestionImage() != ""){
            let questionImage = UIImageView(frame:CGRect(x:0, y: questionLabel.frame.height + SPACING_BETWEEN_QUESION_AND_IMAGE, width: textAnswer.frame.width, height:IMAGE_HEIGHT))
            let url = URL(string: questionImageUrl + question.getQuestionImage())
            let data = try? Data(contentsOf: url!)
            questionImage.image = UIImage(data: data!)
            questionImage.contentMode = .scaleAspectFit
            questionLabel.addSubview(questionImage)
            questionImage.layoutIfNeeded()
            contentHeight = contentHeight + questionImage.frame.height + SPACING_BETWEEN_QUESION_AND_IMAGE
        }
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
        questionLabel.sizeToFit()
        createQuestionImage()
        questionLabel.layoutIfNeeded()
        textAnswer.translatesAutoresizingMaskIntoConstraints = true
        textAnswer.frame.origin.y = contentHeight + 33
        textAnswer.becomeFirstResponder()
        
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
