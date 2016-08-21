//
//  CaseDetailsViewController.swift
//  Working Rights
//
//  Created by Qingzhou Wang on 20/08/2016.
//  Copyright © 2016 Qingzhou Wang. All rights reserved.
//

import UIKit

class CaseDetailsViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    var company: Company?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Get url from company's case, then load the web page to display details.
        let url = NSURL(string: company!.link!)
        let request = NSURLRequest(URL: url!)
        self.webView.loadRequest(request)
        webView.delegate = self
        
        webView.backgroundColor = UIColor.clearColor()
        webStartLoad("Loading website\nPlease wait")
        timeOut = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: #selector(self.cancelWeb), userInfo: nil, repeats: false)
    }
    
//    func webViewDidStartLoad(webView: UIWebView) {
//        SwiftSpinner.show("Loading website\nPlease wait")
//    }
//    
    func webViewDidFinishLoad(webView: UIWebView) {
        SwiftSpinner.hide()
        timeOut.invalidate()
    }
    
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        
//        webView.scrollView.contentInset = UIEdgeInsetsZero
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cancelWeb()
    {
        // Display error message when load web time out, and dismiss this view controller when user tapped on screen.
        SwiftSpinner.show("Connection time out\nPlease try later", animated: false).addTapHandler({
            SwiftSpinner.hide()
            self.navigationController?.popViewControllerAnimated(true)
        })
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
