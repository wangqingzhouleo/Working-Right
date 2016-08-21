//
//  VisaInfoTableViewController.swift
//  Working Right
//
//  Created by Qingzhou Wang on 16/08/2016.
//  Copyright © 2016 Qingzhou Wang. All rights reserved.
//

import UIKit

class VisaInfoTableViewController: UITableViewController {
    
    var visa: Visa?
    var cellDescriptors: NSMutableArray!
    var visibleCellsPerSection = [[Int]]()
    
    var titleLabel = ["About Visa", "Eligibility", "Application"]
    
    lazy var detailsLabel: [String] = [self.visa!.aboutVisa!, self.visa!.eligibility!, self.visa!.application!]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        loadCellDescriptors()
        navigationItem.title = visa!.visaName!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        // Make sure cell descriptors is not nil
        if cellDescriptors != nil
        {
            if visa!.acceptNewApply!
            {
                // If visa accept new application then display 3 sections, otherwise display 1 section
                return cellDescriptors.count
            }
            else
            {
                return 1
            }
        }
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return visibleCellsPerSection[section].count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let currentCell = getCellDescriptorForIndexPath(indexPath)
        let cellId = currentCell["cellIdentifier"] as! String
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath)
        cell.textLabel?.numberOfLines = 0
        
        // Distinguish whether the cell is title cell or details cell.
        if cellId == "InfoTitleCell"
        {
            // For title cell, display relevant title.
            cell.textLabel?.text = titleLabel[indexPath.section]
//            cell.imageView?.image = imageResize(UIImage(named: "Arrow")!, scaledToSize: CGSize(width: 30, height: 30))
            if currentCell["isExpanded"] as! Bool == false
            {
                // If cell is not expanded, display the normal arrow
                cell.imageView?.image = UIImage(named: "Arrow")
            }
            else
            {
                // If cell is expanded, display the downward arrow
                cell.imageView?.image = UIImage(named: "ArrowDown")
            }
//            cell.imageView?.transform = CGAffineTransformMakeRotation(CGFloat((tableView.indexPathForSelectedRow == indexPath) ? M_PI : 0.0))
        }
        else if cellId == "DetailsCell"
        {
            // If the cell is details cell, display the information for this section
            cell.textLabel?.text = detailsLabel[indexPath.section]
        }
        
        // Configure the cell...

        return cell
    }
    
//    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        switch section {
//        case 0:
//            return "Section 0 header, replace text here"
//        case 1:
//            return "Section 1 header, replace text here"
//        case 2:
//            return "Section 2 header, replace text here"
//        default:
//            return ""
//        }
//    }
//    
//    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
//        switch section {
//        case 0:
//            return "Section 0 footer, replace text here"
//        case 1:
//            return "Section 1 footer, replace text here"
//        case 2:
//            return "Section 2 footer, replace text here"
//        default:
//            return ""
//        }
//    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 999
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexOfTappedRow = visibleCellsPerSection[indexPath.section][indexPath.row]
        
        // Check if the cell is expandable.
        if cellDescriptors[indexPath.section][indexOfTappedRow]["isExpandable"] as! Bool == true
        {
            // Then check is the cell already expanded. If yes, then collapse the cell. If not expanded then expand the cell
            var shouldExpandAndShowSubRows = false
            if cellDescriptors[indexPath.section][indexOfTappedRow]["isExpanded"] as! Bool == false
            {
                shouldExpandAndShowSubRows = true
            }
            
            cellDescriptors[indexPath.section][indexOfTappedRow].setValue(shouldExpandAndShowSubRows, forKey: "isExpanded")
            
            cellDescriptors[indexPath.section][indexOfTappedRow + 1].setValue(shouldExpandAndShowSubRows, forKey: "isVisible")
        }
        
        // Get visible cells then reload this section
        getIndexOfVisibleCells()
        tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Automatic)
    }
    
    func loadCellDescriptors()
    {
        // Load cell descriptors from plist.
        if let path = NSBundle.mainBundle().pathForResource("CellDescriptor", ofType: "plist")
        {
            cellDescriptors = NSMutableArray(contentsOfFile: path)
            getIndexOfVisibleCells()
            tableView.reloadData()
        }
    }
    
    func getIndexOfVisibleCells()
    {
        visibleCellsPerSection.removeAll()
        
        // Search for all cells in cell descriptors, if it's visible then append to visible rows property.
        for currentSectionCells in cellDescriptors
        {
            var visibleRows = [Int]()
            
            for row in 0...((currentSectionCells as! [[String: AnyObject]]).count - 1)
            {
                if currentSectionCells[row]["isVisible"] as! Bool == true // Add filter for valid visa here
                {
                    visibleRows.append(row)
                }
            }
            
            visibleCellsPerSection.append(visibleRows)
        }
    }
    
    func getCellDescriptorForIndexPath(indexPath: NSIndexPath) -> [String: AnyObject] {
        // Get cell descriptor for a particular index path.
        let indexOfVisibleRow = visibleCellsPerSection[indexPath.section][indexPath.row]
        let cellDescriptor = (cellDescriptors[indexPath.section] as! NSArray)[indexOfVisibleRow] as! [String: AnyObject]
        return cellDescriptor
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
