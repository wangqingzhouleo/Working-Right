//
//  FilterTableViewController.swift
//  Working Rights
//
//  Created by Qingzhou Wang on 15/09/2016.
//  Copyright © 2016 Qingzhou Wang. All rights reserved.
//

import UIKit

protocol UpdateFilterDelegate {
    func updateFilter(selectedItem: String, atIndex indexPath: NSIndexPath)
}

class FilterTableViewController: UITableViewController {
    
    var filterContent: [String] = []
    var selectedFilterIndex: NSIndexPath!
    var delegate: MinPayViewController!
    var navigationTitle: String!
    
    var allDescriptions: [String: String] = [:]
    
    var searchController: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        navigationItem.title = navigationTitle
        
        dispatch_async(dispatch_get_main_queue()) {
            if self.selectedFilterIndex.section == 1
            {
                self.setSearchController()
                self.loadDescription()
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filterContent.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if selectedFilterIndex.section == 1
        {
            cell.accessoryType = .DetailButton
        }

        // Configure the cell...
        cell.textLabel?.text = filterContent[indexPath.row]

        return cell
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        let jobTitle = filterContent[indexPath.row]
        
        let alert = UIAlertController(title: jobTitle, message: allDescriptions[jobTitle], preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        navigationController?.popViewControllerAnimated(true)
        delegate.updateFilter(filterContent[indexPath.row], atIndex: selectedFilterIndex)
    }
    
    func loadDescription()
    {
        if let industry = delegate.filter[0]
        {
            let file = "\(industry) Job Description"
            let path = NSBundle.mainBundle().pathForResource(file, ofType: "json")!
            let data = NSData(contentsOfFile: path)!
            let json = JSON(data: data)
            
            for item in json.arrayValue
            {
                allDescriptions.updateValue(item["Description"].stringValue, forKey: item["Job Title"].stringValue)
            }
        }
    }
    
    func setSearchController()
    {
        let resultTable = SearchTableViewController(style: .Plain)
        searchController = UISearchController(searchResultsController: resultTable)
        searchController.searchResultsUpdater = resultTable
        resultTable.delegate = self
        searchController.searchBar.tintColor = UIColor(red: 0.8471, green: 0, blue: 0.1529, alpha: 1)
        
        let searchBar = searchController.searchBar
        tableView.tableHeaderView = searchBar
        searchBar.placeholder = "Search \(navigationTitle)"
        searchController.dimsBackgroundDuringPresentation = true
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
