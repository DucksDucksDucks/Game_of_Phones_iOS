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
    var sendAnswerUrl = "http://mcs.drury.edu/amerritt/sendAnswer.php"
    var uploadPhotoUrl = "http://mcs.drury.edu/gameofphones/mobilefiles/webservice/uploadphoto.php"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionLabel.text = question.getQuestionText()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    // MARK: - Actions
    
    @IBAction func reset(_ sender: Any) {
        mainImageView.image = UIImage(named: "graph.png")
        tempImageView.image = nil
    }
    @IBAction func erase(_ sender: AnyObject) {
        mainImageView.image = UIImage(named: "graph.png")
        tempImageView.image = nil
    }
    
    @IBAction func share(_ sender: AnyObject) {
        UIGraphicsBeginImageContext(mainImageView.bounds.size)
        mainImageView.image?.draw(in: CGRect(x: 0, y: 0,
                                             width: mainImageView.frame.size.width, height: mainImageView.frame.size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let activity = UIActivityViewController(activityItems: [image!], applicationActivities: nil)
        present(activity, animated: true, completion: nil)
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
        
        // 1
        UIGraphicsBeginImageContext(mainImageView.frame.size)
        let context = UIGraphicsGetCurrentContext()
        tempImageView.image?.draw(in: CGRect(x: mainImageView.bounds.origin.x, y: mainImageView.bounds.origin.y, width: mainImageView.frame.size.width, height: mainImageView.frame.size.height))
        
        // 2
        context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
        // 3
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(brushWidth)
        context?.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
        context?.setBlendMode(CGBlendMode.normal)
        
        // 4
        context?.strokePath()
        
        // 5
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = opacity
        UIGraphicsEndImageContext()
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 6
        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.location(in: tempImageView)
            drawLineFrom(lastPoint, toPoint: currentPoint)
            
            // 7
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped {
            // draw a single point
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
            let encodedImageData = imageData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            print("Here: " + encodedImageData);
        let imageBodyData = "image=" + (encodedImageData) + "&filename=" + (DeviceId.deviceIdForAnswer) + "image"
        postData.postData(postString: imageBodyData, urlString: uploadPhotoUrl, teacher: teacher, question: question)
            
        let bodyData = "answer=" + (DeviceId.deviceIdForAnswer) + "image.png" + "&deviceID=" + (DeviceId.deviceIdForAnswer) + "&currentQID=" + (question.getQuestionId())
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
