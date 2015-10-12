//
//  CubeImageMessage.h
//  CubeEngine
//
//  Created by guoqiangzhu on 15/8/11.
//  Copyright (c) 2015年 Cube Team. All rights reserved.
//

#import "CubeFileMessage.h"

//! 用于发送或接收图片的图片消息类。
/*!
 * \author Zhu
 */

@interface CubeImageMessage : CubeFileMessage

@property (nonatomic, strong) NSData *thumbFile;

//! 构造函数。
/*!
 * \param fileName 文件名, 不能为nil。
 * \param receiver 指定消息接收者。
 * \param sender 指定消息发送者。
 * \param file 指定待发送文件。
 */
- (id)initWithFile:(NSData *)file andFileName:(NSString *)fileName andReceiver:(Receiver *)receiver andSender:(Sender *)sender;

//! 设置图片大小。
/*!
 * \param w 宽度。
 * \param h 高度。
 */
- (void)setImageWidth:(int)w andHeight:(int)h;

@end
