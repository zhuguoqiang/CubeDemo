//
//  CubeAudioClipMessage.h
//  CubeEngine
//
//  Created by guoqiangzhu on 15/8/11.
//  Copyright (c) 2015年 Cube Team. All rights reserved.
//

#import "CubeFileMessage.h"

//! 用于发送或接收音频的音频消息类。
/*!
 * \author Zhu
 */

@interface CubeAudioClipMessage : CubeFileMessage

//!时长，单位秒
@property (nonatomic, assign) int duration;

//! 构造函数。
/*!
 * \param fileName 文件名, 不能为nil。
 * \param receiver 指定消息接收者。
 * \param sender 指定消息发送者。
 * \param file 指定待发送文件。
 */
- (id)initWithFile:(NSData *)file andFileName:(NSString *)fileName andReceiver:(Receiver *)receiver andSender:(Sender *)sender;

@end
