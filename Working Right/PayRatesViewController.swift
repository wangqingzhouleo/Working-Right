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
        
        webStartLoad("Loading page from server\nPlease wait")
        timeOut = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: #selector(self.cancelWeb), userInfo: nil, repeats: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func webViewDidStartLoad(webView: UIWebView) {
//        SwiftSpinner.show("Loading page from server\nPlease wait")
//    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        SwiftSpinner.hide()
        timeOut.invalidate()
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
