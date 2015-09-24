//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Daniel Trostli on 9/23/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String:AnyObject])
}

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    weak var delegate: FiltersViewControllerDelegate?
    
    var categories: [[String: String]]!
    var switchStates =  [Int:Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        categories = yelpCategories()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onSearchButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        var filters = [String : AnyObject]()
        
        var selectedCategories = [String]()
        for (row, isSelected) in switchStates {
            if isSelected {
                selectedCategories.append(categories[row]["code"]!)
            }
        }
        if selectedCategories.count > 0 {
            filters["categories"] = selectedCategories
        }
        
        delegate?.filtersViewController?(self, didUpdateFilters: filters)
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
        
        cell.delegate = self
        cell.switchLabel.text = categories[indexPath.row]["name"]
        
        cell.onSwitch.on = switchStates[indexPath.row] ?? false
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPathForCell(switchCell)!
        
        switchStates[indexPath.row] = value
    }
    
    func yelpCategories() -> [[String: String]] {
        return [["name" : "Afghan", "code" : "afghani"],
            ["name" : "African", "code" : "african"],
            ["name" : "American, New", "code" : "newamerican"],
            ["name" : "American, Traditional", "code" : "tradamerican"],
            ["name" : "Arabian", "code" : "arabian"],
            ["name" : "Argentine", "code" : "argentine"],
            ["name" : "Armenian", "code" : "armenian"],
            ["name" : "Asian Fusion", "code" : "asianfusion"],
            ["name" : "Asturian", "code" : "asturian"],
            ["name" : "Australian", "code" : "australian"],
            ["name" : "Austring", "code" : "austrian"]
        ]
    }
}
