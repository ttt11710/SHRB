//
//  UserCenterTableViewController.swift
//  shrb
//  用户中心
//  Created by PayBay on 15/6/24.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

import UIKit

class UserCenterTableViewController: UITableViewController {

    
    let data = ["我的订单","我的收藏","设置","帮助中心","联系客服","关于通宝"]
    override func viewDidLoad() {
        super.viewDidLoad()

        //导航颜色
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 253.0/255.0, green: 99.0/255.0, blue: 93.0/255.0, alpha: 1);
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(),NSFontAttributeName: UIFont(name: "Heiti SC", size: 19.0)!]

        self.tabBarController!.tabBar.selectedItem!.selectedImage = UIImage(named: "我的_highlight")
        
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1)
        
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController!.tabBar.hidden = false;
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.tabBarController!.tabBar.hidden = true;
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 3
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 8

    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return section == 0 ? 1 : 3
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            tableView.registerNib(UINib(nibName: "MeImageAndLabelsTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageAndLabelsCellId")
            
            let cell = tableView.dequeueReusableCellWithIdentifier("ImageAndLabelsCellId", forIndexPath: indexPath) as! MeImageAndLabelsTableViewCell
            
            cell.selectionStyle = UITableViewCellSelectionStyle(rawValue: 0)!
            cell.ImageView.image = UIImage(named: "默认女头像")
            cell.titleLabel.text = "赵晓红"
            cell.SubtitleLabel.text = "123456789456"
            
            return cell
        }
        else if indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
            
            cell.selectionStyle = UITableViewCellSelectionStyle(rawValue: 0)!
            cell.textLabel?.text = data[indexPath.row]
            cell.textLabel?.textColor = UIColor(red: 78.0/255.0, green: 78.0/255.0, blue: 78.0/255.0, alpha: 1)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
            
            cell.selectionStyle = UITableViewCellSelectionStyle(rawValue: 0)!
            cell.textLabel?.text = data[indexPath.row+3]
            cell.textLabel?.textColor = UIColor(red: 78.0/255.0, green: 78.0/255.0, blue: 78.0/255.0, alpha: 1)
            
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.section == 0 ? 100 : 44
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 {
            var basicInfoTableViewController = BasicInfoTableViewController()
            self.navigationController?.pushViewController(basicInfoTableViewController, animated: true)
        }
        else if indexPath.section == 1 && indexPath.row == 0 {
            
            var orderListViewController = OrderListViewController()
            self.navigationController?.pushViewController(orderListViewController, animated: true)
        }
        else if indexPath.section == 1 && indexPath.row == 1 {
            
            var collectTableViewController = CollectTableViewController()
            self.navigationController?.pushViewController(collectTableViewController, animated: true)
        }
        
        else if indexPath.section == 1 && indexPath.row == 2 {
            
            let mainStoryboard = UIStoryboard(name: "Me", bundle: nil)
            let viewController = mainStoryboard.instantiateViewControllerWithIdentifier("settingView") as! UIViewController
            self.navigationController?.pushViewController(viewController, animated: true)
            
        }
            
        else if indexPath.section == 2 && indexPath.row == 0 {
            
            let mainStoryboard = UIStoryboard(name: "Me", bundle: nil)
            let viewController = mainStoryboard.instantiateViewControllerWithIdentifier("helpCenterView") as! UIViewController
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else if indexPath.section == 2 && indexPath.row == 1 {
            
            let mainStoryboard = UIStoryboard(name: "Me", bundle: nil)
            let viewController = mainStoryboard.instantiateViewControllerWithIdentifier("shrbServiceView") as! UIViewController
            self.navigationController?.pushViewController(viewController, animated: true)
            
        }
        
        
    }
}
