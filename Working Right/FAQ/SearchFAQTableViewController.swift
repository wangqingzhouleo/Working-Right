//
//  SearchFAQTableViewController.swift
//  Working Rights
//
//  Created by Qingzhou Wang on 22/09/2016.
//  Copyright © 2016 Qingzhou Wang. All rights reserved.
//

import UIKit

class SearchFAQTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var searchResult: [Question] = []
    var delegate: FAQTableViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tableView.registerNib(UINib(nibName: "SearchFAQCell", bundle: nil), forCellReuseIdentifier: "SearchFAQCell")
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
        return searchResult.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchFAQCell", forIndexPath: indexPath) as! SearchFAQCell

        // Configure the cell...
        cell.selectionStyle = .None
        let question = searchResult[indexPath.row]
        cell.titleLabel.text = question.title
        cell.descLabel.text = question.desc

        return cell
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let text = searchController.searchBar.text
        {
            searchResult.removeAll()
            
//            for item in allQuestions
//            {
//                if item.title.lowercaseString.score(text.lowercaseString, fuzziness: 1.0) > 0.05 || item.desc.lowercaseString.score(text.lowercaseString, fuzziness: 1.0) > 0.05
//                {
//                    searchResult.append(item)
//                }
//            }
            
            searchResult = allQuestions.filter({ (question) -> Bool in
                let searchTitle = (question.title as NSString).rangeOfString(text, options: .CaseInsensitiveSearch)
                let searchDesc = (question.desc as NSString).rangeOfString(text, options: .CaseInsensitiveSearch)
                return searchTitle.location != NSNotFound || searchDesc.location != NSNotFound
            })
            tableView.reloadData()
        }
    }
    
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        delegate.searchController.searchBar.endEditing(true)
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 9999
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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
