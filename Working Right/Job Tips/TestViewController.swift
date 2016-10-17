//
//  TestViewController.swift
//  Working Rights
//
//  Created by Qingzhou Wang on 12/09/2016.
//  Copyright © 2016 Qingzhou Wang. All rights reserved.
//

import UIKit

class TestViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var web: UIWebView!
    var hide = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let path = NSBundle.mainBundle().pathForResource("sample resume", ofType: "pdf")
        let url = NSURL(fileURLWithPath: path!)
        let request = NSURLRequest(URL: url)
        web.loadRequest(request)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.tap))
        gesture.delegate = self
        web.addGestureRecognizer(gesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tap()
    {
        UIView.animateWithDuration(0.3) {
            self.hide = !self.hide
            self.navigationController?.navigationBarHidden = self.hide
            self.tabBarController?.tabBar.hidden = self.hide
            UIApplication.sharedApplication().statusBarHidden = self.hide
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
