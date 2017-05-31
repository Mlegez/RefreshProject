//
//  RefreshJKlogoView.swift
//  RefreshProject
//
//  Created by yangze on 2017/5/24.
//  Copyright © 2017年 yangze. All rights reserved.
//

import UIKit

class RefreshJKlogoView: UIView {
    
    /// 拖动距离计算出来的填充比
    var contentOffsetScale: CGFloat = 0 {
        didSet {
            // 当比例值大于 1 的时候，就设置为 1
            if contentOffsetScale > 1 {
                contentOffsetScale = 1
            }
            // 当比例值小于 0 的时候，就设置为 0
            if contentOffsetScale <= 0 {
                contentOffsetScale = 0
            }
            
            drawInLayer()
        }
    }
    
    
    let toplinelayer : CAShapeLayer = {
        
        let  layer = CAShapeLayer()
        let ThemeColor = UIColor(red: 59/255, green: 84/255, blue: 106/255, alpha: 1)
        layer.lineWidth = 5
        layer.fillColor = ThemeColor.cgColor
        layer.strokeColor = ThemeColor.cgColor
        return layer
    }()
    
    let arclayer : CAShapeLayer =  {
        
        let  layer = CAShapeLayer()
        layer.lineWidth = 5
        let ThemeColor = UIColor(red: 59/255, green: 84/255, blue: 106/255, alpha: 1)
        let bgcolor = UIColor(red:222/255,green:226/255,blue:229/255,alpha:1.0)
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = ThemeColor.cgColor
        return layer
    }()
    
    
    override init(frame:CGRect){
        super.init(frame: frame)
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension RefreshJKlogoView {
    func setupUI() {
        
        // 填充的颜色
        /// 线宽
        let LineWidth: CGFloat = 5
        /// 顶部矩形高度
        let LineHeight: CGFloat = 16
        /// 内圆半径
        let InnerRadius: CGFloat = 8
        /// 绘制的中心点
        let DrawCenter = CGPoint(x: frame.size.height * 0.5, y: frame.size.height * 0.5)
        let startAngle = (M_PI * 90)/180
        let endAngle = 0
        
        
        // 绘制默认状态与松手就刷新状态的代码
        // 绘制灰色背景 layer 内容
        // 画 1/4 圆
        let path = UIBezierPath(arcCenter: DrawCenter, radius: InnerRadius, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: false)
        // 添加左边竖线
        path.addLine(to: CGPoint(x: path.currentPoint.x, y: DrawCenter.y - LineHeight))
        // 添加顶部横线
        path.addLine(to: CGPoint(x: path.currentPoint.x + LineWidth, y: path.currentPoint.y))
        // 添加右边竖线
        path.addLine(to: CGPoint(x: path.currentPoint.x, y: path.currentPoint.y + LineHeight))
        // 添加外圆
        path.addArc(withCenter: DrawCenter, radius: InnerRadius + LineWidth, startAngle: CGFloat(endAngle), endAngle: CGFloat(startAngle), clockwise: true)
        path.close()
        
        let bgColor = UIColor(red: 222/255, green: 226/255, blue: 229/255, alpha: 1)
        let nomlayer = CAShapeLayer.init()
        nomlayer.fillColor = bgColor.cgColor
        nomlayer.strokeColor = bgColor.cgColor
        nomlayer.path = path.cgPath
        
        
        self.layer.addSublayer(nomlayer)
        
        self.layer.addSublayer(toplinelayer)
        
        self.layer.addSublayer(arclayer)
        print(self.bounds)
        
    }
    
    
    /// 绘制 layer 中的内容
    fileprivate func drawInLayer() {
        // 绘制默认状态与松手就刷新状态的代码
        // 绘制灰色背景 layer 内容，上面已经有该代码，省略
        
        // 通过比例绘制填充 layer
        // 如果小于0.016.在画度半圆的时候会反方向画，所以加个判断
        if contentOffsetScale < 0.016 {
            toplinelayer.path = nil
            arclayer.path = nil
            return
        }
        
        /// 线宽
        let LineWidth: CGFloat = 10
        /// 顶部矩形高度
        let LineHeight: CGFloat = 16
        /// 内圆半径
        let InnerRadius: CGFloat = 8
        /// 绘制的中心点
        let DrawCenter = CGPoint(x: frame.size.height * 0.5 - 2.5, y: frame.size.height * 0.5)
        let startAngle:CGFloat = CGFloat((M_PI * 90)/180)
        let endAngle = 0
        
        
        /// 提供内部方法，专门用于获取绘制底部的圆的 path
        func pathForBottomCircle(contentOffsetScale: CGFloat) -> UIBezierPath {
            // 记录传入的比例
            var scale = contentOffsetScale
            // 如果比例大于 0.5，那么设置为 0.5
            if scale > 0.5 {
                scale = 0.5
            }
            // 计算出开始角度与结束角度
            let targetStartAngle = startAngle
            let targetEndAngle = startAngle - startAngle * scale * 2
            // 初始化 path 并返回
            let drawPath = UIBezierPath(arcCenter: DrawCenter, radius: InnerRadius + LineWidth * 0.5, startAngle: targetStartAngle, endAngle: targetEndAngle, clockwise: false)
            return drawPath
        }
        arclayer.path = pathForBottomCircle(contentOffsetScale: contentOffsetScale).cgPath
        // 判断如果拖动比例小于0.5，只画半圆
        if contentOffsetScale <= 0.5 {
            toplinelayer.path = nil
        }else {
            // 画顶部竖线
            let topPath = UIBezierPath()
            topPath.lineCapStyle = .square
            topPath.move(to: CGPoint(x: DrawCenter.x + InnerRadius + LineWidth * 0.5, y: DrawCenter.y))
            topPath.addLine(to: CGPoint(x: DrawCenter.x + InnerRadius + LineWidth * 0.5, y: DrawCenter.y - (contentOffsetScale - 0.5) * 2 * LineHeight))
            
            toplinelayer.path = topPath.cgPath
        }
    }
}
