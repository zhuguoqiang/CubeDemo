//
//  CBUtils.h
//  CubeDemo
//
//  Created by Zhu on 15/5/18.
//  Copyright (c) 2015年 Cube Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBUtils : NSObject

+ (NSString *)dateFromTimeStampMillis:(long long)timestamp withDateFormat:(NSString *)dateFormat;

+ (NSString *)dictionaryToJSON:(NSDictionary *)dic;

+ (NSString *)arrayToJSON:(NSArray *)array;

+ (id)parseJSON:(NSString *)jsonStr;

+ (long long)timeStampMillsFromTime:(NSString *)time;

@end
