//
//  RefreshJKlogoView.swift
//  RefreshProject
//
//  Created by yangze on 2017/5/24.
//  Copyright © 2017年 yangze. All rights reserved.
//

import UIKit

class RefreshJKlogoView: UIView {
    
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
        /// 主题颜色
        let ThemeColor = UIColor(red: 59/255, green: 84/255, blue: 106/255, alpha: 1)
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
        
        
        let nomlayer = CAShapeLayer.init()
        nomlayer.fillColor = ThemeColor.cgColor
        nomlayer.strokeColor = ThemeColor.cgColor
        nomlayer.path = path.cgPath
        
    
        self.layer.addSublayer(nomlayer)
        
    }
}
