//
//  CubeDelegate.h
//  Cube Engine
//
//  Created by Ambrose Xu on 14/9/28.
//  Copyright (c) 2014年 Cube Team. All rights reserved.
//

#ifndef CubeDelegate_h
#define CubeDelegate_h

#import "CubePrerequisites.h"

//! 注册状态委派。
/*!
 * 通过注册状态委派来监听引擎注册状态的变化。
 */
@protocol CubeRegistrationDelegate <NSObject>
@optional

//! 当注册流程正在处理时此方法被回调。
/*!
 * \param session 本次注册流程的会话对象实例。
 */
- (void)onRegistrationProgress:(CubeSession *)session;


//! 当注册成功时此方法被回调。
/*!
 * \param session 本次注册流程的会话对象实例。
 */
- (void)onRegistrationOk:(CubeSession *)session;


//! 当注册状态被清除时此方法被回调。
/*!
 * \param session 本次注册流程的会话对象实例。
 */
- (void)onRegistrationCleared:(CubeSession *)session;


//! 当注册流程发生错误时此方法被回调。
/*!
 * \param session 本次注册流程的会话对象实例。
 */
- (void)onRegistrationFailed:(CubeSession *)session;


//! 当注册状态实时维护进行网络数据心跳时此方法被回调。
/*!
 * \param session 本次注册流程的会话对象实例。
 */
- (void)onHeartbeat:(CubeSession *)session;

@end



//! 呼叫状态委派。
/*!
 * 通过指定呼叫状态委派来监听呼叫状态，从而发起对应的操作。
 *
 * 此委派可以收到的监听事件涵盖了呼叫会话的所有环节。
 */
@protocol CubeCallDelegate <NSObject>
@optional

//! 当引擎发起或收到新呼叫时此方法被回调。
/*!
 * \param callDirection 本次呼叫的方向。
 * \param session 本次呼叫的会话。
 * \sa CubeCallDirection
 */
- (void)onNewCall:(CubeCallDirection)callDirection session:(CubeSession *)session;


//! 当呼叫正在处理时此方法被回调。
/*!
 * \param session 本次呼叫的会话。
 */
- (void)onInProgress:(CubeSession *)session;


//! 当对方振铃时此方法被回调。
/*!
 * \param session 本次呼叫的会话。
 */
- (void)onCallRinging:(CubeSession *)session;


//! 当呼叫已经接通时此方法被回调。
/*!
 * \param session 本地呼叫的会话。
 */
- (void)onCallConnected:(CubeSession *)session;


//! 当呼叫结束时此方法被回调。
/*!
 * \param session 本次呼叫的会话。
 */
- (void)onCallEnded:(CubeSession *)session;

//! 当呼叫过程发生错误时此方法被回调。
/*!
 * \param session 本次呼叫的会话。
 * \param errorCode 发生错误时导致呼叫失败的错误码。
 * \sa CubeCallErrorCode
 */
- (void)onCallFailed:(CubeSession *)session errorCode:(CubeCallErrorCode)errorCode;

@end

//! 实时媒体状态委派。
/*!
 * 通过实现媒体委派可以监听到媒体状态。
 */
@protocol CubeMediaDelegate <NSObject>
@optional

//! 当呼叫过程中媒体状态发生改变时此方法被回调。
/*!
 * \param state 媒体状态。
 * \sa CubeMediaState
 */
- (void)onMediaStateChanged:(CubeMediaState)state;

@end

//! 白板委派。
/*!
 * 通过实现白板委派可以监听到白板。
 */

@protocol CubeWhiteboardDelegate <NSObject>
@optional

//! 当白板加载完成时此方法被回调。
/*!
 * \param whiteboard 当前有效的白板。
 *
 */
- (void)onReady:(CubeWhiteboard *)whiteboard;

//! 当白板分享时此方法被回调。
/*!
 * \param whiteboard 当前有效的白板。
 * \param sharedList 分享成员列表。
 *
 */
- (void)onShared:(CubeWhiteboard *)whiteboard andSharedList:(NSArray *)sharedList;

//! 当白板分享文件时此方法被回调。
/*!
 * \param whiteboard 当前有效的白板。
 * \param file 分享文件信息。
 */
- (void)onFileShared:(CubeWhiteboard *)whiteboard andFile:(CubeSharedFile *)file;

//! 当白板分享文件时此方法被回调。
/*! 文件处理进度。
 * \param whiteboard 当前有效的白板。
 * \param process 处理进度。
 */
- (void)onFileSharing:(CubeWhiteboard *)whiteboard andProgress:(NSString *)progress;

//! 当白板分享ppt过程中此方法被回调。
/*!
 * \param whiteboard 当前有效的白板。
 * \param slide 幻灯片实体信息。
 *
 */
- (void)onWhiteboard:(CubeWhiteboard *)whiteboard andSlide:(CubeSlideEntity *)slide;

//! 当白板停止分享此方法被回调。
/*!
 * \param whiteboard 当前有效的白板。
 *
 */
- (void)onRevoke:(CubeWhiteboard *)whiteboard;

//! 当白板分享过程发生错误时此方法被回调。
/*!
 * \param whiteboard 当前有效的白板。
 * \param errorCode 发生错误时导致分享失败的错误码。
 *
 */
