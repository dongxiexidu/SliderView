//
//  AppDelegate.swift
//  SliderView
//
//  Created by fashion on 2017/11/11.
//  Copyright © 2017年 shangZhu. All rights reserved.
//

import Foundation
import UIKit

let kStatuseH : CGFloat = isIphoneX == true ? 44 : 20
let isIphoneX : Bool = kScreenHeight == 812.0 ? true : false
let kScreenWidth = UIScreen.main.bounds.size.width
let kScreenHeight = UIScreen.main.bounds.size.height
let kScaleOn375Width = kScreenWidth / 375.0
let kScaleOn375Height = kScreenHeight / 667.0
