//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Daniel Trostli on 4/23/15.
//  Copyright (c) 2015 Daniel Trostli. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, FiltersViewControllerDelegate {

    var businesses: [Business]!
    var query = "Food"
    var filters = [String: AnyObject]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchBar = UISearchBar()
        searchBar.delegate = self

        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
//        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
//            self.businesses = businesses
//            self.tableView.reloadData()
//            for business in businesses {
//                print(business.name!)
//                print(business.address!)
//            }
//        }
        
        searchBusinesses("Restaurants", filters: filters)
    }
    
    func searchBusinesses(query: String, filters: [String: AnyObject]?) {
        let deals = filters!["deals"] as? Bool
        let sort = filters!["sort"] as? Int
        let radius = filters!["radius"] as? Int
        let categories = filters!["categories"] as? [String]
        
        var yelpSort: YelpSortMode?
        
        if sort != nil {
            yelpSort = YelpSortMode(rawValue: sort!)!
        }
       
        Business.searchWithTerm(query, sort: yelpSort, categories: categories, deals: deals, radius: radius) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        }
    }
    
    // MARK: - Search Bar
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBusinesses(searchBar.text!, filters: filters)
        searchBar.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            return businesses!.count
        } else {
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        
        cell.business = businesses[indexPath.row]
        return cell
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationController = segue.destinationViewController as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        
        filtersViewController.delegate = self
    }
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        
        var categories = filters["categories"] as? [String]
        
        searchBusinesses(query, filters: filters)
    }


}
