//
//  DetailViewController.swift
//  PushBackBySwiftDemo
//
//  Created by xiazer on 14-7-30.
//  Copyright (c) 2014年 xiazer. All rights reserved.
//

import UIKit


class DetailViewController: UIViewController {
    var detailVC:DetailViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController
        
        self.title = "Detail Page"
        self.view.backgroundColor = UIColor.whiteColor()!
        
        let lab = UILabel(frame: CGRectMake(0, 64, ScreenWidth, 280))
        lab.backgroundColor = UIColor.grayColor()
        lab.text = "!";
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

        let bcakBtn = UIButton.buttonWithType(UIButtonType.System) as UIButton
        bcakBtn.frame = CGRectMake(0, 420, ScreenWidth, 45);
        bcakBtn.backgroundColor = UIColor.blueColor()
        bcakBtn.setTitle("pop back", forState: UIControlState.Normal)
        bcakBtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        bcakBtn.addTarget(self, action: "popBack:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(bcakBtn)
    
        
        let nav:PushBackNavViewController = self.navigationController as PushBackNavViewController
        let arr:NSMutableArray = nav.capImageArr
        println("arr--->>\(arr.count)")
        if(arr.count >= 1){
            let img:UIImage = arr.lastObject as UIImage
            let imgView:UIImageView = UIImageView(frame: CGRectMake(0, 100, 150, 250))
            imgView.image = img
            self.view.addSubview(imgView)
        }
    }

    func btnClick(sender: UIButton){
        print("push demo \n")
        detailVC = DetailViewController()

        self.navigationController.pushViewController(detailVC, animated: true)
    }
    
    func popBack(sender: UIButton){
        print("push demo \n")
//        self.navigationController.popViewControllerAnimated(true)
    }
    
    func goBack(animated:Bool){
//        self.navigationController.popViewControllerAnimated(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
