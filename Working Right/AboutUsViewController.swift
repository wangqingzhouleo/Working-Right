//
//  AboutUsViewController.swift
//  Working Rights
//
//  Created by Qingzhou Wang on 20/08/2016.
//  Copyright © 2016 Qingzhou Wang. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Load about us page from Azure server
        let url = NSURL(string: "http://116.118.249.210:8085/aboutus/aboutus.html")
        let request = NSURLRequest(URL: url!)
        webView.delegate = self
        
        webView.loadRequest(request)
        webView.backgroundColor = UIColor.clearColor()
        
        
        webStartLoad("Loading page from server\nPlease wait")
        timeOut = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: #selector(self.cancelWeb), userInfo: nil, repeats: false)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        SwiftSpinner.hide()
        timeOut.invalidate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func done(sender: AnyObject) {
//        navigationController?.popViewControllerAnimated(true)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func cancelWeb()
    {
        // Display error message when load web time out, and dismiss this view controller when user tapped on screen.
        SwiftSpinner.show("Connection time out\nPlease try later", animated: false).addTapHandler({
            SwiftSpinner.hide()
            self.dismissViewControllerAnimated(true, completion: nil)
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
