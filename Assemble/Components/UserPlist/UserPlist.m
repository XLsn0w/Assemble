//
//  UserPlist.m
//  TimeForest
//
//  Created by TimeForest on 2018/10/24.
//  Copyright © 2018 TimeForest. All rights reserved.
//

#import "UserPlist.h"

@interface UserPlist ()

@property (nonatomic, copy) NSString *plistPath;

@end

@implementation UserPlist

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static UserPlist* singleton;
    dispatch_once(&onceToken,^{
        singleton = [[self alloc] init];
    });
    return singleton;
}

- (void)createUserPlist {
    self.plistPath = [XLsn0wDocumentDirectory stringByAppendingPathComponent:@"UserPlist.plist"];
}

- (void)insertUserId:(NSNumber*)userId
                name:(NSString *)name
                 sex:(NSString *)sex
            username:(NSString *)username
        headportrait:(NSString *)headportrait {

    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setObject:userId forKey:@"userId"];
    [dic setObject:name forKey:@"name"];
    [dic setObject:sex forKey:@"sex"];
    [dic setObject:username forKey:@"username"];
    [dic setObject:headportrait forKey:@"headportrait"];
    
    NSMutableArray *rootArray = [[NSMutableArray alloc] initWithObjects:dic, nil];
    BOOL isWrite = [rootArray writeToFile:self.plistPath atomically:YES];

    if (isWrite == true){
        NSLog(@"数据写入成功");
    }else{
        NSLog(@"数据写入失败");
    }
}

- (id)selectValueForKey:(NSString *)key {
    XLsn0wLog(@"plist=== %@", [XLsn0wDocumentDirectory stringByAppendingPathComponent:@"UserPlist.plist"]);
    NSMutableArray *rootArray = [[NSMutableArray alloc] initWithContentsOfFile:self.plistPath];
    
    XLsn0wLog(@"rootArray=== %@", rootArray);
    id value = [rootArray[0] objectForKey:key];
    return value;
}

- (NSNumber*)userId {
    return [UserSharedPlist selectValueForKey:@"userId"];
}

- (NSString*)name {
    return [UserSharedPlist selectValueForKey:@"name"];
}

- (NSString*)sex {
    return [UserSharedPlist selectValueForKey:@"sex"];
}

- (NSString*)birthday {
    return [UserSharedPlist selectValueForKey:@"birthday"];
}

- (NSString*)username {
    return [UserSharedPlist selectValueForKey:@"username"];
}

- (NSString*)headportrait {
    return [UserSharedPlist selectValueForKey:@"headportrait"];
}

@end

/*XLsn0w*
 
 {
 "id" : 107,
 "refereeId" : null,
 "tree" : "1",
 "createtime" : "2018-10-17T14:23:12.000+0000",
 "isdelete" : 0,
 "treeRootId" : null,
 "sex" : "保密",
 "transactionPassword" : null,
 "headportrait" : null,
 "type" : 1,
 "source" : null,
 "updatetime" : "2018-10-17T14:23:41.000+0000",
 "birthday" : null,
 "username" : "18157363736",
 "passwd" : "68539332F536A2EB941A7313BBE624D2",
 "name" : null,
 "status" : null
 }
 
 */
