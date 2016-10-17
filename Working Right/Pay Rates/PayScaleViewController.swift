//
//  PayRateViewController.swift
//  Working Rights
//
//  Created by Qingzhou Wang on 19/08/2016.
//  Copyright © 2016 Qingzhou Wang. All rights reserved.
//

import UIKit

class PayScaleViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var payRateWeb: UIWebView!
    // Load script page from server.
    var urlString: String = "http://116.118.249.210:8085/payscale.php"
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Display script in a web view.
        let url = NSURL(string: urlString)
        let request = NSURLRequest(URL: url!)
        payRateWeb.delegate = self
        
        payRateWeb.loadRequest(request)
        payRateWeb.backgroundColor = UIColor.clearColor()
        payRateWeb.scrollView.scrollEnabled = false
        
        activity.color = UIColor(red: 0.8471, green: 0, blue: 0.1529, alpha: 1)
        activity.transform = CGAffineTransformMakeScale(1.5, 1.5)
        
//        payRateWeb.scrollView.scrollEnabled = false
        
//        webStartLoad("Loading page from server\nPlease wait")
//        timeOut = NSTimer.scheduledTimerWithTimeInterval(6, target: self, selector: #selector(self.cancelWeb), userInfo: nil, repeats: false)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        activity.startAnimating()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        activity.stopAnimating()
        activity.hidden = true
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        payRateWeb.scrollView.scrollEnabled = true
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        activity.stopAnimating()
        activity.hidden = true
        payRateWeb.scrollView.scrollEnabled = true
    }
    
    func reloadWeb()
    {
        payRateWeb.reload()
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
