//
//  CubeSlideEntity.h
//  CubeEngine
//
//  Created by guoqiangzhu on 15/9/24.
//  Copyright (c) 2015年 Cube Team. All rights reserved.
//

#import <Foundation/Foundation.h>

//! 幻灯片实体类。
/*!
 * 用于白板分享的幻灯片实体类。
 *
 * \author Zhu
 */
@interface CubeSlideEntity : NSObject

//! 幻灯片文件名
@property (nonatomic, strong) NSString *docName;

//! 幻灯片当前页
@property (nonatomic, assign) int currentPage;

//! 幻灯片总页数
@property (nonatomic, assign) int numsOfPage;

@end
