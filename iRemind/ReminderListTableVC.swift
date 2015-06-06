//
//  ReminderListTableVC.swift
//  iRemind
//
//  Created by Vijay Subrahmanian on 03/06/15.
//  Copyright (c) 2015 Vijay Subrahmanian. All rights reserved.
//

import UIKit

class ReminderListTableVC: UITableViewController, UITableViewDataSource, UITableViewDelegate {

    var reminderList = (UIApplication.sharedApplication().delegate as! AppDelegate).reminderList
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.reminderList = (UIApplication.sharedApplication().delegate as! AppDelegate).reminderList
        self.tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if count(self.reminderList) > 0 {
            return 2
        }
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 0 {
            return 1 // First section contains Add Reminder Cell.
        }
        return self.reminderList.count
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
        cell.detailTextLabel?.text = dateFormat.stringFromDate(reminderInfo.time!)

        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            return "New Reminder"
        }
        return "Reminders"
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var aReminderInfo: ReminderInfoModel
        
        let reminderInfoVC = self.storyboard!.instantiateViewControllerWithIdentifier("ReminderInfoVCID") as! ReminderInfoVC

        if indexPath.section == 0 {
            reminderInfoVC.reminderInfo = ReminderInfoModel()
        } else {
            reminderInfoVC.reminderInfo = self.reminderList[indexPath.row]
            reminderInfoVC.index = indexPath.row
        }
        self.navigationController?.pushViewController(reminderInfoVC, animated: true)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

