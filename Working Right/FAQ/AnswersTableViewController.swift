//
//  AnswersTableViewController.swift
//  Working Rights
//
//  Created by Qingzhou Wang on 26/09/2016.
//  Copyright © 2016 Qingzhou Wang. All rights reserved.
//

import UIKit

class AnswersTableViewController: UITableViewController {
    
    var question: Question!
    var delegate: FAQTableViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tableView.registerNib(UINib(nibName: "QuestionCell", bundle: nil), forCellReuseIdentifier: "QuestionCell")
        tableView.registerNib(UINib(nibName: "QuestionComponentCell", bundle: nil), forCellReuseIdentifier: "QuestionComponentCell")
        tableView.registerNib(UINib(nibName: "AnswerCell", bundle: nil), forCellReuseIdentifier: "AnswerCell")
        
        navigationItem.title = "\(question.answers.count) Answers"
        tableView.sectionHeaderHeight = 5
        tableView.sectionFooterHeight = 5
        
        self.refreshControl?.addTarget(self, action: #selector(self.loadData), forControlEvents: .ValueChanged)
        
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        navigationItem.backBarButtonItem = backButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return question.answers.count + 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return section == 0 ? 2 : 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0
        {
            if indexPath.row == 0
            {
                let cell = tableView.dequeueReusableCellWithIdentifier("QuestionCell", forIndexPath: indexPath) as! QuestionCell
                
                // Configure the cell...
                cell.titleLabel.text = question.title
                cell.descLabel.text = question.desc.isEmpty ? nil : question.desc
                
                return cell
            }
            else
            {
                let cell = tableView.dequeueReusableCellWithIdentifier("QuestionComponentCell", forIndexPath: indexPath) as! QuestionComponentCell
                cell.question = self.question
                cell.delegate = self
                return cell
            }
        }
        else
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("AnswerCell", forIndexPath: indexPath) as! AnswerCell
            if question.answers.count > 0
            {
                let bestAnswer = question.answers[indexPath.section - 1]
                cell.answerLabel.text = bestAnswer.content
                cell.like.text = "\(bestAnswer.like) like"
                cell.dislike.text = "\(bestAnswer.dislike) dislike"
            }
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 9999
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "question"
        case 1:
            return "answers"
        default:
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section != 0
        {
            let vc = storyboard?.instantiateViewControllerWithIdentifier("AnswerDetailViewController") as! AnswerDetailViewController
            vc.question = self.question
            vc.selectedAnswerIndex = indexPath.section - 1
            vc.delegate = self
            showViewController(vc, sender: self)
        }
    }
    
    func loadData()
    {
        if isConnectedToNetwork()
        {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            
            firebase.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                allQuestions.removeAll()
                let main = snapshot.value as! [String: AnyObject]
                if main.count > 0
                {
                    let questions = main["questions"] as! [String: AnyObject]
                    for key in questions.keys
                    {
                        let item = questions[key] as! [String: AnyObject]
                        var answers: [Answer] = []
                        let date = formatter.dateFromString(item["date"] as! String)!
                        
                        if let answersInFB = item["answers"] as? [String: AnyObject]
                        {
                            for key in answersInFB.keys
                            {
                                let answer = answersInFB[key] as! [String: AnyObject]
                                answers.append(Answer(key: key, content: answer["content"] as! String, like: answer["like"] as! Int, dislike: answer["dislike"] as! Int))
                            }
                        }
                        
                        answers.sortInPlace { (answer1, answer2) -> Bool in
                            let a1Net = answer1.like - answer1.dislike
                            let a2Net = answer2.like - answer2.dislike
                            return a1Net > a2Net
                        }
                        let question = Question(key: key, title: item["title"] as! String, desc: item["description"] as! String, date: date, like: item["like"] as! Int, dislike: item["dislike"] as! Int, answers: answers)
                        allQuestions.append(question)
                    }
                    allQuestions.sortInPlace({ (q1, q2) -> Bool in
                        let q1Net = q1.like - q1.dislike
                        let q2Net = q2.like - q2.dislike
                        return q1Net > q2Net
                    })
                    self.refreshControl?.endRefreshing()
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    
                    for item in allQuestions
                    {
                        if item.key == self.question.key
                        {
                            self.question = item
                            self.tableView.reloadData()
                            break
                        }
                    }
                }
            })
        }
        else
        {
            view.makeCustomToast("Network connection fails", duration: 3, position: .center, title: nil, image: nil, style: nil, completion: nil)
            self.refreshControl?.endRefreshing()
            view.userInteractionEnabled = true
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
