//
//  SliderView.swift
//  SliderView
//
//  Created by fashion on 2017/11/11.
//  Copyright © 2017年 shangZhu. All rights reserved.
//

import UIKit

protocol SliderViewDelegate:NSObjectProtocol {
    func sliderViewValueChange(leftValue: Int,rightValue: Int,sliderView: SliderView)
}

// UIControl是UIView的子类, 是UIKit框架中可交互的控件的基类
// UIButton、UISwitch、UITextField等都是`UIControl`子类
class SliderView: UIControl {
    
    open weak var delegate : SliderViewDelegate?
    
    private let kSliderLayerWidth : CGFloat = 20 * kScaleOn375Width
    private let kSliderLayerHeight : CGFloat = 20 * kScaleOn375Width
    
    //    private let kTextLayerWidth : CGFloat = 35 * kScaleOn375Width
    //    private let kTextLayerHeight : CGFloat = 18 * kScaleOn375Height
    
    private let kTextLayerWidth : CGFloat = 24
    private let kTextLayerHeight : CGFloat = 19
    
    private var kBarWidth : CGFloat = 0
    private let kBarHeight : CGFloat = 10 * kScaleOn375Height
    private var maxValue : Int = 0
    private var minValue : Int = 0
    private var leftTextLayer : CATextLayer!
    private var rightTextLayer : CATextLayer!
    private var leftSliderLayer : CALayer!
    private var rightSliderLayer : CALayer!
    private var leftTracking : Bool = false
    private var rightTracking: Bool = false
    private var previousLocation : CGFloat = 0
    private var currentLeftValue : Int = 0
    private var currentRightValue : Int = 0
    
