//
//  QuestionComponentCell.swift
//  Working Rights
//
//  Created by Qingzhou Wang on 27/09/2016.
//  Copyright © 2016 Qingzhou Wang. All rights reserved.
//

import UIKit

class QuestionComponentCell: UITableViewCell {

    @IBOutlet weak var like: UIButton!
    @IBOutlet weak var dislike: UIButton!
    
    var question: Question!
    var delegate: AnswersTableViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Tag 0 means the button is not selected, 1 means is selected
        like.tag = 0
        dislike.tag = 0
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func pressLike(sender: AnyObject) {
        dislike.setImage(UIImage(named: "answer - dislike"), forState: .Normal)
        if dislike.tag != 0
        {
            dislike.tag = 0
            modifyAmount(forType: "dislike", byAmount: -1)
        }
        
        switch like.tag {
        case 0:
            like.tag = 1
            like.setImage(UIImage(named: "answer - like - selected"), forState: .Normal)
            modifyAmount(forType: "like", byAmount: 1)
        default:
            like.tag = 0
            like.setImage(UIImage(named: "answer - like"), forState: .Normal)
            modifyAmount(forType: "like", byAmount: -1)
        }
    }
    
    @IBAction func pressDislike(sender: AnyObject) {
        like.setImage(UIImage(named: "answer - like"), forState: .Normal)
        if like.tag != 0
        {
            like.tag = 0
            modifyAmount(forType: "like", byAmount: -1)
        }
        
        switch dislike.tag {
        case 0:
            dislike.tag = 1
            dislike.setImage(UIImage(named: "answer - dislike - selected"), forState: .Normal)
            modifyAmount(forType: "dislike", byAmount: 1)
        default:
            dislike.tag = 0
            dislike.setImage(UIImage(named: "answer - dislike"), forState: .Normal)
            modifyAmount(forType: "dislike", byAmount: -1)
        }
    }
    
    func modifyAmount(forType type: String, byAmount count: Int)
    {
        firebase.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            let main = snapshot.value as! [String: AnyObject]
            if main.count > 0
            {
                let questions = main["questions"] as! [String: AnyObject]
                let question = questions[self.question.key] as! [String: AnyObject]
                var amount = question[type] as! Int
                amount += count
                
                firebase.child("questions").child(self.question.key).updateChildValues([type: amount])
            }
        })
    }
    
    @IBAction func addAnswer(sender: AnyObject) {
        let vc = delegate.storyboard?.instantiateViewControllerWithIdentifier("AddAnswerNavigationController") as! UINavigationController
        delegate.showViewController(vc, sender: nil)
        let controller = vc.topViewController as! AddAnswerViewController
        controller.question = delegate.question
        controller.delegate = delegate
    }
}
