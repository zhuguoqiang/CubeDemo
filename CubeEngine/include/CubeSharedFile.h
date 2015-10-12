//
//  CubeSharedFile.h
//  CubeEngine
//
//  Created by guoqiangzhu on 15/9/24.
//  Copyright (c) 2015年 Cube Team. All rights reserved.
//

#import <Foundation/Foundation.h>
//! 共享文件类。
/*!
 * 用于白板共享的文件类。
 *
 * \author Zhu
 */
@interface CubeSharedFile : NSObject

//! 文件ID
@property (nonatomic, assign) long fileId;

//! 账号
@property (nonatomic, strong) NSString *acount;

//! 原始文件名
@property (nonatomic, strong) NSString *originFileName;

//! 文件别名
@property (nonatomic, strong) NSString *aliasFileName;

//! 文件长度
@property (nonatomic, assign) long length;

//! 文件
@property (nonatomic, strong) NSData *data;

//! 文件分享地址
@property (nonatomic, strong) NSArray *urls;

@end
