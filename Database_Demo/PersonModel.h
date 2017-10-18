//
//  PersonModel.h
//  Database_Demo
//
//  Created by 马金丽 on 17/10/17.
//  Copyright © 2017年 majinli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonModel : NSObject<NSCoding>

@property(nonatomic,copy)NSString *name;
@property(nonatomic,assign)NSInteger age;
@property(nonatomic,assign)NSInteger number;
@property(nonatomic,strong)NSArray *demoArr;
@end
