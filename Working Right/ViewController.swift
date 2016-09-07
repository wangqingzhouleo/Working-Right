//
//  ViewController.swift
//  Working Right
//
//  Created by Qingzhou Wang on 14/08/2016.
//  Copyright © 2016 Qingzhou Wang. All rights reserved.
//

import UIKit
import Instructions

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CoachMarksControllerDataSource, CoachMarksControllerDelegate {
    
    // Use Coach Mark package to display instructions for the app
    let coachMarksController = CoachMarksController()
    lazy var pointOfInterest = [UIView?](count: 6, repeatedValue: nil)
    let hintText = ["View visa information", "View cases history", "Search pay scale", "Working rights and conditions", "Display legal services", "Tips for finding a job"]

    @IBOutlet weak var menuCollectionView: UICollectionView!
    @IBOutlet weak var workingRightsImage: UIImageView!
    
//    let imageName = ["visa info.png", "cases.png", "pay rates.png", "cases.png"]
//    let cellIdentifier = ["VisaInfoCell", "CasesCell", "PayRatesCell"]
    let menuLabelText = ["Visa Info", "Cases", "Pay Rates", "Rights", "Legal Aid", "Job Tips"]
    
    let viewControllerIdentifier = ["VisaTabViewController", "CompaniesTableViewController", "PayRatesViewController", "RightsTabViewController", "LegalAidTabViewController", "TipsTabViewController"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set collection view's delegate and data source to this controller
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
        menuCollectionView.backgroundColor = UIColor.clearColor()
        menuCollectionView.scrollEnabled = false
        workingRightsImage.image = UIImage(named: "main page image.png")
        
        self.coachMarksController.dataSource = self
        self.coachMarksController.allowOverlayTap = true
        
        // Set skip view for tutorial
        let skipView = CoachMarkSkipDefaultView()
        skipView.setTitle("Skip", forState: .Normal)
        self.coachMarksController.skipView = skipView
        
//        let width: CGFloat = UIScreen.mainScreen().bounds.width
//        let height: CGFloat = width * 736 / 880
//        workingRightsImage.image = imageResize(UIImage(named: "main page image.png")!, sizeChange: CGSize(width: width, height: height))
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
    
    // Mandatory function from coach marks, return number of coach marks to display
    func numberOfCoachMarksForCoachMarksController(coachMarksController: CoachMarksController) -> Int {
        return menuLabelText.count
    }
    
    // Customize how a coach mark will position and appear.
    func coachMarksController(coachMarksController: CoachMarksController, coachMarksForIndex index: Int) -> CoachMark {
//        self.pointOfInterest = menuCollectionView.visibleCells()[index]
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

}

