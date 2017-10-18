//
//  PersonModel.m
//  Database_Demo
//
//  Created by 马金丽 on 17/10/17.
//  Copyright © 2017年 majinli. All rights reserved.
//

#import "PersonModel.h"

@implementation PersonModel

//解档
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if ([super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.age = [aDecoder decodeIntegerForKey:@"age"];
        self.demoArr = [aDecoder decodeObjectForKey:@"demoArr"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.demoArr forKey:@"demoArr"];
    [aCoder encodeInteger:self.age forKey:@"age"];
}


@end
