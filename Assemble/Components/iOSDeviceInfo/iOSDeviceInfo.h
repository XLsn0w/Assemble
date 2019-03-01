//
//  DeviceInfo.h
//  DeviceInfo
//
//  Created by dzw on 2017/7/26.
//  Copyright © 2017年 段志巍. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface iOSDeviceInfo : NSObject

+ (NSString*)deviceTypeDetail;

// 返回本类提供的所有设备信息
+ (NSDictionary *)deviceInfo;

/**
 executablePath 和 其进行MD5加密后的值

 executablePath = array[0];
 MD5Value = array[1];
 
 @return executablePath和其MD5值加密值
 */
+ (NSArray *)executablePathAndMD5Value;

/**
 是否越狱

 @return 是否越狱
 */
+ (BOOL)isJailBroken;

/**
 获取设备Mac地址

 @return Mac地址
 */
+ (NSString *)getMacAddress;


/**
 获取App名称

 @return app名称
 */
+ (NSString *)getApplicationName;

/**
 获取app版本号

 @return app版本号
 */
+ (NSString*)getLocalAppVersion;

/**
 获取BundleID

 @return bundle ID
 */
+ (NSString*)getBundleID;


/**
 获取设备当前IP

 @return  获取设备当前IP
 */
+ (NSString *)getDeviceIPAdress;

/**
 电池电量

 @return 电池电量
 */
+ (CGFloat)getBatteryLevel;


/**
 电池状态

 @return 电池状态
 */
+ (NSString *)getBatteryState;

/**
 当期设备语言

 @return 当前设备语言
 */
+ (NSString *)getDeviceLanguage;










/** * * * * * * * * * * * *获取infoDict里面部分信息 * * * * * * * * * * * * * * */
/**
 当前app的版本
 
 @return app的版本号 e.g:1.1.1
 */
+ (NSString *)appVersion;

/**
 当前app的名字
 
 @return app的名字字符串
 */
+ (NSString *)appName;

/**
 当前app的内建版本
 
 @return app的内建版本
 */
+ (NSString *)appBuildVersion;

/**
 当前app的标示
 
 @return appBundleId
 */
+ (NSString *)appBundleId;

/**
 当前app在itunes上的url
 
 @return app在itunes 的url
 */
+ (NSString *)appUrlInItunes;
/* * * * * * * * * * * * * *获取设备的部分目录 * * * * * * * * * * * * * * * * */

/**
 获取手机系统的版本
 
 @return 手机系统版本 ,如8.1
 */
+ (CGFloat)systemVersion;

/**
 获取手机型号
 
 @return 获取手机型号:e.g  iPhone 6
 */
+ (NSString *)getDeviceName;
/* * * * * * * * * * * * * *获取sandbox中存储目录 * * * * * * * * * * * * * * */

/*
 HomeDir目录
 |
 |--Documents目录
 |
 |--Library目录-- |
 |               |--Caches目录
 |               |
 |               |--Preferences目录
 |--tmp目录
 */
/**
 主目录
 
 @return 主目录
 */
+ (NSString *)appHomeDir;
/**
 documents用于存储用户数据或其它应该定期备份的信息
 
 @return documents目录
 */
+ (NSString *)appDocumentsPath;

/**
 用于存放应用程序专用的支持文件，保存应用程序再次启动过程中需要的信息。
 
 @return caches文件路径
 */
+ (NSString *)appCachesPath;

/**
 这个目录用于存放临时文件，保存应用程序再次启动过程中不需要的信息。
 
 @return tmp路径
 */
+ (NSString *)appTmp;

@end
