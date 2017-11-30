//
//  ViewController.swift
//  SliderView
//
//  Created by fashion on 2017/11/11.
//  Copyright © 2017年 shangZhu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var tableView : UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setUpTableView()
    }
    
    private func setUpTableView() {
        tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        tableView.backgroundColor = UIColor.lightGray
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        view.addSubview(tableView)
        let imgV = UIImageView.init(image: #imageLiteral(resourceName: "timg-10"))
        imgV.contentMode = .scaleAspectFill
        tableView.backgroundView = imgV
        
        let footerView = SliderView(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 60 * kScaleOn375Width), MaxValue: 31, MinValue: 1)
        footerView.tag = 88
        footerView.delegate = self
        tableView.tableFooterView = footerView
        
        let headerView = SliderView(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 60 * kScaleOn375Width), MaxValue: 30, MinValue: 1)
        headerView.tag = 99
        headerView.delegate = self
        tableView.tableHeaderView = headerView
    }
}

extension ViewController : SliderViewDelegate {
    func sliderViewValueChange(leftValue: Int, rightValue: Int, sliderView: SliderView) {
        if sliderView.tag == 88 {
            print("footerView \(leftValue)+\(rightValue)")
        }else{
            print("headerView \(leftValue)+\(rightValue)")
        }
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "dd")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "dd")
        }
        cell?.backgroundColor = UIColor.clear
        return cell!
    }
}
