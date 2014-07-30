//
//  PushBackNavViewController.swift
//  PushBackBySwiftDemo
//
//  Created by xiazer on 14-7-30.
//  Copyright (c) 2014年 xiazer. All rights reserved.
//

import UIKit

enum CaptureType{
    case CaptureTypeWithView
    case CaptureTypeWithWindow
}

enum PushBckType{
    case PushBackWithScale
    case PushBackWithSlowMove
}


class PushBackNavViewController: UINavigationController,UIGestureRecognizerDelegate,UINavigationControllerDelegate {
    //enum 值
    var captureType:CaptureType? = CaptureType.CaptureTypeWithWindow
    var pushBackType:PushBckType? = PushBckType.PushBackWithSlowMove
    //手势相关
    var disablePushBack:Bool?
    var isPopToRoot:Bool?
    //其他
    var startX:Float?
    var capImageArr:NSMutableArray? = NSMutableArray(capacity: 100)
    var backGroundImg:UIImageView?
    var maskCover:UIView?
    var backGroundView:UIView?
    var pushNum:Int? = 0
    var isMoving:Bool? = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self;
        //add 左侧的阴影
        let shadowImageView:UIImageView! = UIImageView(image: UIImage(named: "leftside_shadow_bg.png"))
        shadowImageView.frame = CGRectMake(-10, 0, 10, ScreenHeight)
        self.view.addSubview(shadowImageView)
        
        //绑定手势事件
        let panGus:UIPanGestureRecognizer! = UIPanGestureRecognizer()
        panGus.addTarget(self, action: "panGesReceive:")
        self.view.addGestureRecognizer(panGus)
    }

    //手势事件方法
    func panGesReceive(panGesReceive:UIPanGestureRecognizer){
        var status = panGesReceive.state
        let screenWindow:UIWindow = UIWindow()
        var panPoint:CGPoint = panGesReceive.locationInView(screenWindow)
        let frame:CGRect = self.view.frame
        
        switch(status){
        case UIGestureRecognizerState.Began:
            startX = panPoint.x
            if(backGroundView){
                backGroundView?.removeFromSuperview()
            }
            backGroundView = UIView(frame: frame)
            self.view.superview.insertSubview(backGroundView, belowSubview: self.view)
            
            if(!maskCover){
                maskCover = UIView(frame: frame)
//                maskCover?.backgroundColor = UIColor!.blackColor()
                backGroundView?.addSubview(maskCover)
            }
            
            if(backGroundImg){
                backGroundImg?.removeFromSuperview()
            }
            
            backGroundImg = UIImageView(frame: frame)
//            backGroundImg?.image = capImageArr?.lastObject:UIImage
            backGroundView?.insertSubview(backGroundImg, belowSubview: maskCover)
            
            break;
        case UIGestureRecognizerState.Ended:
            
            
            break;
        default:
            break;
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
