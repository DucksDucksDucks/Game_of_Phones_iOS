//
//  ThirdViewController.swift
//  Game Of Phones
//
//  Created by Josh Harrold on 12/4/16.
//  Copyright © 2016 Josh Harrold. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {

    @IBOutlet weak var scroll: UIScrollView!
    
    @IBOutlet weak var question: UILabel!
    
    var questionText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        question.text = questionText
        
            activityIndicator.stopAnimating()
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
