//
//  CollectTableViewController.swift
//  shrb
//
//  Created by PayBay on 15/6/24.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

import UIKit

class CollectTableViewController: UITableViewController {
    
    
    let data = ["热点活动消息：开机费均按积分发热热给我发生个非官方分为天然天热舞贵公司发热体同仁堂个广告和他人很好地方他如何更好的官方换热管他人固定法规和规范化个","热点活动消息：开机费均按积分发热热给我发生个非官方分为天然天热舞贵公司发热体同仁堂个广告和他人很好地方他如何更好的官方换热管他人固定法规和规范化个我发生个非官方分为天然天热舞贵公司发热体同仁堂个广告和他人很好地方他如何更好的官方换热管他人热体同仁堂个广告和他固定法规和规范化个","热点活动消息：开机热体同仁堂个广告和他费均按积分发热热给我发生个非官方分为天然天热舞贵公司发热体同仁堂个广告和他人很好地方他如何更好的官方换热管他人固定法规和规范化个"]
    
    let cellIdentifier = "orderListTableViewCellId"
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeigth = UIScreen.mainScreen().bounds.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1)

    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return data.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        tableView.registerNib(UINib(nibName: "OrderListTableViewCell", bundle: nil), forCellReuseIdentifier: "orderListTableViewCellId")
        
        let cell = tableView.dequeueReusableCellWithIdentifier("orderListTableViewCellId", forIndexPath: indexPath) as! OrderListTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle(rawValue: 0)!
        cell.orderImageView.image = UIImage(named: "辛巴克.jpg")
        cell.orderListInfoLabel.text = data[indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let label = UILabel(frame: CGRectMake(0, 12,screenWidth - 110 , CGFloat.max))
        label.numberOfLines = 1000
        label.lineBreakMode = NSLineBreakMode.ByCharWrapping
        label.font = UIFont.systemFontOfSize(14)
        
        label.text = data[indexPath.row]
        
        label.sizeToFit()
        if label.frame.height > 80 {
            return label.frame.height + 110-80+20
        }
        return 110
    }
}
