//
//  DataBaseViewController.m
//  Database_Demo
//
//  Created by 马金丽 on 17/10/17.
//  Copyright © 2017年 majinli. All rights reserved.
//

#import "DataBaseViewController.h"
#import "PersonModel.h"
#import <sqlite3.h>
#import "DataBaseManager.h"
static sqlite3 *db;
@interface DataBaseViewController ()

@property(nonatomic,strong)PersonModel *person;
@property(nonatomic,strong)DataBaseManager *dbManager;
@end

@implementation DataBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _person = [[PersonModel alloc]init];
    _person.name = @"小1";
    _person.age = 8;
    _person.number = 001;
//    [self openDataBase];
//    [self addPerson:_person];
//    [self deletePersonData:_person];
//    [self updateWithPerson:_person];
//    [self selectdb];
//    [self closeSqlite];
    _dbManager = [DataBaseManager shareManager];
    [_dbManager openDB];
    [_dbManager createTable];
//    [_dbManager insertData:@"小1"];
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    int testMaxCount = 10000;
    for (int i = 0; i < testMaxCount; i++) {
        NSString *str = [NSString stringWithFormat:@"%d",i];
        [arr addObject:str];
    }
    //未开启事务插入
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
//    [_dbManager insertDataByNormal:arr];
    CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
    NSLog(@"普通插入time:%0.3f",end-start);
    
//    [_dbManager deleteData];
    //开启事务插入
    start = CFAbsoluteTimeGetCurrent();
    [_dbManager insertDataByTransaction:arr];
    end = CFAbsoluteTimeGetCurrent();
    NSLog(@"开启事务插入time:%0.3f",end-start);
    [_dbManager deleteData];

}

#pragma mark -创建数据库
- (void)openDataBase
{
    //判断数据库是否为空,如果不为空说明已经打开
    if (db != nil) {
        NSLog(@"数据库已经打开");
        return;
    }
    //获取数据库文件路径
    NSString *dbPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject] stringByAppendingPathComponent:@"myDB.sqlite"];
    //打开数据库,如果数据库存在就打开,不存在就创建
    int result = sqlite3_open([dbPath UTF8String], &db);
    if (result == SQLITE_OK) {
        NSLog(@"数据库打开成功");
        [self createTable];

    }else{
        NSLog(@"数据库打开失败");

    }
    
}
//创建表格
- (void)createTable
{
    //准备sqlite语句
    NSString *sqlite = [NSString stringWithFormat:@"create table if not exists 'student' ('number' integer primary key autoincrement not null,'name' text,'sex' text,'age'integer)"];
    //执行sqlite语句
    char *error = NULL;
    int result = sqlite3_exec(db, [sqlite UTF8String], nil, nil, &error);
    if (result == SQLITE_OK) {
        NSLog(@"创建表成功");
    }else{
        NSLog(@"创建表示失败");
    }
}


//添加数据
- (void)addPerson:(PersonModel *)person
{
    NSString *sqlite = [NSString stringWithFormat:@"insert into student(number,name,age)values('%ld','%@','%ld')",person.number,person.name,person.age];
    char *error = NULL;
    int result = sqlite3_exec(db, [sqlite UTF8String], nil, nil, &error);
    if (result == SQLITE_OK) {
        NSLog(@"添加数据成功");
    }else{
        NSLog(@"添加数据失败");
    }
}

//删除数据
- (void)deletePersonData:(PersonModel *)person
{
    NSString *sqlite = [NSString stringWithFormat:@"delete from student where number = %ld",person.number];
    char *error = NULL;
    int result = sqlite3_exec(db, [sqlite UTF8String], nil, nil, &error);
    if (result == SQLITE_OK) {
        NSLog(@"删除数据成功");
    }else{
        NSLog(@"删除数据失败");
    }
    
}

//修改数据
- (void)updateWithPerson:(PersonModel *)person
{
    NSString *sqlite = [NSString stringWithFormat:@"update student set name = '%@',age = '%ld' where number = '%ld'",person.name,person.age,person.number];
    char *error = NULL;
    int result = sqlite3_exec(db, [sqlite UTF8String], nil, nil, &error);
    if (result == SQLITE_OK) {
        NSLog(@"修改数据成功");
    }else{
        NSLog(@"修改数据失败");
    }
}


//查询所有数据
- (void)selectdb
{
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    NSString *sqlite = [NSString stringWithFormat:@"select *from student"];
    sqlite3_stmt *stmt = NULL;
    int result = sqlite3_prepare(db, [sqlite UTF8String], -1, &stmt, NULL);//第三个参数是一次性返回所有参数就用-1
    if (result == SQLITE_OK) {
        NSLog(@"查询成功");
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            PersonModel *person = [[PersonModel alloc]init];
            //从伴随指针获取数据
            person.number = sqlite3_column_int(stmt, 0);
            person.name = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
            person.age = sqlite3_column_int(stmt, 2);
            [resultArray addObject:person];
        }
    }else{
        NSLog(@"查询失败");
    }
    //关闭伴随指针
    sqlite3_finalize(stmt);
    
    NSLog(@"%@",resultArray);
}

//关闭数据库
- (void)closeSqlite
{
    int result = sqlite3_close(db);
    if (result == SQLITE_OK) {
        NSLog(@"关闭数据库成功");
    }else{
        NSLog(@"关闭数据库失败");
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
