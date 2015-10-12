//
//  CubePeer.h
//  Cube Engine
//
//  Created by Ambrose Xu on 14/10/6.
//  Copyright (c) 2014年 Cube Team. All rights reserved.
//

#ifndef CubePeer_h
#define CubePeer_h

#include "CubePrerequisites.h"

//! 引擎协作对端描述基类。
/*!
 * 每个 Peer 表示一个有效被管理的协作对端。
 * 通过 Peer 可以获得对端的相关信息。
 * \author Zhu
 */
@interface CubePeer : NSObject

//! 对端的名称。
@property (nonatomic, strong, readonly) NSString *name;

//! 对端显示名称
@property (nonatomic, strong) NSString *displayName;

//! 指定名称构造对端。
- (id)initWith:(NSString *)name;

@end

#endif
