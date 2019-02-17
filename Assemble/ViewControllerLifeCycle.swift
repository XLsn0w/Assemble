//
//  ViewControllerLifeCycle.swift
//  Assemble
//
//  Created by XLsn0w on 2019/2/17.
//  Copyright © 2019 TimeForest. All rights reserved.
//

import Foundation

/*
 当viewController的bounds改变，调用viewWillLayoutSubviews这个方法来实现subview的位置。可重写这个方法来实现父视图变化subview跟着变化。
 
 > 生命周期函数顺序调用
 
 - (void)loadView
 - (void)viewDidLoad
 - (void)viewWillAppear
 - (void)viewWillLayoutSubviews
 - (void)viewDidLayoutSubviews
 - (void)viewDidAppear
 
 */
