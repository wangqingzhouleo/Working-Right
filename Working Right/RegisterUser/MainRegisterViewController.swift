//
//  MainRegisterViewController.swift
//  Working Rights
//
//  Created by Qingzhou Wang on 27/09/2016.
//  Copyright © 2016 Qingzhou Wang. All rights reserved.
//

import UIKit

class MainRegisterViewController: UIViewController, UIPageViewControllerDelegate {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    var pageController: UIPageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
    var currentPageIndex = 0
    let labelText = ["Please tell us your name", "Are you an international student?", "What type of visa are you holding?"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        pageController.delegate = self
        skipButton.addTarget(self, action: #selector(self.finishRegister), forControlEvents: .TouchUpInside)
        
        let startingController: RegisterPageDataViewController = self.viewControllerAtIndex(currentPageIndex)
        pageController.setViewControllers([startingController], direction: .Forward, animated: true, completion: nil)
        
        self.addChildViewController(pageController)
        self.view.addSubview(pageController.view)
        
        self.view.addSubview(backButton)
        self.view.addSubview(skipButton)
        
        showButtons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewControllerAtIndex(index: Int) -> RegisterPageDataViewController {
        // Create a new view controller and pass suitable data.
        let dataViewController = storyboard!.instantiateViewControllerWithIdentifier("RegisterPageDataViewController") as! RegisterPageDataViewController
        dataViewController.delegate = self
        return dataViewController
    }
    
    func scrollToNext() {
        if currentPageIndex < labelText.count - 1
        {
            currentPageIndex += 1
            let nextView = viewControllerAtIndex(currentPageIndex)
            pageController.setViewControllers([nextView], direction: .Forward, animated: true, completion: nil)
            showButtons()
        }
    }
    
    func scrollToPrevious() {
        if currentPageIndex > 0
        {
            currentPageIndex -= 1
            let previousView = viewControllerAtIndex(currentPageIndex)
            pageController.setViewControllers([previousView], direction: .Reverse, animated: true, completion: nil)
            showButtons()
        }
    }
    
    func showButtons()
    {
        // If current page is first page, hide back button.
        backButton.hidden = currentPageIndex == 0
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func back(sender: AnyObject) {
        scrollToPrevious()
    }
    
    func finishRegister()
    {
        let vc = storyboard!.instantiateViewControllerWithIdentifier("RootNavigationController")
        let transitionManager = TransitionManager()
        vc.transitioningDelegate = transitionManager
        showViewController(vc, sender: nil)
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
