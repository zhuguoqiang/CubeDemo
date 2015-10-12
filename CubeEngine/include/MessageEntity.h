//
//  MessageEntity.h
//  CubeEngine
//
//  Created by Zhu on 15/5/8.
//  Copyright (c) 2015年 Cube Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sender.h"
#import "Receiver.h"

//! 一般消息类型描述。
/*!
 * \author Zhu
 */
typedef enum _MessageType
{
    CUBE_MT_TEXT,       //!< 文本类型的消息。
    CUBE_MT_FILE,       //!< 文件类型的消息。
    CUBE_MT_IMAGE,      //!< 图片类型的消息。
    CUBE_MT_AUDIO,      //!< 音频类型的消息。
    CUBE_MT_VIDEO,      //!< 视频类型的消息。
    CUBE_MT_CUSTOM,     //!< 自定义消息。

    CUBE_MT_UNKNOWN     //!< 未知类型消息.
} MessageType;

//! 消息状态描述。
/*!
 * \author Zhu
 */
typedef enum _MessageStatus
{
    CREATE = 0, 			//!< 创建成功待发送。
    INPROGRESS = 1, 		//!< 发送/接收过程中。
    SUCCESS = 2, 		    //!< 成功。
    FAIL = -1       		//!< 失败。
} MessageStatus;


//! 消息实体类。
/*!
 * 消息实体类描述了一个可被有效管理的输出传输单元。
 * 该类是所有可被远程传输的消息对象的父类/基类。
 *
 * \author Zhu
 */

@interface MessageEntity : NSObject

//! 消息类型
@property (nonatomic, assign) MessageType messageType;

//! 消息状态
@property (nonatomic, assign) MessageStatus status;

//! 发件人
@property (nonatomic, strong) Sender *sender;

//! 发送时间
@property (nonatomic, assign) long long sendTime;

//! 接收人
@property (nonatomic, strong) Receiver *receiver;

//! 接收时间
@property (nonatomic, assign) long long receiveTime;

// ! 构造函数。
/*
 * ! \param type
 */
- (id)initWithMessageType:(MessageType )type;

// ! 构造函数。
/*
 * ! \param type \param receiver
 */
- (id)initWithMessageType:(MessageType)type andReceiver:(Receiver *)receiver;

// ! 构造函数。
/*
 * ! \param type \param receiver \param sender
 */
- (id)initWithMessageType:(MessageType)type andReceiver:(Receiver *)receiver andSender:(Sender *)sender;

/// \cond DE
 // timestamp 时间戳 : 毫秒
- (void)updateSender:(Sender *)sender withTime:(long long)timestamp;

// timestamp 时间戳 : 毫秒
- (void)updateReceiver:(Receiver *)receiver withTime:(long long)timestamp;

- (NSMutableDictionary *)toJSONObject;

+ (NSString *)stringWithMessageType:(MessageType)input;

+ (MessageType)parse:(NSString *)type;

/// \endcond

@end
