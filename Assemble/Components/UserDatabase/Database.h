
#import <Foundation/Foundation.h>

#define UserDatabase [Database shared]

@interface Database : NSObject

//文件路径和数据表名
@property (nonatomic, copy) NSString *dbName;
@property (nonatomic, copy) NSString *tableName;
@property (nonatomic, copy) NSString *dbPath;

- (void)removeDatabaseFile;
/**
 *******创建单例******
 */
+(instancetype)shared;


/**
 *******打开数据库&创表******
 */
-(void)openDatabaseFromFileName:(NSString *)dbName
                   andTableName:(NSString *)tableName;


/**
 *******关闭数据库******
 */
-(void)closeDatabase;


/**
 *******添加数据******
 */
-(void)insertName:(NSString *)name
            phone:(NSString *)phone
            email:(NSString *)email
          account:(NSString *)account
           number:(int)number;


/**
 *******删除指定位置******
 */
-(void)deleteT_ID:(int)t_id;


/**
 *******删除所有******
 */
-(void)deleteTable;


/**
 *******查询******
 */
-(NSMutableSet *)selectTable;

/**
 *******查询指定位置(skip是跳过多少条记录,range指定查询纪录的范围)******
 */
-(NSMutableArray *)selectTableWithCondition:(NSString *)condition;


/**
 *******修改数据******
 */
-(void)updateTableWithName:(NSString *)name andNumber:(int)number key:(int)key;


/**
 *******获取Document文件路径(filePath代表文件路径名)******
 */
+(NSString *)documentWithFilePath:(NSString *)filePath;

/**
 *******获取Library文件路径(filePath代表文件路径名)******
 */
+(NSString *)libraryWithFilePath:(NSString *)filePath;

/**
 *******获取Caches文件路径(filePath代表文件路径名)******
 */
+(NSString *)cachesWithFilePath:(NSString *)filePath;

/**
 *******获取Tmp文件路径(filePath代表文件路径名)******
 */
+(NSString *)tmpWithFilePath:(NSString *)filePath;


/**
 *******删除数据库******
 */
-(void)deleteDatabaseWithFilePath:(NSString *)filePath;

/**
 *******修改数据库名******
 */
-(void)updateDatabaseWithFilePath:(NSString *)filePath andOtherFilePath:(NSString *)otherFilePath;

/**
 *******移动数据库(filePath是当前文件路径，otherFilePath指要移动的路径)******
 */
-(void)moveDatabaseWithFilePath:(NSString *)filePath toOtherFilePath:(NSString *)otherFilePath;





@end
