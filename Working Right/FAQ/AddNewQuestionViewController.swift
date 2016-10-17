//
//  AddNewTopicViewController.swift
//  Working Rights
//
//  Created by Qingzhou Wang on 22/09/2016.
//  Copyright © 2016 Qingzhou Wang. All rights reserved.
//

import UIKit
import Firebase

class AddNewQuestionViewController: UIViewController {

    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet weak var questionTitle: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        automaticallyAdjustsScrollViewInsets = false
        
        nextButton.enabled = false
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.shouldHidePlaceHolder), name: UITextViewTextDidChangeNotification, object: questionTitle)
        
        let back = UIBarButtonItem()
        back.title = "Back"
        navigationItem.backBarButtonItem = back
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        questionTitle.becomeFirstResponder()
    }
    
    func shouldHidePlaceHolder()
    {
        placeholderLabel.hidden = !questionTitle.text.isEmpty
        nextButton.enabled = !questionTitle.text.isEmpty && questionTitle.text.characters.count <= 100
        if questionTitle.text.characters.count > 50
        {
            navigationItem.title = "\(questionTitle.text.characters.count)/100"
        }
        else
        {
            navigationItem.title = nil
        }
    }
    
    @IBAction func cancelAddTopic(sender: UIBarButtonItem) {
        questionTitle.endEditing(true)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "QuestionDescriptionSegue"
        {
            let vc = segue.destinationViewController as! QuestionDescriptionViewController
            vc.questionTitle = self.questionTitle.text
        }
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
