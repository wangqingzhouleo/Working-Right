//
//  ViewController.swift
//  Working Right
//
//  Created by Qingzhou Wang on 14/08/2016.
//  Copyright © 2016 Qingzhou Wang. All rights reserved.
//

import UIKit
import Instructions
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CoachMarksControllerDataSource, CoachMarksControllerDelegate, UICollectionViewDelegateFlowLayout {
    
    // Use Coach Mark package to display instructions for the app
    let coachMarksController = CoachMarksController()
    lazy var pointOfInterest = [UIView?](count: 6, repeatedValue: nil)
    let hintText = ["View visa information and working rights", "View cases history", "Search minimum pay or pay scale", "Frequently asked questions", "Display legal services", "Tips for finding a job"]

    @IBOutlet weak var menuCollectionView: UICollectionView!
    @IBOutlet weak var container: UIView!
    
//    let imageName = ["visa info.png", "cases.png", "pay rates.png", "cases.png"]
//    let cellIdentifier = ["VisaInfoCell", "CasesCell", "PayRatesCell"]
    let menuLabelText = ["Visa & Rights", "Cases", "Pay Rates", "Q&A", "Legal Aid", "Job Tips"]
    
    let viewControllerIdentifier = ["VisaTabViewController", "CompaniesTableViewController", "PayTabViewController", "FAQTableViewController", "LegalServiceViewController", "TipsTabViewController"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set collection view's delegate and data source to this controller
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
        menuCollectionView.backgroundColor = UIColor.clearColor()
        menuCollectionView.scrollEnabled = false
        menuCollectionView.contentInset.top = -15
        
        self.coachMarksController.dataSource = self
        self.coachMarksController.allowOverlayTap = true
        
        // Set skip view for tutorial
        let skipView = CoachMarkSkipDefaultView()
        skipView.setTitle("Skip", forState: .Normal)
        self.coachMarksController.skipView = skipView
        
//        let width: CGFloat = UIScreen.mainScreen().bounds.width
//        let height: CGFloat = width * 736 / 880
//        workingRightsImage.image = imageResize(UIImage(named: "main page image.png")!, sizeChange: CGSize(width: width, height: height))
        
//        if let layout = menuCollectionView?.collectionViewLayout as? MenuLayout {
//            layout.delegate = self
//        }
        
        let leftButton = UIBarButtonItem()
        leftButton.title = "Back"
        navigationItem.backBarButtonItem = leftButton
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.8471, green: 0, blue: 0.1529, alpha: 1)
        automaticallyAdjustsScrollViewInsets = false
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if !NSUserDefaults.standardUserDefaults().boolForKey("everLaunched")
        {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "everLaunched")
            self.coachMarksController.startOn(self)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // The flow should always be stopped once the view disappear.
        self.coachMarksController.stop(immediately: true)
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "PayRateSegue"
//        {
//            let vc = segue.destinationViewController as! PayRatesViewController
//            vc.urlString = "http://40.126.229.151/payscale.php"
//        }
//    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuLabelText.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier[indexPath.row], forIndexPath: indexPath)
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MenuCell", forIndexPath: indexPath) as! MenuCell
        pointOfInterest[indexPath.item] = cell
        
        cell.menuImage.image = UIImage(named: menuLabelText[indexPath.item])
        cell.menuLabel.text = menuLabelText[indexPath.item]
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = collectionView.bounds.size.width / 3
        let height = collectionView.bounds.size.height / 2
        return CGSizeMake(width - 10, height)
    }
    
    // Mandatory function from coach marks, return number of coach marks to display
    func numberOfCoachMarksForCoachMarksController(coachMarksController: CoachMarksController) -> Int {
        return menuLabelText.count
    }
    
    // Customize how a coach mark will position and appear.
    func coachMarksController(coachMarksController: CoachMarksController, coachMarksForIndex index: Int) -> CoachMark {
        return coachMarksController.coachMarkForView(self.pointOfInterest[index])
    }
    
    // The third one supplies two views (much like cellForRowAtIndexPath) in the form a Tuple. The body view is mandatory, as it's the core of the coach mark. The arrow view is optional.
    func coachMarksController(coachMarksController: CoachMarksController, coachMarkViewsForIndex index: Int, coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        
        let coachViews = coachMarksController.defaultCoachViewsWithArrow(true, arrowOrientation: coachMark.arrowOrientation, hintText: hintText[index], nextText: nil)
        
        return (coachViews.bodyView, coachViews.arrowView)
    }
    
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! MenuCell
//        cell.menuImage.layer.backgroundColor = UIColor.blackColor().CGColor
//        cell.menuImage.layer.opacity = 0.5
        cell.menuImage.alpha = 0.3
        cell.menuLabel.alpha = 0.3
    }
    
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! MenuCell
//        cell.menuImage.layer.backgroundColor = nil
//        cell.menuImage.layer.opacity = 1
        cell.menuImage.alpha = 1
        cell.menuLabel.alpha = 1
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.item < viewControllerIdentifier.count
        {
            if let next = self.storyboard?.instantiateViewControllerWithIdentifier(viewControllerIdentifier[indexPath.item])
            {
                navigationController?.showViewController(next, sender: self)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ContainerSegue"
        {
            let vc = segue.destinationViewController as! TopQuestionsViewController
            vc.delegate = self
        }
    }
    
//    func aaa() {
//        let url = NSURL(string: "itms://itunes.apple.com/de/app/Working-Rights/id1146121177?mt=8")
//        UIApplication.sharedApplication().openURL(url!)
//    }
}

