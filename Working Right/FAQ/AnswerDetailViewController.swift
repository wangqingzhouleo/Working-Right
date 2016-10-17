//
//  AnswerDetailViewController.swift
//  Working Rights
//
//  Created by Qingzhou Wang on 26/09/2016.
//  Copyright © 2016 Qingzhou Wang. All rights reserved.
//

import UIKit

class AnswerDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var like: UIBarButtonItem!
    @IBOutlet weak var dislike: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var question: Question!
    var selectedAnswerIndex: Int!
    var delegate: AnswersTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        questionLabel.text = question.title
//        answerLabel.text = question.answers[selectedAnswerIndex].content
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderHeight = 5
        tableView.sectionFooterHeight = 5
        
        // Tag 0 means the button is not selected, 1 means is selected
        like.tag = 0
        dislike.tag = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .None
//        if indexPath.section == 0
//        {
//            cell.textLabel?.text = question.title
//            cell.textLabel?.numberOfLines = 0
//        }
//        else
//        {
            cell.textLabel?.text = question.answers[selectedAnswerIndex].content
            cell.textLabel?.numberOfLines = 0
//        }
        
        return cell
    }

    @IBAction func pressLike(sender: AnyObject) {
        dislike.image = UIImage(named: "answer - dislike")
        if dislike.tag != 0
        {
            dislike.tag = 0
            modifyAmount(forType: "dislike", byAmount: -1)
        }
        
        switch like.tag {
        case 0:
            like.tag = 1
            like.image = UIImage(named: "answer - like - selected")
            modifyAmount(forType: "like", byAmount: 1)
        default:
            like.tag = 0
            like.image = UIImage(named: "answer - like")
            modifyAmount(forType: "like", byAmount: -1)
        }
    }
    
    @IBAction func pressDislike(sender: AnyObject) {
        like.image = UIImage(named: "answer - like")
        if like.tag != 0
        {
            like.tag = 0
            modifyAmount(forType: "like", byAmount: -1)
        }
        
        switch dislike.tag {
        case 0:
            dislike.tag = 1
            dislike.image = UIImage(named: "answer - dislike - selected")
            modifyAmount(forType: "dislike", byAmount: 1)
        default:
            dislike.tag = 0
            dislike.image = UIImage(named: "answer - dislike")
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
                let answers = question["answers"] as! [String: AnyObject]
                let key = self.question.answers[self.selectedAnswerIndex].key
                let selectedAnswer = answers[key] as! [String: AnyObject]
                var amount = selectedAnswer[type] as! Int
                amount += count
                
                firebase.child("questions").child(self.question.key).child("answers").child(key).updateChildValues([type: amount])
                self.delegate.loadData()
            }
        })
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 9999
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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
