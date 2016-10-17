//
//  CompaniesTableViewController.swift
//  Working Right
//
//  Created by Qingzhou Wang on 15/08/2016.
//  Copyright © 2016 Qingzhou Wang. All rights reserved.
//

import UIKit

class CompaniesTableViewController: UITableViewController, UISearchBarDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var allCompanies = [Company]()
    
//    var allCompany = [String: [Company]]()
    
//    struct company {
//        var key: String!
//        var companyList: [Company]!
//    }
    
//    var allCompanies = [company]()
    
    // Stores titles for all sections
//    var sectionTitle = [String]()
    
//    lazy var visibleKeys: [String] = self.sectionTitle
    lazy var visibleCompanies: [Company] = self.allCompanies

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
//        
//        for key in sectionTitle
//        {
//            allCompany.append(company(key: key, companyList: [Company]()))
//        }
        loadData()
        
        searchBar.delegate = self
        searchBar.placeholder = "Search Company"
        
        let button = UIBarButtonItem()
        button.title = "Back"
        navigationItem.backBarButtonItem = button
        
        let sortButton = UIBarButtonItem(title: "Sort", style: .Plain, target: self, action: #selector(self.showSortOption(_:)))
        button.tintColor = UIColor.whiteColor()
        navigationItem.rightBarButtonItem = sortButton
        
//        let footerView = storyboard?.instantiateViewControllerWithIdentifier("CaseMainViewController") as! CaseMainViewController
//        tableView.tableFooterView = footerView.view
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        if let index = tableView.indexPathForSelectedRow
        {
            tableView.deselectRowAtIndexPath(index, animated: false)
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        let key = visibleKeys[section]
        return visibleCompanies.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CompanyCell", forIndexPath: indexPath)
        
        // Get key from visible keys then display company name and date in the cell
//        let key = visibleKeys[indexPath.section]
//        cell.textLabel?.text = (visibleCompanies[sectionTitle.indexOf(key)!].companyList[indexPath.row] as Company).companyName
//        cell.detailTextLabel?.text = (visibleCompanies[sectionTitle.indexOf(key)!].companyList[indexPath.row] as Company).caseNumber
        // Configure the cell...
        cell.textLabel?.text = visibleCompanies[indexPath.row].companyName
        cell.detailTextLabel?.text = visibleCompanies[indexPath.row].caseNumber

        return cell
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        // Dismiss keyboard when search button is clicked.
        self.searchBar.endEditing(true)
    }
    
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        // Dismiss keyboard when table is scrolled.
        self.searchBar.endEditing(true)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Cancel selection for the cell.
        let vc = storyboard?.instantiateViewControllerWithIdentifier("CaseDetailsViewController") as! CaseDetailsViewController
        vc.company = visibleCompanies[indexPath.row]
        showViewController(vc, sender: self)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        // Filter search result. When nothing in the search bar, just display all records.
        if searchText.characters.count == 0
        {
//            visibleCompanies = []
            visibleCompanies = allCompanies
//            for value in visibleCompanies
//            {
//                visibleKeys.append(value.key)
//            }
        }
        else
        {
            // Search record from all companies, then filter the result and stored into visible companies.
//            for value in allCompanies
//            {
//                if value.companyList.count != 0
//                {
//                    visibleCompanies[sectionTitle.indexOf(value.key)!].companyList = value.companyList.filter({ (text) -> Bool in
//                        let temp: Company = text
//                        let range = (temp.companyName! as NSString).rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
//                        return range.location != NSNotFound
//                    })
//                }
//            }
            
            visibleCompanies = allCompanies.filter({ (company) -> Bool in
                let tmp: Company = company
                let range = (tmp.companyName! as NSString).rangeOfString(searchText, options: .CaseInsensitiveSearch)
                return range.location != NSNotFound
            })
            
//            visibleCompanies.sortInPlace({
//                ($0.companyName! as NSString).substringToIndex(1) < ($1.companyName! as NSString).substringToIndex(1)
//            })
            
            // Then refresh all visible keys list.
//            visibleKeys.removeAll()
//            for value in visibleCompanies
//            {
//                if value.companyList.count != 0
//                {
//                    visibleKeys.append(value.key)
//                }
//            }
        }
        
        self.tableView.reloadData()
    }
    
    func loadData()
    {
        // Load data from json file stored in local disk, this will be improved in iteration 2.
        if let path = NSBundle.mainBundle().pathForResource("2013 Data", ofType: "json")
        {
            do
            {
                let jsonData = try NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe)
                let companies = try NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableContainers) as! NSArray
                
                // Read all items from json file then assign to new company.
                for item in (companies as! [NSDictionary])
                {
                    let companyName = item["companyName"] as! String
                    let caseNumber = item["caseNumber"] as! String
                    let caseDate = item["date"] as! String
                    let link = item["hyperLink"] as! String
                    
                    allCompanies.append(Company(companyName: companyName, caseNumber: caseNumber, caseDate: caseDate, link: link))
                    
//                    let newCompany = Company(companyName: companyName, caseNumber: caseNumber, caseDate: caseDate, link: link)
//                    var key = (companyName as NSString).substringToIndex(1).uppercaseString
//                    
//                    // If the key is not alphabetic, set the key as "#"
//                    if !isAlpha(key)
//                    {
//                        key = "#"
//                    }
//                    
//                    // if section title list does not contains the key, add a new one in the list.
//                    if !sectionTitle.contains(key)
//                    {
//                        sectionTitle.append(key)
//                        allCompanies.append(company(key: key, companyList: [Company]()))
//                    }
//                    
//                    // Fetch the existing list and append a new company.
//                    allCompanies[sectionTitle.indexOf(key)!].companyList.append(newCompany)
                }
                
//                allCompanies.sortInPlace({
//                    ($0.companyName! as NSString).substringToIndex(1) < ($1.companyName! as NSString).substringToIndex(1)
//                })
                allCompanies.sortInPlace { (c1, c2) -> Bool in
                    return c1.companyName < c2.companyName
                }
                
                // Sort all companies and section title by alphabetical order
//                allCompanies.sortInPlace({$0.key < $1.key})
//                sectionTitle.sortInPlace()
                
                // If the first company's name doesn't start with "A", then move to the end of the list.
//                if allCompanies[0].key != "A"
//                {
//                    allCompanies.append(allCompanies.removeFirst())
//                    sectionTitle.append(sectionTitle.removeFirst())
//                }
            }
            catch
            {
                print("Error when load data")
            }
        }
    }
    
