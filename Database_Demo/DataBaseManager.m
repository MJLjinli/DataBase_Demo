//
//  DataBaseManager.m
//  Database_Demo
//
//  Created by 马金丽 on 17/10/18.
//  Copyright © 2017年 majinli. All rights reserved.
//

#import "DataBaseManager.h"

#import <sqlite3.h>
@interface DataBaseManager()

{
    sqlite3 *db;    //数据库
}

@end

@implementation DataBaseManager

+ (instancetype)shareManager
{
    static DataBaseManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[DataBaseManager alloc]init];
        }
    });
    return manager;
}

//打开数据库
- (void)openDB
{
    if (db != nil) {
        NSLog(@"数据库已经打开");
        return;
    }
    
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject] stringByAppendingPathComponent:@"dbManager.sqlite"];
    if (sqlite3_open([filePath UTF8String], &db) == SQLITE_OK) {
        NSLog(@"数据库打开成功");
    }else{
        NSLog(@"数据库打开失败");
    }
}

//关闭数据库
- (void)closeDB
{
    if (sqlite3_close(db) == SQLITE_OK) {
        NSLog(@"关闭数据库成功");
    }else{
        NSLog(@"关闭数据库失败");
    }
}

//创建数据库表
- (void)createTable
{
    NSString *creatSqlite = [NSString stringWithFormat:@"create table if not exists 'Student'('studentID' integer primary key,'name' text,'sex' text)"];
    char *error = nil;
    if (sqlite3_exec(db, [creatSqlite UTF8String], nil, nil, &error) == SQLITE_OK) {
        NSLog(@"创建表成功");
    }else{
        NSLog(@"创建表失败");
    }
}

//执行数据语句
- (void)exeSql:(NSString *)sql
{
    [self openDB];
    char *error = nil;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &error) == SQLITE_OK) {
        NSLog(@"数据库操作成功");
    }else{
        sqlite3_free(error);//每次使用完毕清空error字符串,提供给下一次使用
        NSLog(@"数据库操作失败");
    }
    sqlite3_close(db);
    
}

//删除数据库表
- (void)dropTable
{
    NSString *dropSqlite = [NSString stringWithFormat:@"drop table %@",@"Student"];
    [self exeSql:dropSqlite];
}

//插入数据
- (void)insertData:(NSString *)insertValues
{
    NSString *insertSqlite = [NSString stringWithFormat:@"insert into %@ (name) values ('%@')",@"Student",insertValues];
    [self exeSql:insertSqlite];
}

//删除数据
- (void)deleteData:(NSString *)deletePrimaryKey
{
    NSString *deleteSqlite = [NSString stringWithFormat:@"delete from Student where studentID = '%ld'",[deletePrimaryKey integerValue]];
    [self exeSql:deleteSqlite];
}

- (void)deleteData
{
    NSString *deleteSqlite = [NSString stringWithFormat:@"delete from %@",@"Student"];
    [self exeSql:deleteSqlite];

}

//修改数据
- (void)updateData:(NSString *)updateStr
{
    NSString *updateSqlite = [NSString stringWithFormat:@"update %@ set name = '%@'",@"Student",updateStr];
    [self exeSql:updateSqlite];
}

//查询数据
- (void)queryData
{
    [self openDB];
    NSString *quarySql = [NSString stringWithFormat:@"select *from %@",@"Student"];
    sqlite3_stmt *stmt;
    if (sqlite3_prepare(db, [quarySql UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
         
            char *name = (char *)sqlite3_column_text(stmt, 1);
            NSString *nameStr = [[NSString alloc]initWithUTF8String:name];
            NSLog(@"%@",nameStr);
        }
        sqlite3_finalize(stmt);
    }
    [self closeDB];
}

//开启事务
- (void)insertDataByTransaction:(NSArray *)tempName
{
    @try {
        char *errorMsg;
        [self openDB];
        if (sqlite3_exec(db, "BEGIN", NULL, NULL, &errorMsg) == SQLITE_OK) {
            NSLog(@"启动事务成功");
            sqlite3_free(errorMsg);
            
            for (NSString *name in tempName) {
                NSString *sql = [NSString stringWithFormat:@"insert into %@ (name) values ('%@')",@"Student",name];
                char *err;
                if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) == SQLITE_OK) {
                    NSLog(@"插入数据成功");
                }else{
                    sqlite3_free(err);
                    NSLog(@"插入数据失败");
                }
            }
            
            if (sqlite3_exec(db, "COMMIT", NULL, NULL, &errorMsg) == SQLITE_OK) {
                NSLog(@"提交事务成功");
            }
            sqlite3_free(errorMsg);
        }else{
            sqlite3_free(errorMsg);
        }
    } @catch (NSException *exception) {
        char *errorMsg;
        if (sqlite3_exec(db, "ROLLBACK", NULL, NULL, &errorMsg) == SQLITE_OK) {
            NSLog(@"回滚事务成功");
        }
        sqlite3_free(errorMsg);
    } @finally {
        [self closeDB];
    }
}

- (void)insertDataByNormal:(NSArray *)tempName
{
    [self openDB];
    for(NSString *name in tempName){
        NSString *sql = [NSString stringWithFormat:@"insert into %@ (name) values ('%@')",@"Student",name];
        char *err;
        if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) == SQLITE_OK) {
            NSLog(@"数据库操作数据成功!");
        }else{
            sqlite3_free(err);
            NSLog(@"数据库操作数据失败!");
        }
    }
    [self closeDB];
}

@end
