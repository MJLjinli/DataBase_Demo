//
//  ViewController.m
//  Database_Demo
//
//  Created by 马金丽 on 17/10/17.
//  Copyright © 2017年 majinli. All rights reserved.
//

#import "ViewController.h"
#import "PersonModel.h"
#import "DataBaseViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    //应用程序包
//    NSString *path = [[NSBundle mainBundle] bundlePath];
//    NSLog(@"%@",path);
    self.view.backgroundColor = [UIColor whiteColor];
//    [self savePlistFile];
//    [self savePerence];
//    [self saveArchive];
    
    self.navigationItem.title = @"数据持久化";
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    btn.frame = CGRectMake(20, 80, 90, 40);
    [btn setTitle:@"数据库" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnClick:(UIButton *)sender
{
    DataBaseViewController *dataVC = [[DataBaseViewController alloc]init];
    [self.navigationController pushViewController:dataVC animated:YES];
}

#pragma mark -plist
- (void)savePlistFile
{
    //存储路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    path = [path stringByAppendingPathComponent:@"test.plist"];
    //存储
    NSArray *array = @[@"小红",@"小白",@"小黑"];
    [array writeToFile:path atomically:YES];
    
    //读取
    NSArray *result = [NSArray arrayWithContentsOfFile:path];
    NSLog(@"%@",result);
    
}

#pragma mark -NSUserDefault系统偏好设置(用来存储应用信息)

- (void)savePerence
{
    //1.获得NSUserDefaults文件
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //2.向文件中写入内容
    [userDefaults setObject:@"Database_Demo" forKey:@"APP_Name"];
    
    [userDefaults setObject:[[UIDevice currentDevice] systemName] forKey:@"IPhone_SystemName"];//设备名称
    [userDefaults setObject:[[UIDevice currentDevice] systemVersion] forKey:@"IPhone_Version"];//当前手机版本
    [userDefaults setObject:[[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleShortVersionString"] forKey:@"APP_Version"];//当前应用软件版本
    [userDefaults setObject:[[[UIDevice currentDevice] identifierForVendor]UUIDString] forKey:@"IPhone_UUId"];//设备唯一标识符
    //立即同步
    [userDefaults synchronize];
    //读取文件
    NSString *iphoneid = [userDefaults objectForKey:@"IPhone_UUId"];
    NSLog(@"%@",iphoneid);
    
}

#pragma mark -归档
- (void)saveArchive
{
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"person.data"];
    PersonModel *model = [[PersonModel alloc]init];
    model.name = @"卡卡";
    model.age = 9;
    model.demoArr = @[@"1",@"2",@"3"];
    [NSKeyedArchiver archiveRootObject:model toFile:filePath];
    
    //读取
    PersonModel *resultModel = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    NSLog(@"name=%@-----------arr=%@",resultModel.name,resultModel.demoArr);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