- (void)onFailed:(CubeWhiteboard *)whiteboard andErrorCode:(CubeWBErrorCode)errorCode;

@end

//! 实时消息状态委派。
/*!
 * 通过实现消息委派可以监听到消息的收发状态。
 */
@protocol CubeMessagingDelegate <NSObject>
@optional

//! 当指定的消息已发送时此方法被回调。
/*!
 * \param session 当前有效的会话。
 * \param message 当前发送的消息实例。
 */
- (void)onSent:(CubeSession *)session withMessageEntity:(MessageEntity *)message;

//! 当指定的文本消息已发送时此方法被回调。
/*!
 * \param session 当前有效的会话。
 * \param message 当前发送的消息实例。
 */
//- (void)onSent:(CubeSession *)session withTextMessage:(CubeTextMessage *)message;


//! 当指定的文件消息已发送时此方法被回调。
/*!
 * \param session 当前有效的会话。
 * \param message 当前发送的消息实例。
 */
//- (void)onSent:(CubeSession *)session withFileMessage:(CubeFileMessage *)message;

//! 当接收到消息时此方法被回调。
/*!
 * \param session 当前有效的会话。
 * \param message 当前收到的消息实例。
 */
- (void)onReceived:(CubeSession *)session withMessageEntity:(MessageEntity *)message;
//! 当接收到文本消息时此方法被回调。
/*!
 * \param session 当前有效的会话。
 * \param message 当前收到的消息实例。
 */
//- (void)onReceived:(CubeSession *)session withTextMessage:(CubeTextMessage *)message;


//! 当查询历史消息时此方法被回调。
/*!
 * \param messages 历史消息集合
 * \param begin 开始时间
 * \param end 结束时间
 */
- (void)onReceiveMessageHistory:(NSArray *)messages begin:(long long)begin end:(long long)end;

//! 当查询用户状态时此方法被回调。
/*!
 *
 * \param states 用户状态
 * \param
 */
- (void)onReceivedRemoteAcountsState:(NSArray *)states;

/// \cond DE

//! 当接收到文件消息时此方法被回调。
/*!
 * \param session 当前有效的会话。
 * \param message 当前收到的消息实例。
 */
//- (void)onReceived:(CubeSession *)session withFileMessage:(CubeFileMessage *)message;


/// \endcond

//! 显示发送文件进度时此方法被回调。
/*!
 *
 * \param session     当前有效的会话。
 * \param fileMessage 当前收到的消息实例。
 * \param processed   文件传输进度。
 * \param total       文件总大小。
 */
//- (void)onSendProgress:(CubeSession *)session withFileMessage:(CubeFileMessage *)fileMessage withProcessed:(long)processed withTotal:(long)total;
- (void)onSendProgress:(CubeSession *)session withMessageEntity:(MessageEntity *)message withProcessed:(long)processed withTotal:(long)total;

//! 文件发送完成时此方法被回调。
/*!
 *
 * \param session     当前有效的会话。
 * \param fileMessage 当前收到的消息实例。
 */
//- (void)onSendCompleted:(CubeSession *)session withFileMessage:(CubeFileMessage *)fileMessage;
- (void)onSendCompleted:(CubeSession *)session withMessageEntity:(MessageEntity *)message;

//! 显示接收文件进度时此方法被回调。
/*!
 *
 * \param session     当前有效的会话。
 * \param fileMessage 当前收到的消息实例。
 * \param processed   文件传输进度。
 * \param total       文件总大小。
 */
//- (void)onReceiveProgress:(CubeSession *)session withFileMessage:(CubeFileMessage *)fileMessage withProcessed:(long)processed withTotal:(long)total;
- (void)onReceiveProgress:(CubeSession *)session withMessageEntity:(MessageEntity *)message withProcessed:(long)processed withTotal:(long)total;

//! 文件接收完成时此方法被回调。
/*!
 *
 * \param session     当前有效的会话。
 * \param fileMessage 当前收到的消息实例。
 */
//- (void)onReceiveCompleted:(CubeSession *)session withFileMessage:(CubeFileMessage *)fileMessage;
- (void)onReceiveCompleted:(CubeSession *)session withMessageEntity:(MessageEntity *)message;

//! 当消息处理失败时此方法被回调。
/*!
 * \param session 当前有效的会话。
 * \param errorCode 发生错误时的错误代码。
 * \param message 发生错误时正在处理的消息。
 */
- (void)onMessageFailed:(CubeSession *)session withMessageErrorCode:(CubeMessageErrorCode)errorCode withMessageEntity:(MessageEntity *)message;
//! 当消息处理失败时此方法被回调。
/*!
 * \param session 当前有效的会话。
 * \param errorCode 发生错误时的错误代码。
 * \param message 发生错误时正在处理的消息。
 */
//- (void)onMessageFailed:(CubeSession *)session withMessageErrorCode:(CubeMessageErrorCode)errorCode withTextMessage:(CubeTextMessage *)message;


/// \cond DE

//! 当消息处理失败时此方法被回调。
/*!
 * \param session 当前有效的会话。
 * \param errorCode 发生错误时的错误代码。
 * \param message 发生错误时正在处理的消息。
 */
//- (void)onMessageFailed:(CubeSession *)session withMessageErrorCode:(CubeMessageErrorCode)errorCode withFileMessage:(CubeFileMessage *)message;


/// \endcond

@end


#endif
