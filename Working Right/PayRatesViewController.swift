//
//  PayRateViewController.swift
//  Working Rights
//
//  Created by Qingzhou Wang on 19/08/2016.
//  Copyright © 2016 Qingzhou Wang. All rights reserved.
//

import UIKit

class PayRatesViewController: UIViewController, UIWebViewDelegate {

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
        
//        payRateWeb.scrollView.scrollEnabled = false
        
//        webStartLoad("Loading page from server\nPlease wait")
//        timeOut = NSTimer.scheduledTimerWithTimeInterval(6, target: self, selector: #selector(self.cancelWeb), userInfo: nil, repeats: false)
        
//        let button = UIBarButtonItem(title: "Back", style: .Bordered, target: self, action: #selector(self.reloadWeb))
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: #selector(self.reloadWeb))
        navigationItem.rightBarButtonItem = button
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        activity.startAnimating()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        activity.stopAnimating()
        activity.hidden = true
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        activity.stopAnimating()
        activity.hidden = true
        let alert = UIAlertController(title: "Error", message: "Network connection fails", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
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
