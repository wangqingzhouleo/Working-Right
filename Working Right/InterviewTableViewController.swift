//
//  InterviewTableViewController.swift
//  Working Rights
//
//  Created by Qingzhou Wang on 7/09/2016.
//  Copyright © 2016 Qingzhou Wang. All rights reserved.
//

import UIKit

class InterviewTableViewController: UITableViewController {
    
    var interviewList = [interviewTip]()
    var expandedRow: NSIndexPath?
    
    struct interviewTip {
        var name: String
        var desc: String
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        loadDate()
        tableView.contentInset.bottom = 50
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return interviewList.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    func loadDate()
    {
        if let path = NSBundle.mainBundle().pathForResource("Interview", ofType: "json")
        {
            do
            {
                let jsonData = try NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe)
                let result = try NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableContainers) as! [NSDictionary]
                
                for item in result
                {
                    let name = item["name"] as! String
                    let desc = item["desc"] as! String
                    
                    interviewList.append(interviewTip(name: name, desc: desc))
                }
            }
            catch let error
            {
                print(error)
            }
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("InterviewCell", forIndexPath: indexPath)

        // Configure the cell...
        cell.textLabel?.text = interviewList[indexPath.section].name
        cell.textLabel?.numberOfLines = 1
        
        if expandedRow == indexPath
        {
            let text = "\(interviewList[indexPath.section].name)\n\n\(interviewList[indexPath.section].desc)"
            cell.textLabel?.text = text
            cell.textLabel?.numberOfLines = 0
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Set expanded row to selected indexpath if selected row is not expanded. If tapped on an expanded row, then close the row.
        if expandedRow != indexPath
        {
            expandedRow = indexPath
        }
        else
        {
            expandedRow = nil
        }
        tableView.reloadSections(NSIndexSet(indexesInRange: NSRange(location: 0, length: tableView.numberOfSections)), withRowAnimation: .Automatic)
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 999
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if expandedRow == indexPath
        {
            return UITableViewAutomaticDimension
        }
        return 44
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
