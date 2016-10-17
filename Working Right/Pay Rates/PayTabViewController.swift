//
//  PayTabViewController.swift
//  Working Rights
//
//  Created by Qingzhou Wang on 12/09/2016.
//  Copyright © 2016 Qingzhou Wang. All rights reserved.
//

import UIKit

class PayTabViewController: UITabBarController {
    
    var navigationTitle = ["Minimum Pay", "Pay Scale"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = navigationTitle[0]
        
//        let vc = viewControllers![0] as! MinPayViewController
//        let button = UIBarButtonItem(barButtonSystemItem: .Search, target: vc, action: #selector(vc.searchResult))
//        navigationItem.rightBarButtonItem = button
//        vc.searchButton = button
        
        let leftButton = UIBarButtonItem()
        leftButton.title = "Back"
        navigationItem.backBarButtonItem = leftButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        // Change navigation title and relavant bar button item.
        switch item {
        case tabBar.items![0]:
            navigationItem.title = navigationTitle[0]
            
//            let vc = viewControllers![0] as! MinPayViewController
//            let button = UIBarButtonItem(barButtonSystemItem: .Search, target: vc, action: #selector(vc.searchResult))
//            navigationItem.rightBarButtonItem = button
//            vc.searchButton = button
            navigationItem.rightBarButtonItem = nil
        default:
            navigationItem.title = navigationTitle[1]
            
            let vc = viewControllers![1] as! PayScaleViewController
            let button = UIBarButtonItem(barButtonSystemItem: .Refresh, target: vc, action: #selector(vc.reloadWeb))
            navigationItem.rightBarButtonItem = button
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
