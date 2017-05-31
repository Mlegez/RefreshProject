//
//  RefreshControl.swift
//  RefreshProject
//
//  Created by 杨泽 on 2017/5/15.
//  Copyright © 2017年 yangze. All rights reserved.
//

import UIKit

enum refreshStates:Int {
    case nom = 0 , pull,refreshing
}

class RefreshControl: UIView {
    
    var superView = UIScrollView()
    var refershlogo : RefreshJKlogoView?
    
    fileprivate var refreshstate = refreshStates.nom {
        didSet {
            switch refreshstate {
            case .refreshing:
                //  调整顶部距离
                var inset = self.superView.contentInset
                // 原有的顶部距离加上刷新空间高度
                inset.top = inset.top + refreshControlWH
                // 调整
                DispatchQueue.main.async {
                    
                    UIView.animate(withDuration: 1.0, animations: {
                        
                        self.superView.contentInset = inset
                        self.superView.setContentOffset(CGPoint.init(x: 0, y: -inset.top), animated: false)
                        
                    })
                    
                }
                
                
            default:
                break
                
            }
        
        
        }
     
    
    }
    
    
    
    override init(frame:CGRect){
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let refreshControlWH:CGFloat = 60
    
    private func setUpUI(){
        
        refershlogo = RefreshJKlogoView.init(frame: self.bounds)
        print(self.bounds)
        self.addSubview(refershlogo!)
        
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        if let superView = newSuperview as? UIScrollView {
            self.superView = superView
            // 监听superView的frame变化
            superView.addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.new, context: nil)
            // 监听superView的滚动
            superView.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.new, context: nil)
        }
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if keyPath == "frame" {
            
            // 取到改变后的值
            let value = (change![NSKeyValueChangeKey.newKey] as! NSValue).cgRectValue
            // 重新设置位置
            setLocation(superViewFrame: value)
            
        }else if keyPath == "contentOffset"{
            
            dealContentOffsetYChanged()
        }
    }
    
    /// 设置控件的初始位置
    
    private func setLocation(superViewFrame: CGRect) {
        self.center = CGPoint(x: superViewFrame.width * 0.5, y: -self.frame.height * 0.5)
    }
    
    
    /// 默认的centerY
    lazy var defaultCenterY: CGFloat = {
        return -self.frame.height * 0.5 - 13
    }()
    
    private func dealContentOffsetYChanged() {
        
        let scale = -(superView.contentOffset.y + superView.contentInset.top)/refreshControlWH
        self.refershlogo?.contentOffsetScale = scale
        
        
        // 取出偏移的y值
        let contentOffsetY = superView.contentOffset.y;
        
        // 1. 设置 控件的 y 值
        // 通过偏移量与顶部间距计算数当前控件的中心点
        let result = (contentOffsetY + superView.contentInset.top) / 2
        
        // 判断计算出来的值是否比默认的Y值还要小，如果小，就设置该 y 值
        if result < defaultCenterY {
            self.center = CGPoint(x: self.center.x, y: result)
        }else{
            // 否则继续设置为默认Y值
            self.center = CGPoint(x: self.center.x, y: defaultCenterY)
        }
        
        print(contentOffsetY,result,defaultCenterY,self.frame.size.height)
        
        // 正在拖拽
        if self.superView.isDragging {
            if result < defaultCenterY && refreshstate == .nom {
               refreshstate = .pull
            }else if result >= defaultCenterY && refreshstate == .pull{
             refreshstate = .nom
            }
            
        }else {
            if refreshstate == .pull {
                refreshstate = .refreshing
            }
        }
        

    }
}
