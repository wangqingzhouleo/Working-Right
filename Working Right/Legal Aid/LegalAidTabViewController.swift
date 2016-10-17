//
//  LegalAidViewController.swift
//  Working Rights
//
//  Created by Qingzhou Wang on 24/08/2016.
//  Copyright © 2016 Qingzhou Wang. All rights reserved.
//

import UIKit

class LegalAidTabViewController: UITabBarController {
    
    var navigationTitle = ["Legal Aid Victoria", "Other Organization"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Set default title for this view
        navigationItem.title = navigationTitle[0]
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
            // Change the legal aid field to filter different result that should displayed on the map.
        case tabBar.items![1]:
            navigationItem.title = navigationTitle[1]
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
