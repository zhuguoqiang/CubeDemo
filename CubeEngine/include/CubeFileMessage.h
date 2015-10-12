//
//  CubeFileMessage.h
//  CubeEngine
//
//  Created by Zhu on 15/5/8.
//  Copyright (c) 2015年 Cube Team. All rights reserved.
//

#import "MessageEntity.h"
#import "Receiver.h"

//! 用于发送或接收文件的文件消息类。
/*!
 * \author Zhu
 */

@interface CubeFileMessage : MessageEntity

//! 文件数据
@property (nonatomic, strong) NSData *file;

//! 文件名
@property (nonatomic, strong) NSString *fileName;

//! 文件大小
@property (nonatomic, assign) long fileSize;

//! 最近修改时间（绝对时间）
@property (nonatomic, assign) long long lastModified;

//! 构造函数。
/*!
 * \param fileName 文件名, 不能为nil。
 * \param receiver 指定消息接收者。
 */
- (id)initWithFileName:(NSString *)fileName andReceiver:(Receiver *)receiver;

//! 构造函数。
/*!
 * \param fileName 文件名, 不能为nil。
 * \param receiver 指定消息接收者。
 * \param file 指定待发送文件。
 */
- (id)initWithFile:(NSData *)file andFileName:(NSString *)fileName andReceiver:(Receiver *)receiver;

//! 构造函数。
/*!
 * \param fileName 文件名, 不能为nil。
 * \param receiver 指定消息接收者。
 * \param sender 指定消息发送者。
 * \param file 指定待发送文件。
 */
- (id)initWithFile:(NSData *)file andFileName:(NSString *)fileName andReceiver:(Receiver *)receiver andSender:(Sender *)sender;

//! 构造函数。
/*!
 * \param fileName 文件名, 不能为nil。
 * \param receiver 指定消息接收者。
 * \param sender 指定消息发送者。
 * \param type  指定消息类型。
 * \param file 指定待发送文件。
 */
- (id)initWithFile:(NSData *)file andFileName:(NSString *)fileName andMessageType:(MessageType )type andReceiver:(Receiver *)receiver andSender:(Sender *)sender;

/// \cond DE
- (NSMutableDictionary *)toJSONObject;
/// \endcond


@end

