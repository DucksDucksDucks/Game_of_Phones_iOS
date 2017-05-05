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
    var selectedAnswer = [String:String]()
    
    
    var questionLabel : UILabel!
    var contentHeight : CGFloat!
    @IBOutlet weak var scrollView: UIScrollView!
    
    func submit(sender: UIButton){
        var answerId: String!
        if(selectedAnswer["Answer"] != nil){
            for i in (0..<question.getQuestionAnswers().count){
                if(selectedAnswer["Answer"] == question.getQuestionAnswers()[i]["a_text"] as? String){
                    answerId = question.getQuestionAnswers()[i]["a_id"] as! String
                    break
                }
            }
            
            let bodyData = "answer=" + (answerId) + "&deviceID=" + (DeviceId.deviceIdForAnswer) + "&currentQID=" + (question.getQuestionId()) + "&teacherID=" + (teacher.getTeacherId())
            postData.postData(postString: bodyData, urlString: DataSource.sendAnswerUrl, teacher: teacher, question: question)
            
            self.performSegue(withIdentifier: "submitAnswer", sender: self)
        }

    }
    
    private func createRadioButton(frame : CGRect, title : String, id : String, color : UIColor) -> DLRadioButton {
        
        let radioButton = DLRadioButton(frame: frame);
        radioButton.titleLabel!.font = UIFont.systemFont(ofSize: 18);
        radioButton.setTitle(title, for: UIControlState.normal);
        radioButton.setTitleColor(color, for: UIControlState.normal);
        radioButton.iconSize = 25
        radioButton.iconColor = ThemeColors.textColor;
        radioButton.indicatorColor = ThemeColors.themeColor;
        radioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left;
        radioButton.addTarget(self, action: #selector(QuestionViewController.logSelectedButton), for: UIControlEvents.touchUpInside);
        radioButton.titleLabel?.lineBreakMode = .byWordWrapping
        radioButton.titleLabel?.numberOfLines = 0
        radioButton.contentVerticalAlignment = .top
        radioButton.layoutIfNeeded()
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
    
    func createFirstRadioButton() -> DLRadioButton{
        if(question.getQuestionAnswers().count == 0){
            question.setQuestionAnswers(questionAnswers: [["a_id" : "1" as AnyObject, "a_text" : "True" as AnyObject],["a_id" : "2" as AnyObject, "a_text" : "False" as AnyObject]])
        }
        
        let frame = CGRect(x: Layout.LEADING_SPACE, y: contentHeight + Layout.SPACING_BETWEEN_CONTENTS, width: view.frame.width - Layout.CONTENT_WIDTH, height: Layout.DEFAULT_RADIO_BUTTON_HEIGHT);
        let firstRadioButton = createRadioButton(frame: frame, title: question.getQuestionAnswers()[0]["a_text"] as! String, id : question.getQuestionAnswers()[0]["a_id"] as! String, color: ThemeColors.textColor);
        
        contentHeight = contentHeight + Layout.SPACING_BETWEEN_CONTENTS + (firstRadioButton.titleLabel?.frame.height)!
        
        if(question.getQuestionAnswers()[0]["p_filename"] as? String != nil){
            var imageView: UIImageView
            imageView = UIImageView(frame:CGRect(x:40, y: contentHeight + Layout.SPACING_BETWEEN_QUESION_AND_IMAGE, width: view.frame.width - Layout.LEADING_SPACE - Layout.CONTENT_WIDTH, height: Layout.IMAGE_HEIGHT))
            let url = URL(string: DataSource.questionImageUrl + (question.getQuestionAnswers()[0]["p_filename"] as! String))
            let data = try? Data(contentsOf: url!)
            imageView.image = UIImage(data: data!)
            imageView.contentMode = .scaleAspectFit
            scrollView.addSubview(imageView)
            contentHeight = contentHeight + Layout.SPACING_BETWEEN_QUESION_AND_IMAGE + Layout.SPACING_BETWEEN_CONTENTS + imageView.frame.height
        }
        return firstRadioButton
    }
    
    func createOtherRadioButtons() -> [DLRadioButton]{
        var i = 0
        var otherButtons : [DLRadioButton] = [];
        for _ in question.getQuestionAnswers(){
            if(i == 0){
                i += 1
            }
            else{
                let frame = CGRect(x: Layout.LEADING_SPACE, y: contentHeight + Layout.SPACING_BETWEEN_CONTENTS, width: view.frame.width - Layout.CONTENT_WIDTH, height: Layout.DEFAULT_RADIO_BUTTON_HEIGHT);
                let radioButton = createRadioButton(frame: frame, title: question.getQuestionAnswers()[i]["a_text"] as! String, id: question.getQuestionAnswers()[i]["a_id"] as! String, color: ThemeColors.textColor);
                contentHeight = contentHeight + Layout.SPACING_BETWEEN_CONTENTS + (radioButton.titleLabel?.frame.height)!
                
                if(question.getQuestionAnswers()[i]["p_filename"] as? String != nil){
                    var imageView: UIImageView
                    imageView = UIImageView(frame:CGRect(x:40, y: contentHeight + Layout.SPACING_BETWEEN_QUESION_AND_IMAGE, width: view.frame.width - Layout.LEADING_SPACE - Layout.CONTENT_WIDTH, height: Layout.IMAGE_HEIGHT))
                    let url = URL(string: "http://mcs.drury.edu/gameofphones/mobilefiles/images/\(question.getQuestionAnswers()[i]["p_filename"]!)")
                    let data = try? Data(contentsOf: url!)
                    imageView.image = UIImage(data: data!)
                    imageView.contentMode = .scaleAspectFit
                    scrollView.addSubview(imageView)
                    imageView.layoutIfNeeded()
                    contentHeight = contentHeight + Layout.SPACING_BETWEEN_QUESION_AND_IMAGE + imageView.frame.height
                }
                i += 1
                otherButtons.append(radioButton)
            }
        }
        return otherButtons
    }
    
    func createQuestionLabel(){
        questionLabel = UILabel(frame:CGRect(x: Layout.LEADING_SPACE, y: 0, width: view.frame.width - Layout.CONTENT_WIDTH, height: Layout.DEFAULT_LABEL_AND_BUTTON_HEIGHT))
        questionLabel.numberOfLines = 0
        questionLabel.lineBreakMode = .byWordWrapping
        questionLabel.text = question.getQuestionText()
        questionLabel.textColor = ThemeColors.textColor
        questionLabel.font = UIFont.systemFont(ofSize: 22)
        questionLabel.sizeToFit()
        scrollView.addSubview(questionLabel)
        contentHeight = questionLabel.frame.size.height
    }
    
    func createSubmitButton(){
        let submitButton = UIButton(frame: CGRect(x: Layout.LEADING_SPACE, y: contentHeight + Layout.SPACING_BETWEEN_CONTENTS, width: view.frame.width - Layout.CONTENT_WIDTH, height: Layout.DEFAULT_LABEL_AND_BUTTON_HEIGHT))
        submitButton.setTitle("Submit", for: .normal)
        submitButton.setTitleColor(view.backgroundColor, for: .normal)
        submitButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        submitButton.backgroundColor = ThemeColors.themeColor
        submitButton.addTarget(self, action: #selector(submit), for: .touchUpInside)
        scrollView.addSubview(submitButton)
        contentHeight = contentHeight + Layout.SPACING_BETWEEN_SUBMIT_BUTTON_AND_VIEW + submitButton.frame.height
    }
    
    func createQuestionImage(){
        if(question.getQuestionImage() != ""){
            let questionImage = UIImageView(frame:CGRect(x:Layout.LEADING_SPACE, y: questionLabel.frame.height + Layout.SPACING_BETWEEN_QUESION_AND_IMAGE, width: view.frame.width - Layout.LEADING_SPACE - Layout.CONTENT_WIDTH, height:Layout.IMAGE_HEIGHT))
            let url = URL(string: DataSource.questionImageUrl + question.getQuestionImage())
            let data = try? Data(contentsOf: url!)
            questionImage.image = UIImage(data: data!)
            questionImage.contentMode = .scaleAspectFit
            questionLabel.addSubview(questionImage)
            contentHeight = contentHeight + Layout.SPACING_BETWEEN_QUESION_AND_IMAGE + questionImage.frame.height + Layout.SPACING_BETWEEN_QUESION_AND_ANSWERS
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createQuestionLabel()
        createQuestionImage()
        createFirstRadioButton().otherButtons = createOtherRadioButtons()
        createSubmitButton()
        scrollView.contentSize.height = contentHeight
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
