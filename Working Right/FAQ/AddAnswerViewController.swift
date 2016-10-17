//
//  AddAnswerViewController.swift
//  Working Rights
//
//  Created by Qingzhou Wang on 27/09/2016.
//  Copyright © 2016 Qingzhou Wang. All rights reserved.
//

import UIKit

class AddAnswerViewController: UIViewController {

    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var answerContent: UITextView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var question: Question!
    var delegate: AnswersTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        automaticallyAdjustsScrollViewInsets = false
        doneButton.enabled = false
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.shouldHidePlaceHolder), name: UITextViewTextDidChangeNotification, object: answerContent)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        answerContent.becomeFirstResponder()
    }
    
    func shouldHidePlaceHolder()
    {
        placeholderLabel.hidden = !answerContent.text.isEmpty
        doneButton.enabled = !answerContent.text.isEmpty
    }
    
    @IBAction func cancel(sender: AnyObject) {
        answerContent.endEditing(true)
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func done(sender: AnyObject) {
        answerContent.endEditing(true)
        
        let content = answerContent.text
        let key = firebase.child("questions").child(self.question.key).child("answers").childByAutoId().key
        let post = ["content": content, "like": 0, "dislike": 0]
        let update = ["questions/\(self.question.key)/answers/\(key)": post]
        firebase.updateChildValues(update)
        
        let image = UIImageView(image: UIImage(named: "check mark"))
        image.tintColor = UIColor.whiteColor()
        
        delegate.loadData()
        view.makeToast("Done", duration: 0.5, position: .center, title: nil, image: image.image, style: nil) { (didTap) in
            self.dismissViewControllerAnimated(true, completion: nil)
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