    lazy var leftBtn: UIButton = {
        let button = UIButton.init()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        button.setBackgroundImage(#imageLiteral(resourceName: "quickrent_price_graybubble"), for: .normal)
        button.titleEdgeInsets = UIEdgeInsetsMake(-3, 0, 0, 0)
        return button
    }()
    lazy var rightBtn: UIButton = {
        let button = UIButton.init()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        button.setBackgroundImage(#imageLiteral(resourceName: "quickrent_price_graybubble"), for: .normal)
        button.titleEdgeInsets = UIEdgeInsetsMake(-3, 0, 0, 0)
        button.titleEdgeInsets = UIEdgeInsetsMake(-3, 0, 0, 0)
        return button
    }()
    
    private lazy var normalBackImageView : UIImageView = {
        let imageV = UIImageView(image: UIImage(named: "quickrent_price_white")?.stretchableImage(withLeftCapWidth: 5, topCapHeight: 4))
        imageV.layer.cornerRadius = 4
        return imageV
    }()
    private lazy var highlightedBackImageView : UIImageView = {
        let imageV = UIImageView(image: UIImage(named: "quickrent_price_redcir")?.stretchableImage(withLeftCapWidth: 10, topCapHeight: 4))
        imageV.layer.cornerRadius = 4
        return imageV
    }()
    
    init(frame: CGRect, MaxValue: Int, MinValue: Int) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        self.maxValue = MaxValue
        self.minValue = MinValue
        self.currentLeftValue = MinValue
        self.currentRightValue = MaxValue
        setUpSubviews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createTextLayer() -> CATextLayer {
        let layer = CATextLayer()
        layer.contentsScale = UIScreen.main.scale
        layer.fontSize = 12
        //layer.foregroundColor = UIColor(red: 19 / 255.0, green: 184 / 255.0, blue: 155 / 255.0, alpha: 1.0).cgColor
        layer.foregroundColor = UIColor.red.cgColor
        layer.backgroundColor = UIColor.lightGray.cgColor
        layer.alignmentMode = kCAAlignmentCenter
        return layer
    }
    
    private func createSliderLayer(imageName:String) -> CALayer {
        let layer = CALayer()
        layer.contents = UIImage(named: imageName)?.cgImage
        return layer
    }
    
    private func setUpSubviews() {
        leftTextLayer = createTextLayer()
        leftTextLayer.string = "\(minValue)"
        layer.addSublayer(leftTextLayer)
        leftBtn.setTitle("\(minValue)", for: .normal)
       // self.addSubview(leftBtn)
        
        leftTextLayer.frame = CGRect.init(x: 0, y: 5 * kScaleOn375Height, width: kTextLayerWidth, height: kTextLayerHeight)
        leftBtn.frame = CGRect.init(x: 0, y: 5 * kScaleOn375Height, width: kTextLayerWidth, height: kTextLayerHeight)
        
        rightTextLayer = createTextLayer()
        rightTextLayer.string = "\(maxValue)+"
        rightBtn.setTitle("\(maxValue)", for: .normal)
        layer.addSublayer(rightTextLayer)
        //self.addSubview(rightBtn)
        rightTextLayer.frame = CGRect.init(x: frame.width - kTextLayerWidth, y: leftTextLayer.frame.minY, width: kTextLayerWidth, height: kTextLayerHeight)
        rightBtn.frame = CGRect.init(x: frame.width - kTextLayerWidth, y: leftTextLayer.frame.minY, width: kTextLayerWidth, height: kTextLayerHeight)
        leftSliderLayer = createSliderLayer(imageName: "quickrent_price_redcir_press")
        layer.addSublayer(leftSliderLayer)
        
        
        leftSliderLayer.frame = CGRect.init(x: 0.5 * fabs(kSliderLayerWidth - kTextLayerWidth), y: 0.5 * (frame.height - kSliderLayerHeight) + 5 * kScaleOn375Width, width: kSliderLayerWidth, height: kSliderLayerHeight)
       // leftBtn.frame = leftSliderLayer.frame
        
        rightSliderLayer = createSliderLayer(imageName: "quickrent_price_redcir_press")
        layer.addSublayer(rightSliderLayer)
        rightSliderLayer.frame = CGRect.init(x: rightTextLayer.frame.minX + 0.5 * fabs(kTextLayerWidth - kSliderLayerWidth), y: leftSliderLayer.frame.minY, width: kSliderLayerWidth, height: kSliderLayerHeight)
        
        
        addSubview(normalBackImageView)
        addSubview(highlightedBackImageView)
        kBarWidth = frame.width - kTextLayerWidth
        normalBackImageView.frame = CGRect.init(x: leftSliderLayer.frame.minX + kSliderLayerWidth * 0.5, y: leftSliderLayer.frame.minY + 0.5 * (kSliderLayerHeight - kBarHeight), width: kBarWidth, height: kBarHeight)
        
        insertSubview(normalBackImageView, at: 0)
        highlightedBackImageView.frame = normalBackImageView.frame
        insertSubview(highlightedBackImageView, at: 1)
    }
}

extension SliderView {
    // UIControl 提供了一些方法来跟踪触摸
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let locationPoint = touch.location(in: self)
        previousLocation = locationPoint.x
        leftTracking = leftSliderLayer.frame.contains(locationPoint)
        rightTracking = rightSliderLayer.frame.contains(locationPoint)
        return leftTracking || rightTracking
    }
    // 你可能注意到当在移动滑块时，可以在控件之外的范围对其拖拽，然后手指回到控件内，也不会丢失跟踪。其实这在小屏幕的设备上，是非常重要的一个功能。
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let currentLocation = touch.location(in: self).x
        if leftTracking {
            
            // 设置 CATransaction 中的 disabledActions。这样可以确保每个 layer 的frame 立即得到更新，并且不会有动画效果
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            let speed = currentLocation - previousLocation
            previousLocation = currentLocation
            leftSliderLayer.frame.origin.x = max(leftSliderLayer.frame.origin.x + speed, 0.5 * fabs(kSliderLayerWidth - kTextLayerWidth))
            leftSliderLayer.frame.origin.x = min(leftSliderLayer.frame.origin.x, rightSliderLayer.frame.origin.x - kSliderLayerWidth)
            currentLeftValue = Int((leftSliderLayer.frame.origin.x - 0.5 * fabs(kSliderLayerWidth - kTextLayerWidth)) / kBarWidth * CGFloat(maxValue - minValue)) + minValue
            updateSliderBarFunc()
            CATransaction.commit()
            leftBtn.setBackgroundImage(#imageLiteral(resourceName: "quickrent_price_greenbubble_press"), for: .normal)
            return true
        } else if rightTracking {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            let speed = currentLocation - previousLocation
            previousLocation = currentLocation
            rightSliderLayer.frame.origin.x = min(rightSliderLayer.frame.origin.x + speed, rightTextLayer.frame.minX + 0.5 * fabs(kTextLayerWidth - kSliderLayerWidth))
            rightSliderLayer.frame.origin.x = max(rightSliderLayer.frame.origin.x, leftSliderLayer.frame.origin.x + kSliderLayerWidth)
            currentRightValue = Int((rightSliderLayer.frame.origin.x - 0.5 * fabs(kSliderLayerWidth - kTextLayerWidth)) / kBarWidth * CGFloat(maxValue - minValue)) + minValue
            updateSliderBarFunc()
            CATransaction.commit()
            rightBtn.setBackgroundImage(#imageLiteral(resourceName: "quickrent_price_greenbubble_press"), for: .normal)
            return true
        }
        return false
    }
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        leftBtn.setBackgroundImage(#imageLiteral(resourceName: "quickrent_price_graybubble"), for: .normal)
        rightBtn.setBackgroundImage(#imageLiteral(resourceName: "quickrent_price_graybubble"), for: .normal)
        leftTracking = false
        rightTracking = false
    }
    
    private func updateSliderBarFunc() {
        highlightedBackImageView.frame = CGRect.init(x: leftSliderLayer.frame.origin.x + 0.5 * kSliderLayerWidth, y: highlightedBackImageView.frame.origin.y, width: rightSliderLayer.frame.origin.x - leftSliderLayer.frame.origin.x, height: kBarHeight)
        
        updateSliderValue()
    }
    private func updateSliderValue() {
        
        leftTextLayer.string = "\(currentLeftValue)"
        leftBtn.frame.origin.x = -(leftBtn.frame.size.width - leftSliderLayer.frame.size.width)/2 + leftSliderLayer.frame.origin.x
        
        leftBtn.setTitle("\(currentLeftValue)", for: .normal)

        rightBtn.frame.origin.x = -(rightBtn.frame.size.width - rightSliderLayer.frame.size.width)/2 + rightSliderLayer.frame.origin.x
        rightTextLayer.string = "\(currentRightValue)"
        rightBtn.setTitle("\(currentRightValue)", for: .normal)

        if let delegate = delegate {
            delegate.sliderViewValueChange(leftValue: currentLeftValue, rightValue: currentRightValue, sliderView: self)
        }
    }
}

