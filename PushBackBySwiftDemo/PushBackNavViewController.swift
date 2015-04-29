//
//  PushBackNavViewController.swift
//  PushBackBySwiftDemo
//
//  Created by xiazer on 14-7-30.
//  Copyright (c) 2014年 xiazer. All rights reserved.
//

import UIKit

let moveProportion:CGFloat = 0.7

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
    var captureType:CaptureType = CaptureType.CaptureTypeWithView
    var pushBackType:PushBckType = PushBckType.PushBackWithSlowMove
    //手势相关
    var disablePushBack:Bool = true
    var isPopToRoot:Bool = false
    //其他
    var startX:CGFloat! = 0.0
    var capImageArr:NSMutableArray! = NSMutableArray(capacity: 100)
    
    var backGroundImg:UIImageView!
    var maskCover:UIView!
    var backGroundView:UIView!
    var pushNum:Int! = 0
    var isMoving:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self;
        //add 左侧的阴影
        let shadowImageView:UIImageView! = UIImageView(image: UIImage(named: "leftside_shadow_bg.png"))
        shadowImageView.frame = CGRectMake(-10, 0, 10, ScreenHeight)
        self.view.addSubview(shadowImageView)
        
        //绑定手势事件
        let panGus:UIPanGestureRecognizer! = UIPanGestureRecognizer()
        panGus.delegate = self
        panGus.addTarget(self, action: "panGesReceive:")
        self.view.addGestureRecognizer(panGus)
    }

    //pragma -mark UIGurstureDelegate
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        println("参数---->>\(self.capImageArr!.count)...\(self.disablePushBack)...\(self.isMoving)")
        if(self.capImageArr!.count < 1 ||
            self.disablePushBack ||
            self.isMoving){
            return false
        }
        return true
    }
    
    //手势事件方法
    func panGesReceive(panGesReceive:UIPanGestureRecognizer){
        var status = panGesReceive.state
        let screenWindow:UIWindow = UIWindow()
        var panPoint:CGPoint = panGesReceive.locationInView(screenWindow)
        let frame:CGRect = self.view.frame

        switch(status){
        case UIGestureRecognizerState.Began:
            self.startX = panPoint.x
            if((self.backGroundView) != nil){
                self.backGroundView?.removeFromSuperview()
            }
            self.backGroundView = UIView(frame: frame)
            self.view.superview!.insertSubview(self.backGroundView, belowSubview: self.view)
            
            if(self.maskCover == nil){
                self.maskCover = UIView(frame: frame)
                self.maskCover?.backgroundColor = UIColor.blackColor()
                self.backGroundView?.addSubview(self.maskCover)
            }
            
            if(self.backGroundImg != nil){
                self.backGroundImg?.removeFromSuperview()
            }
            
            var img:UIImage = (self.capImageArr!.lastObject) as! UIImage
            self.backGroundImg = UIImageView(image: img)
            self.backGroundImg!.frame = frame
            self.backGroundView?.insertSubview(self.backGroundImg, belowSubview: self.maskCover)
            
            break;
        case UIGestureRecognizerState.Ended:
            if(panPoint.x - startX! > 50){
                UIView.animateWithDuration(0.3, animations: {
                    self.moveToX(ScreenWidth)
                    }, completion: { (finished: Bool) -> Void in
                        println("self.isPopToRoot--->>\(self.isPopToRoot)")
                        if(self.isPopToRoot){
                            self.popToRootViewControllerAnimated(false)
                        }else{
                            self.popViewControllerAnimated(false)
                        }
                        var frame:CGRect = self.view.frame;
                        frame.origin.x = 0;
                        self.view.frame = frame;
                    })
            }else{
                UIView.animateWithDuration(0.3, animations: {
                    self.moveToX(0)
                    }, completion: { (finished: Bool) -> Void in
                        
                    })
            }
            break;
        case UIGestureRecognizerState.Changed:
            self.moveToX(panPoint.x - startX!)

            break;
        default:
            
            break;
        }
        
    }

    func moveToX(x: CGFloat){
        var frameX:CGFloat = 0
        frameX = (x >= ScreenWidth ? ScreenWidth : x);
        frameX = (x < 0 ? 0 : x);
        var frame:CGRect = self.view.frame
        var alphaF:CGFloat = 0.5 - frameX/800
        
        frame.origin.x = frameX
        self.view.frame = frame
        self.maskCover?.alpha = alphaF

        if(self.pushBackType == PushBckType.PushBackWithSlowMove){
            var leftX:CGFloat = (frameX - ScreenWidth) * 0.3
            frame.origin.x = leftX
            backGroundView.frame = frame
        }else{
            var scale:CGFloat = frameX/(ScreenWidth*20) + 0.95
            self.backGroundView!.transform = CGAffineTransformMakeScale(scale, scale)
        }
    }
    
    
    //pragma mark -popView
    override func popViewControllerAnimated(animated: Bool) -> UIViewController? {
        if(!isMoving){
            self.isMoving = true
            if(self.capImageArr!.count >= 1){
                self.capImageArr!.removeLastObject()
            }
            println("pop--->>\(self.capImageArr.count)")
            return super.popViewControllerAnimated(animated)
            
        }else{
            return nil
        }
    }
    
    override func popToRootViewControllerAnimated(animated: Bool) -> [AnyObject]? {
        self.capImageArr!.removeAllObjects()
        return popToRootViewControllerAnimated(animated)
    }
    
    override func pushViewController(viewController: UIViewController, animated: Bool) {
        if(!self.isMoving){
            self.isMoving = true
            if(self.pushNum != 0){
                self.capImageArr!.addObject(self.capture())
                self.pushNum = self.pushNum + 1;
                println("pushNum----1>>\(pushNum)...\(self.viewControllers.count)")
                
                return super.pushViewController(viewController, animated: animated)
            }else{
                self.pushNum = self.pushNum + 1;
                println("pushNum----2>>\(pushNum)")
                return super.pushViewController(viewController, animated: animated)
            }
        }else{
            return super.pushViewController(viewController, animated: animated)
        }
    }

    func capture() -> UIImage!{
        if(self.captureType == CaptureType.CaptureTypeWithView){
            UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0)
            self.view.layer.renderInContext(UIGraphicsGetCurrentContext())
            var img:UIImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return img
        }else{
            var screenWindow:UIWindow! = UIApplication.sharedApplication().keyWindow
            UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0)
            screenWindow.layer.renderInContext(UIGraphicsGetCurrentContext())
            var img:UIImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return img
        }
    }
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        self.disablePushBack = false
    }
    
    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
        self.isMoving = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
