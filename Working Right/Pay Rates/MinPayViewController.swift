//
//  MinPayViewController.swift
//  Working Rights
//
//  Created by Qingzhou Wang on 13/09/2016.
//  Copyright © 2016 Qingzhou Wang. All rights reserved.
//

import UIKit

class MinPayViewController: UITableViewController, UpdateFilterDelegate {
    
//    struct industryData {
//        var industry: String
//        var list: [JSON]
//    }
    
    @IBOutlet weak var searchButton: UIButton!
    
    let files = [ "Cleaning Services", "Fast Food", "Hospitality"]
    let cellText = ["Industry", "Job Title", "Job Type", "Age"]
    let detailLabelText = "Select"
    
    var allData: [String: [JSON]] = [:]
    var filter = [String?]()
//    var searchButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.checkValidation), name: nil, object: nil)
        
        let leftButton = UIBarButtonItem()
        leftButton.title = "Back"
        navigationItem.backBarButtonItem = leftButton
        
        filter = [String?](count: cellText.count, repeatedValue: nil)
        
        dispatch_async(dispatch_get_main_queue()) {
            self.loadData()
        }
        
        searchButton.addTarget(self, action: #selector(self.searchResult), forControlEvents: .TouchUpInside)
        
        tableView.contentInset.top = 15
        tableView.sectionHeaderHeight = 5
//        tableView.sectionFooterHeight = 5
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        if let index = tableView.indexPathForSelectedRow
        {
            tableView.deselectRowAtIndexPath(index, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return filter[0] == nil ? 1 : filter.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FilterCell", forIndexPath: indexPath)
        cell.textLabel?.text = cellText[indexPath.section]
        cell.detailTextLabel?.text = filter[indexPath.section] ?? detailLabelText
        cell.imageView?.image = UIImage(named: "cell image - \(cellText[indexPath.section])")
        
        return cell
    }
    
    func searchResult()
    {
        let vc = ResultTableViewController(style: .Grouped)
        
        var result: [JSON] = []
        for value in allData.values
        {
            if filter[0] == nil
            {
                result += value
            }
            else
            {
                result = allData[filter[0]!]!
            }
        }
        
        if filter[1] != nil
        {
            for item in result
            {
                if item["Job Title"].stringValue != filter[1]!
                {
                    result.removeAtIndex(result.indexOf(item)!)
                }
            }
        }
        
        if filter[2] != nil
        {
            for item in result
            {
                if item["Job Type"].stringValue != filter[2]!
                {
                    result.removeAtIndex(result.indexOf(item)!)
                }
            }
        }
        
        if filter[3] != nil
        {
            for item in result
            {
                if item["Age"].stringValue != filter[3]!
                {
                    result.removeAtIndex(result.indexOf(item)!)
                }
            }
        }
        
        vc.dataToDisplay = result
        
        navigationController?.showViewController(vc, sender: self)
        vc.navigationItem.title = "Result"
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Initialize filter table
        var set = NSSet()
        
        if filter[0] != nil && indexPath.section != 0
        {
            var tmp: [String] = []
            for item in allData[filter[0]!]!
            {
                tmp.append(item[cellText[indexPath.section]].stringValue)
            }
            set = NSSet(array: tmp)
        }
        if indexPath.section == 0
        {
            set = NSSet(array: files)
        }
        
        let filterTable = FilterTableViewController()
        filterTable.filterContent = set.allObjects as! [String]
        filterTable.selectedFilterIndex = indexPath
        filterTable.delegate = self
        filterTable.filterContent.sortInPlace()
        if indexPath.section == 3
        {
            filterTable.filterContent.sortInPlace({ (s1, s2) -> Bool in
                if s1.lowercaseString.containsString("under 16")
                {
                    return s1 > s2
                }
                else
                {
                    return s1 < s2
                }
            })
        }
        filterTable.navigationTitle = cellText[indexPath.section]
        
        showViewController(filterTable, sender: self)
    }
    
    func loadData()
    {
        for industry in files
        {
            let path = NSBundle.mainBundle().pathForResource(industry, ofType: "json")!
            let data = NSData(contentsOfFile: path)!
            let json = JSON(data: data)
            
            var listForIndustry = [JSON]()
            for item in json.arrayValue
            {
                var list = [String: String]()
                list.updateValue(item["Hourly pay rate"].stringValue, forKey: "Hourly pay rate")
                list.updateValue(item["Saturday"].stringValue, forKey: "Saturday")
                list.updateValue(item["Sunday"].stringValue, forKey: "Sunday")
                list.updateValue(item["Public holiday"].stringValue, forKey: "Public holiday")
                list.updateValue(item["Age"].stringValue, forKey: "Age")
                list.updateValue(item["Job Type"].stringValue, forKey: "Job Type")
                list.updateValue(item["Level"].stringValue, forKey: "Level")
                list.updateValue(item["Grade"].stringValue, forKey: "Grade")
                list.updateValue(item["Job Title"].stringValue, forKey: "Job Title")
                listForIndustry.append(JSON(list))
            }
            
//            allData.append(industryData(industry: industry, list: listForIndustry))
            allData.updateValue(listForIndustry, forKey: industry)
        }
    }
    
    func checkValidation()
    {
        var enabled = true
        for item in filter
        {
            if item == nil
            {
                enabled = false
                break
            }
        }
        searchButton.enabled = enabled
        searchButton.hidden = filter[0] == nil
        tableView.tableFooterView?.backgroundColor = enabled ? UIColor(red: 0.8471, green: 0, blue: 0.1529, alpha: 1) : UIColor.lightGrayColor()
    }
    
    func updateFilter(selectedItem: String, atIndex indexPath: NSIndexPath) {
        if indexPath.section == 0 && filter[0] != selectedItem
        {
//            let item: String? = selectedItem != "Any" ? selectedItem : nil
//            filter = [item, nil, nil, nil]
            
            filter = [selectedItem, nil, nil, nil]
        }
        else
        {
//            filter[indexPath.section] = selectedItem != "Any" ? selectedItem : nil
            
            filter[indexPath.section] = selectedItem
        }
        tableView.reloadData()
    }
    
//    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 5
//    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 3
        {
            return 30
        }
        else
        {
            return 5
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
