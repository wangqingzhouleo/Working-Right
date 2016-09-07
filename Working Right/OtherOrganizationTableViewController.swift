//
//  OtherOrganizationTableViewController.swift
//  Working Rights
//
//  Created by Qingzhou Wang on 29/08/2016.
//  Copyright © 2016 Qingzhou Wang. All rights reserved.
//

import UIKit

class OtherOrganizationTableViewController: UITableViewController {
    
    struct organization {
        var name: String
        var about: String
        var field: String
    }
    
    var organizationList = [organization]()
    
    var expandedRow: NSIndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        loadData()
        
        tableView.contentInset.bottom = 50
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return organizationList.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("OtherOrganizationCell", forIndexPath: indexPath)

        // Configure the cell...
        cell.textLabel?.text = organizationList[indexPath.section].name
        cell.textLabel?.numberOfLines = 1
        cell.accessoryType = .None
        
        // If the cell is expanded, display detail information inside that cell.
        if indexPath == expandedRow
        {
            let text = "\(organizationList[indexPath.section].name)\n\nAbout Information:\n\(organizationList[indexPath.section].about)\n\nField:\n\(organizationList[indexPath.section].field)"
            cell.textLabel?.text = text
            cell.textLabel?.numberOfLines = 0
            cell.accessoryType = .DisclosureIndicator
        }

        return cell
    }
    
    func loadData()
    {
        // Load data from file then convert to object and store into array.
        if let path = NSBundle.mainBundle().pathForResource("Legal Service", ofType: "json")
        {
            do
            {
                let jsonData = try NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe)
                let result = try NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableContainers) as! [NSDictionary]
                
                for item in result
                {
                    let field = item["field"] as! String
                    if field != "Legal Aid Service"
                    {
                        let name = item["name"] as! String
                        let about = item["description"] as! String
                        
                        organizationList.append(organization(name: name, about: about, field: field))
                    }
                }
            }
            catch
            {
                print("Error when reading Other Organizations json")
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Set expanded row to selected indexpath if selected row is not expanded. If tapped on an expanded row, then close the row.
        if expandedRow != indexPath
        {
            expandedRow = indexPath
        }
        tableView.reloadSections(NSIndexSet(indexesInRange: NSRange(location: 0, length: tableView.numberOfSections)), withRowAnimation: .Automatic)
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
        
        if expandedRow == indexPath
        {
            return UITableViewAutomaticDimension
        }
        return 44
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "showOtherOrgSegue"
        {
            if tableView.indexPathForSelectedRow == expandedRow && expandedRow != nil
            {
                return true
            }
            else
            {
                return false
            }
        }
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showOtherOrgSegue" && expandedRow != nil
        {
            let vc = segue.destinationViewController as! LegalServiceViewController
            let org = organizationList[expandedRow!.section]
            vc.field = org.field
        }
    }
    
    // Display section header in This Format, NOT THIS FORMAT.
//    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return organizationList[section].name
//    }
//    
//    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        let header = view as! UITableViewHeaderFooterView
//        header.textLabel?.text = organizationList[section].name
//    }

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
