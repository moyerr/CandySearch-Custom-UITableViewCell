/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit

class MasterViewController: UITableViewController {
  
  // MARK: - Properties
  var detailViewController: DetailViewController? = nil
  var candies = [Candy]()
  var filteredCandies = [Candy]()
  let searchController = UISearchController(searchResultsController: nil)
  
  // MARK: - View Setup
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Setup the Search Controller
    searchController.searchResultsUpdater = self
    searchController.searchBar.delegate = self
    definesPresentationContext = true
    searchController.dimsBackgroundDuringPresentation = false
    
    // Setup the Scope Bar
    searchController.searchBar.scopeButtonTitles = ["All", "Chocolate", "Hard", "Other"]
    tableView.tableHeaderView = searchController.searchBar
    
    candies = [
      Candy(category:"Chocolate", name:"Chocolate Bar"),
      Candy(category:"Chocolate", name:"Chocolate Chip"),
      Candy(category:"Chocolate", name:"Dark Chocolate"),
      Candy(category:"Hard", name:"Lollipop"),
      Candy(category:"Hard", name:"Candy Cane"),
      Candy(category:"Hard", name:"Jaw Breaker"),
      Candy(category:"Other", name:"Caramel"),
      Candy(category:"Other", name:"Sour Chew"),
      Candy(category:"Other", name:"Gummi Bear")]
    
    if let splitViewController = splitViewController {
      let controllers = splitViewController.viewControllers
      detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
    }
    
    print("MasterViewController viewDidLoad\n")
  }
  
  override func viewWillAppear(animated: Bool) {
    print("MasterViewController viewWillAppear\n")
    super.viewWillAppear(animated)
  }
    
    override func viewDidAppear(animated: Bool) {
        print("MasterViewController viewDidAppear\n")
        super.viewDidAppear(animated)
    }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - Table View
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if searchController.active && searchController.searchBar.text != "" {
      return filteredCandies.count
    }
    return candies.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Candy Cell", forIndexPath: indexPath) as! CandySearchTableViewCell
    let candy: Candy
    if searchController.active && searchController.searchBar.text != "" {
      candy = filteredCandies[indexPath.row]
    } else {
      candy = candies[indexPath.row]
    }
    
    print("(\(candy.name)) cellForRowAtIndexPath")
    
    cell.setupCellForCandy(candy)
    
    return cell
  }
  
  func filterContentForSearchText(searchText: String, scope: String = "All") {
    filteredCandies = candies.filter({( candy : Candy) -> Bool in
      let categoryMatch = (scope == "All") || (candy.category == scope)
      return categoryMatch && candy.name.lowercaseString.containsString(searchText.lowercaseString)
    })
    tableView.reloadData()
  }
  
  // MARK: - Segues
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "showDetail" {
      if let indexPath = tableView.indexPathForSelectedRow {
        let candy: Candy
        if searchController.active && searchController.searchBar.text != "" {
          candy = filteredCandies[indexPath.row]
        } else {
          candy = candies[indexPath.row]
        }
        let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
        controller.detailCandy = candy
        controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
        controller.navigationItem.leftItemsSupplementBackButton = true
      }
    }
  }
  
}

extension MasterViewController: UISearchBarDelegate {
  // MARK: - UISearchBar Delegate
  func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
  }
}

extension MasterViewController: UISearchResultsUpdating {
  // MARK: - UISearchResultsUpdating Delegate
  func updateSearchResultsForSearchController(searchController: UISearchController) {
    let searchBar = searchController.searchBar
    let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
    filterContentForSearchText(searchController.searchBar.text!, scope: scope)
  }
}