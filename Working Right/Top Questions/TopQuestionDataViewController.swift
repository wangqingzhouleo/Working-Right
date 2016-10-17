//
//  TopQuestionDataViewController.swift
//  Working Rights
//
//  Created by Qingzhou Wang on 27/09/2016.
//  Copyright © 2016 Qingzhou Wang. All rights reserved.
//

import UIKit

class TopQuestionDataViewController: UIViewController {

    @IBOutlet weak var questionTitle: UILabel!
    @IBOutlet weak var bestAnswer: UILabel!
    
    var question: Question!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        switch UIScreen.mainScreen().bounds.height {
        case 568.0:
            questionTitle.numberOfLines = 3
            bestAnswer.numberOfLines = 4
        case 667.0:
            questionTitle.numberOfLines = 0
            bestAnswer.numberOfLines = 6
        case 736.0:
            questionTitle.numberOfLines = 0
            bestAnswer.numberOfLines = 8
        default:
            break
        }
        
        
        questionTitle.text = "Q: \(question.title)"
        if question.answers.count > 0
        {
            bestAnswer.text = "A: \(question.answers[0].content)"
            bestAnswer.textAlignment = .Left
            bestAnswer.baselineAdjustment = .AlignBaselines
        }
        else
        {
            bestAnswer.text = "Click here to add answer"
            bestAnswer.textAlignment = .Center
            bestAnswer.baselineAdjustment = .AlignCenters
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
