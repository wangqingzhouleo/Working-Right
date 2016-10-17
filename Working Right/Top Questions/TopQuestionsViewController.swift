//
//  TopQuestionsViewController.swift
//  Working Rights
//
//  Created by Qingzhou Wang on 27/09/2016.
//  Copyright © 2016 Qingzhou Wang. All rights reserved.
//

import UIKit

class TopQuestionsViewController: UIViewController, UIPageViewControllerDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var pageControl: UIPageControl!
    var currentPageIndex = 0
    var pageController: UIPageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
    
    var timer: NSTimer?
    var delegate: ViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        configureIndicator()
        loadTopQuestions()
        
        pageController.delegate = self
        pageControl.numberOfPages = 0
        
        registerFirstPage()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        refreshTimer()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addGestures()
    {
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.scrollToPrevious))
        swipeRightGesture.delegate = self
        swipeRightGesture.direction = .Right
        view.addGestureRecognizer(swipeRightGesture)
        
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.scrollToNext))
        swipeLeftGesture.delegate = self
        swipeLeftGesture.direction = .Left
        view.addGestureRecognizer(swipeLeftGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.showTappedQuestion))
        view.addGestureRecognizer(tapGesture)
    }
    
    func viewControllerAtIndex(index: Int) -> TopQuestionDataViewController {
        // Create a new view controller and pass suitable data.
        let dataViewController = storyboard!.instantiateViewControllerWithIdentifier("TopQuestionDataViewController") as! TopQuestionDataViewController
        dataViewController.question = topQuestions[index]
        
        return dataViewController
    }
    
    func registerFirstPage()
    {
        let startingController = storyboard?.instantiateViewControllerWithIdentifier("PageMainLogoViewController") as! PageMainLogoViewController
        pageController.setViewControllers([startingController], direction: .Forward, animated: true, completion: nil)
        
        self.addChildViewController(pageController)
        self.view.addSubview(pageController.view)
        self.view.addSubview(pageControl)
        pageControl.numberOfPages = isConnectedToNetwork() ? 6 : 0
    }
    
    func refreshTimer()
    {
        timer?.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(8, target: self, selector: #selector(self.scrollToNext), userInfo: nil, repeats: false)
    }
    
    func scrollToPrevious() {
        refreshTimer()
        if currentPageIndex > 0
        {
            currentPageIndex -= 1
        }
        else
        {
            currentPageIndex = topQuestions.count
        }
        pageControl.currentPage = currentPageIndex
        
        if currentPageIndex != 0
        {
            let previousView = viewControllerAtIndex(currentPageIndex - 1)
            pageController.setViewControllers([previousView], direction: .Reverse, animated: true, completion: nil)
        }
        else
        {
            let startingController = storyboard?.instantiateViewControllerWithIdentifier("PageMainLogoViewController") as! PageMainLogoViewController
            pageController.setViewControllers([startingController], direction: .Reverse, animated: true, completion: nil)
        }
    }
    
    func scrollToNext() {
        refreshTimer()
        if currentPageIndex < topQuestions.count
        {
            currentPageIndex += 1
        }
        else
        {
            currentPageIndex = 0
        }
        pageControl.currentPage = currentPageIndex
        
        if currentPageIndex != 0
        {
            let nextView = viewControllerAtIndex(currentPageIndex - 1)
            pageController.setViewControllers([nextView], direction: .Forward, animated: true, completion: nil)
        }
        else
        {
            let startingController = storyboard?.instantiateViewControllerWithIdentifier("PageMainLogoViewController") as! PageMainLogoViewController
            pageController.setViewControllers([startingController], direction: .Forward, animated: true, completion: nil)
        }
    }
    
    func showTappedQuestion()
    {
        if currentPageIndex != 0
        {
            let vc = storyboard?.instantiateViewControllerWithIdentifier("AnswersTableViewController") as! AnswersTableViewController
            vc.question = topQuestions[currentPageIndex - 1]
            showViewController(vc, sender: nil)
        }
    }
    
    func configureIndicator()
    {
        indicator.transform = CGAffineTransformMakeScale(1.5, 1.5)
        indicator.color = UIColor(red: 0.8471, green: 0, blue: 0.1529, alpha: 1)
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
    }
    
    func loadTopQuestions()
    {
        if isConnectedToNetwork()
        {
            topQuestions.removeAll()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            firebase.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                let main = snapshot.value as! [String: AnyObject]
                if main.count > 0
                {
                    let questions = main["questions"] as! [String: AnyObject]
                    var tmpQuestions: [Question] = []
                    for key in questions.keys
                    {
                        let item = questions[key] as! [String: AnyObject]
                        var answers: [Answer] = []
                        let date = formatter.dateFromString(item["date"] as! String)!
                        
                        if let answersInFB = item["answers"] as? [String: AnyObject]
                        {
                            for key in answersInFB.keys
                            {
                                let answer = answersInFB[key] as! [String: AnyObject]
                                answers.append(Answer(key: key, content: answer["content"] as! String, like: answer["like"] as! Int, dislike: answer["dislike"] as! Int))
                            }
                        }
                        
                        answers.sortInPlace { (answer1, answer2) -> Bool in
                            let a1Net = answer1.like - answer1.dislike
                            let a2Net = answer2.like - answer2.dislike
                            return a1Net > a2Net
                        }
                        let question = Question(key: key, title: item["title"] as! String, desc: item["description"] as! String, date: date, like: item["like"] as! Int, dislike: item["dislike"] as! Int, answers: answers)
                        tmpQuestions.append(question)
                    }
                    tmpQuestions.sortInPlace({ (q1, q2) -> Bool in
                        let q1Net = q1.like - q1.dislike
                        let q2Net = q2.like - q2.dislike
                        return q1Net > q2Net
                    })
                    
                    if tmpQuestions.count > 4
                    {
                        for i in 0 ..< 5
                        {
                            topQuestions.append(tmpQuestions[i])
                        }
                    }
                    self.indicator.stopAnimating()
                    self.delegate.view.addSubview(self.delegate.menuCollectionView)
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    self.addGestures()
                    self.refreshTimer()
                }
            })
        }
    }
    
//    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
//        if currentPageIndex > 0
//        {
//            currentPageIndex -= 1
//        }
//        else
//        {
//            currentPageIndex = topQuestions.count - 1
//        }
//        return self.viewControllerAtIndex(currentPageIndex)
//    }
//    
//    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
//        if currentPageIndex < topQuestions.count - 1
//        {
//            currentPageIndex += 1
//        }
//        else
//        {
//            currentPageIndex = 0
//        }
//        return self.viewControllerAtIndex(currentPageIndex)
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
