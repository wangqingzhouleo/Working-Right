//
//  ResultTableViewController.swift
//  Working Rights
//
//  Created by Qingzhou Wang on 13/09/2016.
//  Copyright © 2016 Qingzhou Wang. All rights reserved.
//

import UIKit

class ResultTableViewController: UITableViewController {
    
    var dataToDisplay: [JSON] = []
    let resultOrder = ["Hourly pay rate", "Saturday", "Sunday", "Public holiday", "Age", "Job Type"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return dataToDisplay.count != 0 ? dataToDisplay.count : 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataToDisplay.count != 0 ? 6 : 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Value1, reuseIdentifier: nil)
        cell.selectionStyle = .None

        // Configure the cell...
        if dataToDisplay.count == 0
        {
            cell.textLabel?.text = "No Result Found"
        }
        else
        {
            let id = resultOrder[indexPath.row]
            cell.textLabel?.text = id
            cell.detailTextLabel?.text = dataToDisplay[indexPath.section][id].stringValue
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if dataToDisplay.count == 0
        {
            return nil
        }
        return dataToDisplay[section]["Job Title"].stringValue
//        return "\(dataToDisplay[section]["Level"].stringValue) \(dataToDisplay[section]["Job Title"].stringValue) \(dataToDisplay[section]["Grade"].stringValue)"
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.textLabel?.text = dataToDisplay[section]["Job Title"].stringValue
        headerView.textLabel?.textAlignment = .Center
        headerView.textLabel?.font = UIFont.systemFontOfSize(18)
        
//        headerView.textLabel?.text = "\(dataToDisplay[section]["Level"].stringValue) \(dataToDisplay[section]["Job Title"].stringValue) \(dataToDisplay[section]["Grade"].stringValue)"
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
