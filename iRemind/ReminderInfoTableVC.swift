//
//  ReminderInfoTableVC.swift
//  iRemind
//
//  Created by Vijay Subrahmanian on 03/06/15.
//  Copyright (c) 2015 Vijay Subrahmanian. All rights reserved.
//

import UIKit

class ReminderInfoTableVC: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    let reminderList = (UIApplication.sharedApplication().delegate as! AppDelegate).reminderList
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return 1 // First section contains Add Reminder Cell.
        }
        
        return reminderList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("AddReminder") as! UITableViewCell
            cell.textLabel?.text = "Create New Reminder"
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ReminderInfo") as! UITableViewCell
        let reminderInfo = self.reminderList[indexPath.row] as ReminderInfoModel
        cell.textLabel?.text = reminderInfo.name
        let dateFormat = NSDateFormatter()
        dateFormat.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormat.timeStyle = NSDateFormatterStyle.ShortStyle
        cell.detailTextLabel?.text = dateFormat.stringFromDate(reminderInfo.time)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            return "New Reminder"
        }
        return "Reminders"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

