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
        
//        webStartLoad("Loading website\nPlease wait")
//        timeOut = NSTimer.scheduledTimerWithTimeInterval(6, target: self, selector: #selector(self.cancelWeb), userInfo: nil, repeats: false)
    }
    
//    func webViewDidStartLoad(webView: UIWebView) {
//        SwiftSpinner.show("Loading website\nPlease wait")
//    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        // Show activity indicator to tell user the app is loading data.
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        if shouldWebStartLoad()
        {
            timeOut = NSTimer.scheduledTimerWithTimeInterval(6, target: self, selector: #selector(self.cancelWeb), userInfo: nil, repeats: false)
        }
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        // Hide activity indicator when load failed.
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        SwiftSpinner.show(error!.localizedDescription, animated: false).addTapHandler({
            SwiftSpinner.hide()
            self.navigationController?.popViewControllerAnimated(true)
        })
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        SwiftSpinner.hide()
        if timeOut != nil
        {
            timeOut!.invalidate()
        }
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
    
//    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
//        SwiftSpinner.show("Error when loading page\nPlease check your network connection", animated: false).addTapHandler({
//            SwiftSpinner.hide()
//            self.navigationController?.popViewControllerAnimated(true)
//        })
//        timeOut.invalidate()
//    }
    
    func cancelWeb()
    {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        // Display error message when load web time out, and dismiss this view controller when user tapped on screen.
        SwiftSpinner.show(webTimeOutMsg, animated: false).addTapHandler({
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
