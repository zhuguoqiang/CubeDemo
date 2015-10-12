//
//  CubeTextMessage.h
//  CubeEngine
//
//  Created by Zhu on 15/5/8.
//  Copyright (c) 2015年 Cube Team. All rights reserved.
//

#import "MessageEntity.h"

//! 文本形式消息。
/*!
 * 用于发送文本形式的消息。
 *
 * \author Zhu
 */

@interface CubeTextMessage : MessageEntity

//! 消息内容
@property (nonatomic , strong) NSString *content;

//! 构造函数。
/*!
 * \param receiver 指定消息接收者。
 */
- (id)initWithReceiver:(Receiver *)receiver;

//! 构造函数。
/*!
 * \param receiver 指定消息接收者。
 * \param content 指定消息内容。
 */
- (id)initWithMessageContent:(NSString *)content andReceiver:(Receiver *)receiver;

@end
