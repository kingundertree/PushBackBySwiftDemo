//
//  PushBackNavViewController.swift
//  PushBackBySwiftDemo
//
//  Created by xiazer on 14-7-30.
//  Copyright (c) 2014年 xiazer. All rights reserved.
//

import UIKit

let moveProportion:Float = 0.7

enum CaptureType{
    case CaptureTypeWithView
    case CaptureTypeWithWindow
}

enum PushBckType{
    case PushBackWithScale
    case PushBackWithSlowMove
}

var vc:DetailViewController?


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
    var pushNum:Int = 0
    var isMoving:Bool! = false
    
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

    //pragma -mark UIGurstureDelegate
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer!, shouldReceiveTouch touch: UITouch!) -> Bool {
        if(capImageArr?.count < 1 ||
            self.disablePushBack ||
            isMoving){
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
            startX = panPoint.x
            if(backGroundView){
                backGroundView?.removeFromSuperview()
            }
            backGroundView = UIView(frame: frame)
            self.view.superview.insertSubview(backGroundView, belowSubview: self.view)
            
            if(!maskCover){
                maskCover = UIView(frame: frame)
//                maskCover?.backgroundColor = UIColor.clearColor()
//                maskCover?.backgroundColor = UIColor!.blackColor()
                backGroundView?.addSubview(maskCover)
            }
            
            if(backGroundImg){
                backGroundImg?.removeFromSuperview()
            }
            
            backGroundImg = UIImageView(frame: frame)
//            backGroundImg?.image = capImageArr?.lastObject
            backGroundView?.insertSubview(backGroundImg, belowSubview: maskCover)
            
            break;
        case UIGestureRecognizerState.Ended:
            if(panPoint.x - startX! > 50){
                UIView.animateWithDuration(0.3, animations: {
                    self.moveToX(ScreenWidth)
                    }, completion: { (finished: Bool) -> Void in
                        if(self.isPopToRoot){
                            self.popToRootViewControllerAnimated(false)
                        }else{
                            self.popViewControllerAnimated(false)
                        }
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

    func moveToX(x: Float){
//        println("moveToX---(x:int)")
        var frameX:Float = 0
        frameX = (x >= ScreenWidth ? ScreenWidth : x);
        frameX = (x < 0 ? 0 : x);
        var frame:CGRect = self.view.frame
        var alphaF:Float = 0.5 - frameX/800
        
        frame.origin.x = frameX
        self.view.frame = frame
//        maskCover?.alpha = alphaF
        
        if(self.pushBackType == PushBckType.PushBackWithSlowMove){
            var leftX:Float = (frameX - ScreenWidth) * 0.3
            frame.origin.x = leftX
        }else{
            var scale:Float = frameX/(ScreenWidth*20) + 0.95
//            backGroundView?.layer.transform = CGAffineTransformMakeScale(0.1, 0.1)
//            backGroundView.transform = CGAffineTransformMakeScale(scale, scale)
        }
    }
    
    
    //pragma mark -popView
    override func popViewControllerAnimated(animated: Bool) -> UIViewController! {
        if(!isMoving){
            isMoving = true
            if(capImageArr?.count >= 1){
                capImageArr?.removeLastObject()
            }
            println("self--->>\(self) \(super.popViewControllerAnimated(animated))")
            return super.popViewControllerAnimated(animated)
            
        }else{
            return nil
        }
    }
    
    override func popToRootViewControllerAnimated(animated: Bool) -> [AnyObject]! {
        capImageArr?.removeAllObjects()
        return popToRootViewControllerAnimated(animated)
    }
    
    
    override func pushViewController(viewController: UIViewController!, animated: Bool) {
        if(!isMoving){
            isMoving = true
            if(pushNum != 0){
                capImageArr?.addObject(self.capture())
                pushNum = pushNum + 1;
                return super.pushViewController(viewController, animated: animated)
            }else{
                pushNum = pushNum + 1;
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
            var screenWindow:UIWindow = UIWindow()
            UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0)
            screenWindow.layer.renderInContext(UIGraphicsGetCurrentContext())
            var img:UIImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return img
        }
    }
    
    func navigationController(navigationController: UINavigationController!, willShowViewController viewController: UIViewController!, animated: Bool) {
        self.disablePushBack = false
    }
    
    func navigationController(navigationController: UINavigationController!, didShowViewController viewController: UIViewController!, animated: Bool) {
        isMoving = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
