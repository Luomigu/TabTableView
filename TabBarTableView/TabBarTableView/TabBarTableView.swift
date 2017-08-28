//
//  TabBarTableView.swift
//  TabBarTableView
//
//  Created by 杨国盛 on 2017/8/24.
//  Copyright © 2017年 yanggs. All rights reserved.
//

import UIKit

class TabBarTableView: UIView ,UITableViewDelegate,UITableViewDataSource{

    var tableViews = [UITableView]()
    let tabBar = TabBarView()
    var scrollView = UIScrollView()
    let tabbarHeight:CGFloat = 180
    let tabBarContentHeight: CGFloat = 140
    var currentIndex:Int {
        get {
            return Int(scrollView.contentOffset.x / scrollView.frame.width)
        }
    }

    var itemView:UIView {
        get {
            return tabBar.subviews.first!
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func btn_click(sender:UIButton) {
        
        let index =  itemView.subviews.index(of: sender)!
        let offset = CGPoint(x: scrollView.frame.width * CGFloat(index), y: 0)
        self.scrollView .setContentOffset( offset , animated: true)
    }
    
    func tapGresture(_ sender : UITapGestureRecognizer)  {
        
        let  point =  sender.location(in: itemView)
        
        for btn in itemView.subviews as! [UIButton] {
            if btn.frame.contains(point) {
                btn .sendActions(for: .touchUpInside)
            }
        }
    }
    
    public convenience init(frame:CGRect , items:[String]) {
        
        self.init(frame: frame)
        
        tabBar.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: tabbarHeight)
        tabBar.backgroundColor = UIColor.red
        let tabBarItem = UIView.init(frame: CGRect.init(x: 0, y: tabBar.frame.height - 40, width: tabBar.frame.width, height: 40))
        tabBarItem.backgroundColor = UIColor.yellow
        tabBar .addSubview(tabBarItem)
        
        let tapGR = UITapGestureRecognizer.init(target: self, action: #selector(tapGresture(_:)))
        self .addGestureRecognizer(tapGR)
        
        scrollView.frame = frame
        scrollView.isPagingEnabled = true
        scrollView.scrollsToTop = false        
        scrollView.contentSize = CGSize.init(width: frame.width * CGFloat(items.count), height: 0)
        self.addSubview(scrollView)
        self .addSubview(tabBar)

        for  index in 0 ..< items.count {
            let width = tabBar.frame.width / CGFloat(items.count)
            let frame = CGRect.init(x: CGFloat(index) * width , y: 0, width: width, height: tabBarItem.frame.height)
            let btn = UIButton.init(frame: frame)
            btn.setTitle(items[index], for: .normal)
            btn .setTitleColor(UIColor.black, for: .normal)
            btn .addTarget(self, action: #selector(btn_click(sender:)), for: .touchUpInside)
            btn.isEnabled = false
            tabBarItem .addSubview(btn)
            
            var tableFrame = self.bounds
            tableFrame =  tableFrame.offsetBy(dx: tableFrame.width * CGFloat.init(index) , dy: 0)
            
            let tableView =  UITableView.init(frame: tableFrame)
            tableView.scrollIndicatorInsets = UIEdgeInsets(top: tabBar.frame.height, left: 0, bottom: 0, right: 0 )
            let headerView = UIView.init(frame: tabBar.frame)
            tableView.backgroundColor = UIColor.clear
            tableView.tableHeaderView = headerView
            tableView.scrollsToTop = false
            tableView.delegate = self
            tableView.dataSource = self
            scrollView .addSubview(tableView)
            tableViews .append(tableView)
            tableView .reloadData()
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        let response = super.hitTest(point, with: event)
        
        if response?.frame.height == tabbarHeight || response == itemView {
            
            return tableViews[currentIndex]
        }
        
        return response
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView .dequeueReusableCell(withIdentifier: "testCell")
        if cell == nil {
            cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "testCell")
        }
        
        let index = tableViews.index(of: tableView)
        
        cell?.detailTextLabel?.text = "第\(index!) 个tableView  row: \(indexPath.row)"
        return cell!
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY =  scrollView.contentOffset.y
        
        if offsetY < tabBarContentHeight {
            tabBar.frame.origin.y = -offsetY
            
            scrollView.scrollIndicatorInsets = UIEdgeInsets(top: tabbarHeight - offsetY, left: 0, bottom: 0, right: 0 )
            
            for tableView in tableViews {
                if tableView != scrollView {
                    tableView.contentOffset = scrollView.contentOffset
                }
            }
            
        }else if offsetY > tabBarContentHeight && tabBar.frame.minY > -tabBarContentHeight {
            
            tabBar.frame.origin.y = -tabBarContentHeight
            for tableView in tableViews {
                if tableView != scrollView {
                    tableView.contentOffset = scrollView.contentOffset
                }
            }
        }
    }
}