//    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
//        return sectionTitle
//    }
//    
//    func isAlpha(string: String) -> Bool
//    {
//        // Check is the string within the range.
//        return string.rangeOfString("^[a-zA-Z]+$", options: .RegularExpressionSearch) != nil
//    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 999
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func sortTable(sortBy: String)
    {
        switch sortBy {
        case "Alphabectical":
            allCompanies.sortInPlace { (c1, c2) -> Bool in
                return c1.companyName < c2.companyName
            }
        case "Case Number":
            allCompanies.sortInPlace { (c1, c2) -> Bool in
                return c1.caseNumber < c2.caseNumber
            }
        case "Date":
            allCompanies.sortInPlace { (c1, c2) -> Bool in
                return c1.caseDate < c2.caseDate
            }
        default:
            break
        }
        visibleCompanies = allCompanies
        tableView.reloadData()
    }
    
    func showSortOption(sender: UIBarButtonItem) {
        // Present a popover to let user add category.
        let popoverVC = storyboard?.instantiateViewControllerWithIdentifier("SortCompanyTableViewController") as! SortCompanyTableViewController
        popoverVC.modalPresentationStyle = .Popover
        if let popoverController = popoverVC.popoverPresentationController {
            popoverController.barButtonItem = sender
            popoverController.sourceRect = CGRect(x: 0, y: 0, width: 85, height: 30)
            popoverController.permittedArrowDirections = .Any
            popoverController.delegate = self
        }
        presentViewController(popoverVC, animated: true, completion: nil)
        popoverVC.delegate = self
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        // Force iPhone to display popover rather than push a new view.
        return .None
    }
    
//    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return visibleKeys[section]
//    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "ViewCaseDetailsSegue"
//        {
//            // When clicking on a cell, send the selected company to next view controller then display details.
//            let vc = segue.destinationViewController as! CaseDetailsViewController
//            let indexPath = tableView.indexPathForSelectedRow!
//            let key = visibleKeys[indexPath.section]
//            vc.company = visibleCompanies[sectionTitle.indexOf(key)!].companyList[indexPath.row]
//            vc.company = visibleCompanies
//        }
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
