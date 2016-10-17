//
//  WorkRightsTableViewController.swift
//  Working Rights
//
//  Created by Qingzhou Wang on 27/08/2016.
//  Copyright © 2016 Qingzhou Wang. All rights reserved.
//

import UIKit

class WorkRightsTableViewController: UITableViewController {
    
    var workRightsList = [workRights]()
    var workConditionList = [workCondition]()
    
    var expandedRow: NSIndexPath?
    var lastExpanded: NSIndexPath?
    
    struct workRights {
        var workType: String
        var workRights: String
        var breaks: String
    }
    
    struct workCondition {
        var visaType: String
        var condition: String
    }
    
    let sectionTitle = ["Working Rights", "Working Conditions"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        loadData()
        tableView.contentInset.bottom = 40
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0
        {
            return workRightsList.count
        }
        else
        {
            return workConditionList.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0
        {
            let cell = UITableViewCell()
            
            // Configure the cell...
            
            cell.textLabel?.text = workRightsList[indexPath.row].workType
            cell.textLabel?.numberOfLines = 1
            cell.selectionStyle = .None
            
            if expandedRow == indexPath
            {
                let text = "\(workRightsList[indexPath.row].workType)\n\nWorking Rights:\(workRightsList[indexPath.row].workRights)\n\nBreaks:\(workRightsList[indexPath.row].breaks)"
                cell.textLabel?.text = text
                cell.textLabel?.numberOfLines = 0
            }
            
            return cell
        }
        else
        {
            let cell = UITableViewCell()
            
            // Configure the cell...
            
            cell.textLabel?.text = workConditionList[indexPath.row].visaType
            cell.textLabel?.numberOfLines = 1
            cell.selectionStyle = .None
            
            if expandedRow == indexPath
            {
                let text = "\(workConditionList[indexPath.row].visaType)\n\nWork Condition:\n\(workConditionList[indexPath.row].condition)"
                cell.textLabel?.text = text
                cell.textLabel?.numberOfLines = 0
            }
            
            return cell
        }
    }
    
    func loadData()
    {
        if let path = NSBundle.mainBundle().pathForResource("Work Rights", ofType: "json")
        {
            do
            {
                let jsonData = try NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe)
                let result = try NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableContainers) as! [NSDictionary]
                
                for item in result
                {
                    let type = item["workType"] as! String
                    let rights = item["workRights"] as! String
                    let breaks = item["breaks"] as! String
                    
                    workRightsList.append(workRights(workType: type, workRights: rights, breaks: breaks))
                }
            }
            catch
            {
                print("Error when reading Work Rights json file")
            }
        }
        
        if let path = NSBundle.mainBundle().pathForResource("Work Condition", ofType: "json")
        {
            do
            {
                // Then read data from file
                let jsonData = try NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe)
                let result = try NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableContainers) as! [NSDictionary]
                
                for item in result
                {
                    let type = item["visaType"] as! String
                    let condition = item["workCondition"] as! String
                    
                    workConditionList.append(workCondition(visaType: type, condition: condition))
                }
            }
            catch
            {
                print("Error when reading Work Condition json file")
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        lastExpanded = expandedRow
        if expandedRow != indexPath
        {
            expandedRow = indexPath
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            if lastExpanded != nil
            {
                tableView.reloadRowsAtIndexPaths([lastExpanded!], withRowAnimation: .Automatic)
            }
        }
        else
        {
            expandedRow = nil
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 999
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        if visibleRows.count > 0
//        {
//            if visibleRows.contains(indexPath)
//            {
//                return UITableViewAutomaticDimension
//            }
//        }
        
        // For selected row, return dynamic height.
        if expandedRow == indexPath
        {
            return UITableViewAutomaticDimension
        }
        return 44
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.textLabel?.text = sectionTitle[section]
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
