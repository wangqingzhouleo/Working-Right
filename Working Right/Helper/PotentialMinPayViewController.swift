//
//  MinPayViewController.swift
//  Working Rights
//
//  Created by Qingzhou Wang on 15/09/2016.
//  Copyright © 2016 Qingzhou Wang. All rights reserved.
//

import UIKit

struct entry {
    var classification: String
    var hourlyPayRate: String
    var saturday: String
    var sunday: String
    var publicHoliday: String
    var age: String
    var jobType: String
    var level: String?
    var grade: String?
}

struct industryDataSet {
    var industry: String
    var dataSet: [entry]
}

class PotentialMinPayViewController: UIViewController, UIPageViewControllerDelegate, PickerValueChangedDelegate {
    
    let labelText: [String] = ["Industry", "Job Type", "Age Group"]
    var pickerData: [[String]] = [["Fast Food", "Hospitality", "Any"], ["Introductory", "Casino Electronic Gaming Employee", "Any"], ["Above 21", "16 - 21", "Under 16", "Any"]]
    var selectedPickerIndex: [Int] = [0,0,0]
    
    var pageController: UIPageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
    var currentPageIndex = 0
//    let modelController = MinPayModel()
    @IBOutlet weak var pageIndex: UIPageControl!
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    var allData: [industryDataSet] = []
    var dataFileNames = ["Hospitality", "Fast Food"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        pageController.delegate = self
//        pageController!.dataSource = modelController
        
        let startingController: MinPayDataController = self.viewControllerAtIndex(currentPageIndex)
        pageController.setViewControllers([startingController], direction: .Forward, animated: true, completion: nil)
//        modelController.minPayRoot = self
        
        self.addChildViewController(pageController)
        self.view.addSubview(pageController.view)
        
        self.view.addSubview(pageIndex)
        self.view.addSubview(btnBack)
        self.view.addSubview(btnSearch)
        self.view.addSubview(btnNext)
        
        showButtons()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewControllerAtIndex(index: Int) -> MinPayDataController {
        // Create a new view controller and pass suitable data.
        let dataViewController = storyboard!.instantiateViewControllerWithIdentifier("MinPayDataController") as! MinPayDataController
        dataViewController.labelText = self.labelText[index]
        dataViewController.pickerData = self.pickerData[index]
        dataViewController.selectedRow = self.selectedPickerIndex[currentPageIndex]
        dataViewController.delegate = self
        pageIndex.currentPage = index
        return dataViewController
    }
    
    func didChangePickerValue(row: Int) {
        selectedPickerIndex[currentPageIndex] = row
    }
    
    @IBAction func scrollToNext() {
        if currentPageIndex < labelText.count - 1
        {
            currentPageIndex += 1
            let nextView = viewControllerAtIndex(currentPageIndex)
            pageController.setViewControllers([nextView], direction: .Forward, animated: true, completion: { (Bool) in
                self.showButtons()
            })
        }
    }
    
    @IBAction func scrollToPrevious() {
        if currentPageIndex > 0
        {
            currentPageIndex -= 1
            let previousView = viewControllerAtIndex(currentPageIndex)
            pageController.setViewControllers([previousView], direction: .Reverse, animated: true, completion: { (Bool) in
                self.showButtons()
            })
        }
    }
    
    @IBAction func searchResult() {
        let vc = storyboard?.instantiateViewControllerWithIdentifier("SearchResultTable") as! ResultTableViewController
        navigationController?.showViewController(vc, sender: self)
        vc.navigationItem.title = "Result"
    }
    
    func showButtons()
    {
        // If current page is first page, hide back button.
        btnBack.hidden = currentPageIndex == 0
        
        // If current page is last page, hide next button.
        btnNext.hidden = currentPageIndex == labelText.count - 1
        
        // Search button only display when current page is the last.
        btnSearch.hidden = currentPageIndex != labelText.count - 1
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
