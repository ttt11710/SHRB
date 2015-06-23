//
//  OrderListViewController.swift
//  shrb
//
//  Created by PayBay on 15/6/23.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

import UIKit


class OrderListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var tableView : UITableView!
    let data = [
        ["orderImageView":"辛巴克.jpg","money":"金额：100元","date":"时间：18:30 2015/06/01","orderNum":"订单号：201506010001","address":"地区：上海市徐汇区龙吴路1333号华滨家园23#1202室"],
        ["orderImageView":"冰雪皇后.jpg","money":"金额：2300元","date":"时间：15:30 2015/06/13","orderNum":"订单号：201506010003","address":"地区：徐汇区"],
        ["orderImageView":"雀巢.jpg","money":"金额：400元","date":"时间：12:30 2015/06/04","orderNum":"订单号：201506010004","address":"地区：徐汇区"],
        ["orderImageView":"吉野家.jpg","money":"金额：350元","date":"时间：18:30 2015/06/23","orderNum":"订单号：201506010006","address":"地区：徐汇区"],
        ["orderImageView":"雀巢.jpg","money":"金额：33440元","date":"时间：18:30 2015/06/12","orderNum":"订单号：201506010011","address":"地区：徐汇区"],
    ]
    
    let cellIdentifier = "orderListTableViewCellId"
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeigth = UIScreen.mainScreen().bounds.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //去除tableview顶部留白
        self.automaticallyAdjustsScrollViewInsets = false;
        
        tableView = UITableView(frame: CGRectMake(0, 44+20, screenWidth, screenHeigth-44-20), style: UITableViewStyle.Plain)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(UINib(nibName: "OrderListTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.view.addSubview(tableView)
        
        
    
        // Do any additional setup after loading the view.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! OrderListTableViewCell
        cell.orderImageView.image = UIImage(named:data[indexPath.row]["orderImageView"]!)
        
        let dataString = data[indexPath.row]["money"]! + "\n" + data[indexPath.row]["date"]! + "\n" + data[indexPath.row]["orderNum"]! + "\n" + data[indexPath.row]["address"]!
        
        cell.orderListInfoLabel.text = dataString
        
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let label = UILabel(frame: CGRectMake(0, 0,screenWidth - 110 , CGFloat.max))
        label.numberOfLines = 1000
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = UIFont.systemFontOfSize(17)
        let dataString = data[indexPath.row]["money"]! + "\n" + data[indexPath.row]["date"]! + "\n" + data[indexPath.row]["orderNum"]! + "\n" + data[indexPath.row]["address"]!
        
        label.text = dataString
        
        label.sizeToFit()
        if label.frame.height > 80{
            return label.frame.height + 35
        }
        return 100
    }
}
