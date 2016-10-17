//
//  QuestionDescriptionViewController.swift
//  Working Rights
//
//  Created by Qingzhou Wang on 26/09/2016.
//  Copyright © 2016 Qingzhou Wang. All rights reserved.
//

import UIKit

class QuestionDescriptionViewController: UIViewController {
    
    var questionTitle: String!
    @IBOutlet weak var publishButton: UIBarButtonItem!
    @IBOutlet weak var questionDescription: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        automaticallyAdjustsScrollViewInsets = false
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.shouldHidePlaceHolder), name: UITextViewTextDidChangeNotification, object: questionDescription)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        questionDescription.becomeFirstResponder()
    }
    
    func shouldHidePlaceHolder()
    {
        placeholderLabel.hidden = !questionDescription.text.isEmpty
    }
    
    @IBAction func publishQuestion(sender: AnyObject) {
        questionDescription.endEditing(true)
        
        let description = questionDescription.text
        let key = firebase.child("questions").childByAutoId().key
        let post = ["title": questionTitle, "description": description, "date": NSDate().description, "like": 0, "dislike": 0]
        let update = ["questions/\(key)": post]
        firebase.updateChildValues(update)
        
        let image = UIImageView(image: UIImage(named: "check mark"))
        image.tintColor = UIColor.whiteColor()
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
