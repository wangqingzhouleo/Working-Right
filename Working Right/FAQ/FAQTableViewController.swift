//
//  FAQTableViewController.swift
//  Working Rights
//
//  Created by Qingzhou Wang on 21/09/2016.
//  Copyright © 2016 Qingzhou Wang. All rights reserved.
//

import UIKit
import Firebase

class FAQTableViewController: UITableViewController {
    
    var searchController: UISearchController!
    var nvController: UINavigationController!
    
    var indicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tableView.registerNib(UINib(nibName: "FAQCell", bundle: nil), forCellReuseIdentifier: "FAQCell")
        tableView.sectionHeaderHeight = 5
        tableView.sectionFooterHeight = 5
        
        navigationItem.title = "Q&A"
        setSearchController()
        
        let plusButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(self.addNewQuestion))
        navigationItem.rightBarButtonItem = plusButton
        
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        navigationItem.backBarButtonItem = backButton
        
        self.refreshControl?.addTarget(self, action: #selector(self.loadData), forControlEvents: .ValueChanged)
        
        addIndicator()
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return allQuestions.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FAQCell", forIndexPath: indexPath) as! FAQCell

        // Configure the cell...
        cell.selectionStyle = .None
        let question = allQuestions[indexPath.section]
        cell.questionTitle.text = question.title
        cell.bestAnswer.text = nil
        cell.like.text = "0 like"
        cell.dislike.text = "0 dislike"
        cell.answerCount.text = "0 answers"
        
        if question.answers.count > 0
        {
            let bestAnswer = question.answers[0]
            cell.bestAnswer.text = bestAnswer.content
            cell.like.text = "\(bestAnswer.like) like"
            cell.dislike.text = "\(bestAnswer.dislike) dislike"
            cell.answerCount.text = "\(question.answers.count) answers"
        }
        return cell
    }
    
    func addIndicator()
    {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.transform = CGAffineTransformMakeScale(1.5, 1.5)
        indicator.color = UIColor(red: 0.8471, green: 0, blue: 0.1529, alpha: 1)
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        view.userInteractionEnabled = false
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let question = allQuestions[indexPath.section]
        let vc = storyboard?.instantiateViewControllerWithIdentifier("AnswersTableViewController") as! AnswersTableViewController
        vc.question = question
        vc.delegate = self
        
        showViewController(vc, sender: self)
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 9999
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func setSearchController()
    {
        let resultTable = SearchFAQTableViewController(style: .Plain)
        searchController = UISearchController(searchResultsController: resultTable)
        searchController.searchResultsUpdater = resultTable
        resultTable.delegate = self
        searchController.searchBar.tintColor = UIColor(red: 0.8471, green: 0, blue: 0.1529, alpha: 1)
        
        let searchBar = searchController.searchBar
        tableView.tableHeaderView = searchBar
        searchBar.placeholder = "Search Topic or Content"
        searchController.dimsBackgroundDuringPresentation = true
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
    }
    
    func addNewQuestion()
    {
        let controller = storyboard?.instantiateViewControllerWithIdentifier("AddNewQuestionNavigationController") as! UINavigationController
        presentViewController(controller, animated: true, completion: nil)
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
                    self.indicator.stopAnimating()
                    self.refreshControl?.endRefreshing()
                    self.tableView.reloadData()
                    self.view.userInteractionEnabled = true
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                }
            })
        }
        else
        {
            view.makeCustomToast("Your iPhone is not connected to the Internet", duration: 3, position: .center, title: nil, image: nil, style: nil, completion: nil)
            self.indicator.stopAnimating()
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
