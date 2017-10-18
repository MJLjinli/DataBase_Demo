//
//  DataBaseManager.h
//  Database_Demo
//
//  Created by 马金丽 on 17/10/18.
//  Copyright © 2017年 majinli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataBaseManager : NSObject


#pragma mark -创建数据库管理单例
+ (instancetype)shareManager;

#pragma mark -打开数据库
- (void)openDB;
#pragma mark -关闭数据库
- (void)closeDB;
#pragma mark -创建数据表
- (void)createTable;
#pragma mark -删除数据表结构
- (void)dropTable;
#pragma mark -执行sql语句
- (void)exeSql:(NSString *)sql;
#pragma mark -插入数据
- (void)insertData:(NSString *)insertValues;
#pragma mark -删除数据
- (void)deleteData:(NSString *)deletePrimaryKey;
- (void)deleteData;
#pragma mark -修改数据
- (void)updateData:(NSString *)updateSqlite;
#pragma mark -查询数据
- (void)queryData;

#pragma mark -插入数据开启事务
- (void)insertDataByTransaction:(NSArray *)tempName;
#pragma mark -插入数据未开启事务
- (void)insertDataByNormal:(NSArray *)tempName;

@end
