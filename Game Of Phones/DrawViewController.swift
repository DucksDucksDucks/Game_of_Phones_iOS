//
//  DrawViewController.swift
//  Game Of Phones
//
//  Created by Josh Harrold on 4/12/17.
//  Copyright © 2017 Josh Harrold. All rights reserved.
//

import UIKit

class DrawViewController: UIViewController {
    

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var tempImageView: UIImageView!
    var postData = PostData()
    var question : Question!
    var teacher : Teacher!
    var sendAnswerUrl = "http://mcs.drury.edu/gameofphones/mobilefiles/webservice/sendAnswer.php"
    var uploadPhotoUrl = "http://mcs.drury.edu/gameofphones/mobilefiles/webservice/uploadphoto.php"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        questionLabel.text = question.getQuestionText()
        questionLabel.text = "hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello hi"
        print(DeviceId.deviceIdForAnswer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    var lastPoint = CGPoint.zero
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var swiped = false
    
    let colors: [(CGFloat, CGFloat, CGFloat)] = [
        (0, 0, 0),
        (105.0 / 255.0, 105.0 / 255.0, 105.0 / 255.0),
        (1.0, 0, 0),
        (0, 0, 1.0),
        (51.0 / 255.0, 204.0 / 255.0, 1.0),
        (102.0 / 255.0, 204.0 / 255.0, 0),
        (102.0 / 255.0, 1.0, 0),
        (160.0 / 255.0, 82.0 / 255.0, 45.0 / 255.0),
        (1.0, 102.0 / 255.0, 0),
        (1.0, 1.0, 0),
        (1.0, 1.0, 1.0),
        ]
    
    @IBAction func reset(_ sender: Any) {
        mainImageView.image = UIImage(named: "graph.png")
        tempImageView.image = nil
    }
    @IBAction func erase(_ sender: AnyObject) {
        mainImageView.image = UIImage(named: "graph.png")
        tempImageView.image = nil
    }
    
    @IBAction func pencilPressed(_ sender: AnyObject) {
        
        var index = sender.tag ?? 0
        if index < 0 || index >= colors.count {
            index = 0
        }
        
        (red, green, blue) = colors[index]
        
        if index == colors.count - 1 {
            opacity = 1.0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = false
        if let touch = touches.first {
            lastPoint = touch.location(in: tempImageView)
        }
    }
    
    func drawLineFrom(_ fromPoint: CGPoint, toPoint: CGPoint) {
        
        UIGraphicsBeginImageContext(mainImageView.frame.size)
        let context = UIGraphicsGetCurrentContext()
        tempImageView.image?.draw(in: CGRect(x: mainImageView.bounds.origin.x, y: mainImageView.bounds.origin.y, width: mainImageView.frame.size.width, height: mainImageView.frame.size.height))
        
        context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
        
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(brushWidth)
        context?.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
        context?.setBlendMode(CGBlendMode.normal)
        
        context?.strokePath()
        
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = opacity
        UIGraphicsEndImageContext()
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.location(in: tempImageView)
            drawLineFrom(lastPoint, toPoint: currentPoint)
            
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped {
            drawLineFrom(lastPoint, toPoint: lastPoint)
        }
    }
    
    @IBAction func submit(_ sender: Any) {
        UIGraphicsBeginImageContext(mainImageView.frame.size)
        mainImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: tempImageView.frame.size.height), blendMode: CGBlendMode.normal, alpha: 1.0)
        tempImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: tempImageView.frame.size.height), blendMode: CGBlendMode.normal, alpha: opacity)
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        
        if let imageData = UIImagePNGRepresentation(mainImageView.image!) {
            let encodedImageData = imageData.base64EncodedString(options: .init(rawValue: 0)).replacingOccurrences(of: "+", with: "%2B", options: .literal, range: nil)
            
        let imageBodyData = "image=" + (encodedImageData) + "&filename=" + (DeviceId.deviceIdForAnswer) + "image"
        postData.postData(postString: imageBodyData, urlString: uploadPhotoUrl, teacher: teacher, question: question)
            
        let bodyData = "answer=" + (DeviceId.deviceIdForAnswer) + "image.png" + "&deviceID=" + (DeviceId.deviceIdForAnswer) + "&currentQID=" + (question.getQuestionId() + "&teacherID=" + (teacher.getTeacherId()))
        postData.postData(postString: bodyData, urlString: sendAnswerUrl, teacher: teacher, question: question)
        
        self.performSegue(withIdentifier: "submitAnswer", sender: self)
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destViewController : AnswerSubmittedViewController = segue.destination as? AnswerSubmittedViewController{
            destViewController.teacher = teacher
            destViewController.question = question
            
        }
    }


}
