//
//  VisaTabViewController.swift
//  Working Right
//
//  Created by Qingzhou Wang on 18/08/2016.
//  Copyright © 2016 Qingzhou Wang. All rights reserved.
//

import UIKit

class VisaTabViewController: UITabBarController {
    
    var navigationTitle = ["Student", "Working", "Other"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Set default title for this view
        navigationItem.title = navigationTitle[0]
        
        // Set visa type for different tabs. The visa type is used to filter content for that view
        let studentVC = viewControllers![0] as! VisaTypeTableViewController
        studentVC.visaType = "student"
        
        let workingVC = viewControllers![1] as! VisaTypeTableViewController
        workingVC.visaType = "working"
        
//        let otherVC = viewControllers![2] as! VisaTypeTableViewController
//        otherVC.visaType = "other"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        // Determine which tab bar is tapped, then change the title based on tab tapped.
        switch item {
        case tabBar.items![0]:
            navigationItem.title = navigationTitle[0]
            break
        case tabBar.items![1]:
            navigationItem.title = navigationTitle[1]
            break
        case tabBar.items![2]:
            navigationItem.title = navigationTitle[2]
            break
        default:
            break
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
