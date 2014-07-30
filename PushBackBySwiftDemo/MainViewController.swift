//
//  MainViewController.swift
//  PushBackBySwiftDemo
//
//  Created by xiazer on 14-7-30.
//  Copyright (c) 2014年 xiazer. All rights reserved.
//

import UIKit
//定义屏幕高度
let ScreenHeight = UIScreen.mainScreen().bounds.size.height
//定义屏幕宽度
let ScreenWidth =  UIScreen.mainScreen().bounds.size.width

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "你好！"
        self.view.backgroundColor = UIColor.whiteColor()!

        let lab = UILabel(frame: CGRectMake(0, 64, ScreenWidth, 260))
        lab.backgroundColor = UIColor.grayColor()
        lab.text = "虎";
        lab.font = UIFont.boldSystemFontOfSize(220)
        lab.textAlignment = NSTextAlignment.Center;
        self.view.addSubview(lab)
        
        let btn = UIButton.buttonWithType(UIButtonType.System) as UIButton
        btn.frame = CGRectMake(0, 360, ScreenWidth, 45);
        btn.backgroundColor = UIColor.blueColor()
        btn.setTitle("push next page", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        btn.addTarget(self, action: "btnClick:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(btn)
        
        // Do any additional setup after loading the view.
    }

    func btnClick(sender: UIButton){
        print("push demo \n")
        var detailVC = DetailViewController()
        self.navigationController.pushViewController(detailVC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
