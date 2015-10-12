//
//  CBUtils.m
//  CubeDemo
//
//  Created by Zhu on 15/5/18.
//  Copyright (c) 2015年 Cube Team. All rights reserved.
//

#import "CBUtils.h"

@implementation CBUtils

+ (NSString *)dateFromTimeStampMillis:(long long)timestamp withDateFormat:(NSString *)dateFormat
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp / 1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // HH是24进制，hh是12进制
    formatter.dateFormat = dateFormat;
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

+ (NSString *)dictionaryToJSON:(NSDictionary *)dic
{
    NSString *ret = nil;
    if ([NSJSONSerialization isValidJSONObject:dic])
    {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
        ret =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return ret;
}

+ (NSString *)arrayToJSON:(NSArray *)array
{
    DLog(@"array = %@", array);
    NSString *ret = nil;
    if ([NSJSONSerialization isValidJSONObject:array])
    {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
        ret =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return ret;
}

+ (id)parseJSON:(NSString *)jsonStr
{
    NSData *data= [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    return jsonObject;
    
}


+ (long long)timeStampMillsFromTime:(NSString *)time
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [formatter dateFromString:time];
    
    NSTimeInterval interval = [date timeIntervalSince1970] * 1000;
    
    return interval;
}

@end
