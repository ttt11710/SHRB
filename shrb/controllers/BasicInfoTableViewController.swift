//
//  BasicInfoTableViewController.swift
//  shrb
//
//  Created by PayBay on 15/6/23.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

import UIKit

class BasicInfoTableViewController: UITableViewController {
    
    
    let leftdata = ["账号","密码","Email"]
    let rightdata = ["18267856123","123456","273269077@qq.com"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 4
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            tableView.registerNib(UINib(nibName: "MeImageTableViewCell", bundle: nil), forCellReuseIdentifier: "MeImageTableViewCellId")
            
            let cell = tableView.dequeueReusableCellWithIdentifier("MeImageTableViewCellId", forIndexPath: indexPath) as! MeImageTableViewCell
            
            cell.selectionStyle = UITableViewCellSelectionStyle(rawValue: 0)!
            cell.meImageView.image = UIImage(named: "官方头像")
            return cell
        }
        else {
            tableView.registerNib(UINib(nibName: "RightDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "RightDetailTableViewCellId")
            
            let cell = tableView.dequeueReusableCellWithIdentifier("RightDetailTableViewCellId", forIndexPath: indexPath) as! RightDetailTableViewCell
            
            cell.selectionStyle = UITableViewCellSelectionStyle(rawValue: 0)!
            cell.leftLabel.text = leftdata[indexPath.row-1]
            cell.rightDetailLabel.text = rightdata[indexPath.row-1]
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.row == 0 ? 100 : 60
    }
}
