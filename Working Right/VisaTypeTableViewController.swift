//
//  VisaTypeTableViewController.swift
//  Working Right
//
//  Created by Qingzhou Wang on 18/08/2016.
//  Copyright © 2016 Qingzhou Wang. All rights reserved.
//

import UIKit

class VisaTypeTableViewController: UITableViewController {
    
    var visaList = [Visa]()
    var visaType: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        loadVisaInfo()
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
        return visaList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("VisaTypeCell", forIndexPath: indexPath)

        // Configure the cell...
        
        // The cell will display visa name and its subclass number.
        cell.textLabel?.text = "\(visaList[indexPath.row].visaName!) (subclass \(visaList[indexPath.row].visaNumber!))"
        cell.textLabel?.numberOfLines = 0

        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // Set height to automatic
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 999
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Cancel the gray background when select a particular row.
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func loadVisaInfo()
    {
        // Load json file from local disk, this will be improved in iteration 2, and load data from server.
        if let path = NSBundle.mainBundle().pathForResource("visaInfo", ofType: "json")
        {
            do
            {
                // Try to fetch json data from file and convert to NSArray
                let jsonData = try NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe)
                let result = try NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableContainers) as! NSArray
                
                for item in (result as! [NSDictionary])
                {
                    // Read each line and fetch data, then assign to a new visa
                    if item["type"] as! String == visaType
                    {
                        let visaNumber = item["visaNumber"] as! Int
                        let visaName = item["visaName"] as! String
                        let aboutVisa = item["aboutVisa"] as! String
                        let eligibility = item["eligibility"] as! String
                        let application = item["application"] as! String
                        let acceptNewApply = item["acceptNewApply"] as! String == "YES"
                        
                        // Append the new visa to list.
                        visaList.append(Visa(visaNumber: visaNumber, visaName: visaName, aboutVisa: aboutVisa, eligibility: eligibility, application: application, acceptNewApply: acceptNewApply))
                    }
                }
            }
            catch
            {
                print("Read data fails")
            }
        }
        
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DisplayVisaInfoSegue"
        {
            // Get selected visa and display information in next controller
            let vc = segue.destinationViewController as! VisaInfoTableViewController
            vc.visa = visaList[tableView.indexPathForSelectedRow!.row]
        }
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
