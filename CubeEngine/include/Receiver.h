//
//  Receiver.h
//  CubeEngine
//
//  Created by Zhu on 15/5/11.
//  Copyright (c) 2015年 Cube Team. All rights reserved.
//

#import "Peer.h"

//! 消息接收者类。
/*!
 * \author Zhu
 */
@interface Receiver : Peer

//! 显示名。
/*! 接收者显示名。
 */
@property (nonatomic, strong) NSString *displayName;

//! 构造函数。
/*!
 * \param name 指定接收者名称。
 */
- (id)initWithName:(NSString *)name;

/// \cond DE
- (NSDictionary *) toJSON;
/// \endcond


@end
