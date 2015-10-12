//
//  Sender.h
//  CubeEngine
//
//  Created by Zhu on 15/5/11.
//  Copyright (c) 2015年 Cube Team. All rights reserved.
//

#import "Peer.h"

//! 消息发送者类。
/*!
 * \author Zhu
 */
@interface Sender : Peer

//! 显示名。
/*! 发送者显示名。
 */
@property (nonatomic, strong) NSString *displayName;

//! 构造函数。
/*!
 * \param name 指定发送者名称。
 */
- (id)initWithName:(NSString *)name;

/// \cond DE
- (NSDictionary *) toJSON;
/// \endcond

@end
