//
//  ViewController.swift
//  Working Right
//
//  Created by Qingzhou Wang on 14/08/2016.
//  Copyright © 2016 Qingzhou Wang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var menuCollectionView: UICollectionView!
    @IBOutlet weak var workingRightsImage: UIImageView!
    
    let imageName = ["visa info.png", "cases.png", "pay rates.png"]
    let cellIdentifier = ["VisaInfoCell", "CasesCell", "PayRatesCell"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set collection view's delegate and data source to this controller
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
        menuCollectionView.backgroundColor = UIColor.clearColor()
        workingRightsImage.image = UIImage(named: "main page image.png")
        
//        let width: CGFloat = UIScreen.mainScreen().bounds.width
//        let height: CGFloat = width * 736 / 880
//        workingRightsImage.image = imageResize(UIImage(named: "main page image.png")!, sizeChange: CGSize(width: width, height: height))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier[indexPath.row], forIndexPath: indexPath)
        return cell
    }
    
//    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
//        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! MenuCollectionViewCell
//        cell.btnShow.alpha = 0.2
//    }
//    
//    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
//        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! MenuCollectionViewCell
//        cell.btnShow.alpha = 1
//    }

}

