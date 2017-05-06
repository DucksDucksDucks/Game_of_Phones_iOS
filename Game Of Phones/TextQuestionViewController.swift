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

    @IBOutlet weak var scrollView: UIScrollView!
    
    var teacher : Teacher!
    var question : Question!
    var textAnswer : UITextField!
    var questionLabel : UILabel!
    var contentHeight : CGFloat!
    
    @IBAction func answerSubmit(_ sender: UIButton) {
        
        if !(textAnswer.text?.trimmingCharacters(in: .whitespaces).isEmpty)! || !((textAnswer.text?.isEmpty)!){
            let bodyData = "answer=" + (textAnswer.text!) + "&deviceID=" + (DeviceId.deviceIdForAnswer) + "&currentQID=" + (question.getQuestionId()) + "&teacherID=" + (teacher.getTeacherId())
            
            postData.postData(postString: bodyData, urlString: DataSource.sendAnswerUrl, teacher: teacher, question: question)
            
            self.performSegue(withIdentifier: "submitAnswer", sender: self)
        }
        
    }

    func createQuestionLabel(){
        questionLabel = UILabel(frame:CGRect(x: Layout.LEADING_SPACE, y: CGFloat(Layout.SPACING_BETWEEN_TOP_AND_QUESTION_LABEL), width: view.frame.width - Layout.CONTENT_WIDTH, height: Layout.DEFAULT_LABEL_AND_BUTTON_HEIGHT));
        questionLabel.numberOfLines = 0
        questionLabel.lineBreakMode = .byWordWrapping
        questionLabel.text = question.getQuestionText()
        questionLabel.textColor = ThemeColors.textColor
        questionLabel.font = UIFont.systemFont(ofSize: 22)
        scrollView.addSubview(questionLabel)
        questionLabel.sizeToFit()
        contentHeight = questionLabel.frame.size.height + CGFloat(Layout.SPACING_BETWEEN_TOP_AND_QUESTION_LABEL)
    }
    
    func createQuestionImage(){
        if(question.getQuestionImage() != ""){
            let questionImage = UIImageView(frame:CGRect(x:0, y: questionLabel.frame.height + Layout.SPACING_BETWEEN_QUESION_AND_IMAGE, width: view.frame.width - Layout.CONTENT_WIDTH, height: Layout.IMAGE_HEIGHT))
            let url = URL(string: DataSource.questionImageUrl + question.getQuestionImage())
            let data = try? Data(contentsOf: url!)
            questionImage.image = UIImage(data: data!)
            questionImage.contentMode = .scaleAspectFit
            questionLabel.addSubview(questionImage)
            questionImage.layoutIfNeeded()
            contentHeight = contentHeight + questionImage.frame.height + Layout.SPACING_BETWEEN_QUESION_AND_IMAGE
        }
    }
    
    func createTextAnswer(){
        textAnswer = UITextField(frame: CGRect(x: Layout.LEADING_SPACE, y: contentHeight + Layout.SPACING_BETWEEN_QUESION_AND_ANSWERS, width: view.frame.width - Layout.CONTENT_WIDTH, height: 30))
        textAnswer.backgroundColor = UIColor.white
        textAnswer.borderStyle = .roundedRect
        textAnswer.font = UIFont.systemFont(ofSize: 17)
        textAnswer.keyboardAppearance = UIKeyboardAppearance.dark
        textAnswer.placeholder = "Please enter your answer..."
        scrollView.addSubview(textAnswer)
        contentHeight = contentHeight + Layout.SPACING_BETWEEN_QUESION_AND_ANSWERS + textAnswer.frame.height
    }
    
    func createSubmitButton(){
        let submitButton = UIButton(frame: CGRect(x: Layout.LEADING_SPACE, y: contentHeight + Layout.SPACING_BETWEEN_QUESION_AND_ANSWERS, width: view.frame.width - Layout.CONTENT_WIDTH, height: Layout.DEFAULT_LABEL_AND_BUTTON_HEIGHT))
        submitButton.setTitle("Submit", for: .normal)
        submitButton.setTitleColor(view.backgroundColor, for: .normal)
        submitButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        submitButton.backgroundColor = ThemeColors.themeColor
        submitButton.addTarget(self, action: #selector(answerSubmit), for: .touchUpInside)
        scrollView.addSubview(submitButton)
        contentHeight = contentHeight + Layout.SPACING_BETWEEN_CONTENTS + submitButton.frame.height
    }
    
    func keyboardWillShowForResizing(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let window = self.view.window?.frame {
            self.view.frame = CGRect(x: self.view.frame.origin.x,
                                     y: self.view.frame.origin.y,
                                     width: self.view.frame.width,
                                     height: window.origin.y + window.height - keyboardSize.height)
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
        createQuestionLabel()
        createQuestionImage()
        questionLabel.layoutIfNeeded()
        createTextAnswer()
        textAnswer.becomeFirstResponder()
        createSubmitButton()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(TextQuestionViewController.keyboardWillShowForResizing),
                                               name: Notification.Name.UIKeyboardWillShow,
                                               object: nil)
        
        scrollView.contentSize.height = contentHeight
        
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
