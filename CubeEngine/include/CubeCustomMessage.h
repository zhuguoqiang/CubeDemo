//
//  CubeCustomMessage.h
//  CubeEngine
//
//  Created by guoqiangzhu on 15/9/18.
//  Copyright (c) 2015年 Cube Team. All rights reserved.
//

#import "MessageEntity.h"

//! 用于发送或接收自定义消息类。
/*!
 * \author Zhu
 */

@interface CubeCustomMessage : MessageEntity

//! 消息头
@property (nonatomic, strong) NSMutableDictionary *header;

//! 消息体
@property (nonatomic, strong) NSString *body;

//! 构造函数。
/*!
 * \param receiver 指定消息接收者。
 */
- (id)initWithReceiver:(Receiver *)receiver;

@end
