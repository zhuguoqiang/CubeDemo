//
//  CubeEngine.h
//  Cube Engine
//
//  Created by Ambrose Xu on 14/9/28.
//  Copyright (c) 2014年 Cube Team. All rights reserved.
//

#ifndef CubeEngine_h
#define CubeEngine_h

#include "CubePrerequisites.h"

@class MediaController;


//! 魔方引擎核心 API 入口对象。
/*!
 * 此对象是魔方引擎的核心对象，且为单例模式。
 * 应用程序通过该对象来完成所需的协作功能。
 * 这些功能包括视频、语音对话，即时消息，白板，短音频等。
 *
 * 引擎的生命周期控制管理接口都通过该对象的方法进行维护。
 *
 * \author Ambrose Xu
 */
@interface CubeEngine : NSObject


//! 返回 CubeEngine 单例。
/*!
 * \return 返回 CubeEngine 单例指针。
 */
+ (CubeEngine *)sharedSingleton;


//! 注册状态委派。
@property (nonatomic, assign) id<CubeRegistrationDelegate> registrationDelegate;

//! 音/视频通话状态委派。
@property (nonatomic, assign) id<CubeCallDelegate> callDelegate;

//! 即时消息状态委派。
@property (nonatomic, assign) id<CubeMessagingDelegate> messagingDelegate;

//! 即时媒体状态委派。
@property (nonatomic, assign) id<CubeMediaDelegate> mediaDelegate;

//! 白板状态委派。
@property (nonatomic, assign) id<CubeWhiteboardDelegate> whiteboardDelegate;

//! 引擎是否已经启动。
@property (nonatomic, assign, readonly) BOOL started;

//! 当前有效的会话实例。
@property (nonatomic, strong, readonly) CubeSession *session;

//! 媒体控制器
@property (nonatomic, strong, getter=getMediaController) MediaController *mediaController;

//! 智能白板
@property (nonatomic, strong, getter=getWhiteboard) CubeWhiteboard *whiteboard;

//! 本地视频视图。
@property (nonatomic, strong, readonly) CubeLocalVideoView *localVideoView;

//! 远程视频视图。
@property (nonatomic, strong, readonly) CubeRemoteVideoView *remoteVideoView;

//! 当前生效的配置实例。
@property (nonatomic, strong, readonly) CubeConfig *config;


//! 启动引擎，引擎完成初始化操作。
/*!
 * 此方法用于启动引擎，将引擎置为工作状态。
 * 调用该方法后引擎将完成各种初始化工作。
 *
 * \note 此方法必须在 UI 线程中调用。
 *
 * \param appId 指定在魔方开发者中心申请的应用程序的 ID 。
 * \param appKey 指定和应用程序 ID 匹配的应用程序的标识 Key 。
 * \return 返回魔方引擎是否启动成功。如果返回 \c YES 则表示引擎启动成功，否则表示引擎启动失败。
 */
- (BOOL)startup:(NSString *)appId appKey:(NSString *)appKey;


//! 停止引擎，引擎停止所有工作，并释放内存。
/*!
 * 此方法用于停止引擎，将引擎置为关闭状态。
 * 调用该方法后引擎将关闭各项功能，并释放内存。
 *
 * \note 此方法必须在 UI 线程中调用。
 */
- (void)shutdown;

//! 加载信令，完成信令初始化工作
/*! 此方法用于加载信令。
 *  调用该方法后信令完成各种初始化工作。
 *
 * \note 此方法必须在 UI 线程中调用。
 */
- (void)loadSignaling;

//! 加载会议模块，完成会议模块初始化工作
/*! 此方法用于加载会议模块。
 *  调用该方法后会议模块各种初始化工作。
 *
 * \note 此方法必须在 UI 线程中调用。
 */
- (void)loadConference;

//! 卸载信令，完成信令初始化工作
/*! 此方法用于卸载信令。
 *  调用该方法后信令停止工作。
 *
 * \note 此方法必须在 UI 线程中调用。
 */
- (void)unloadSignaling;

//! 暂停引擎工作。
/*!
 * 暂停引擎工作时，引擎会暂停所有正在进行的实时协作操作。
 *
 * \c UIApplicationDelegate#applicationWillResignActive 被回调时应当调用该方法。
 */
- (void)pause;


//! 恢复引擎工作。
/*!
 * 恢复引擎时，引擎会恢复到工作状态。
 * 
 * \c UIApplicationDelegate#applicationDidBecomeActive 被回调时应当调用该方法。
 */
- (void)resume;


//! 引擎进入后台运行。
/*!
 * \c UIApplicationDelegate#applicationDidEnterBackground 被回调时调用该方法。
 */
- (void)enterBackground;


//! 引擎进入前台运行。
/*!
 * \c UIApplicationDelegate#applicationWillEnterForeground 被回调时调用该方法。
 */
- (void)enterForeground;


//! 对引擎进行指定的参数配置。
/*!
 * \param config 指定配置参数对象。
 */
- (void)configure:(CubeConfig *)config;


//! 注册账号。
/*!
 * 每个应用程序通过注册账号来标识唯一终端。
 * 在调用其他 API 前都应当先使用一个已知账号执行注册操作。
 *
 * \param name 指定注册名。
 * \param password 指定注册名对应的密码。
 * \param displayName 指定显示姓名
 * \return 如果执行注册成功，则返回 \c YES ，否则返回 \c NO 。当执行失败时，应用程序应当检测网络连接状态。
 *
 * \note 该方法是异步执行方法，返回值表示方法是否被成功执行，不表示注册是否成功。
 */
- (BOOL)registerAccount:(NSString *)name password:(NSString *)password displayName:(NSString *)displayName;;


//! 注销账号。
/*!
 * \return 如果执行注销成功，则返回 \c YES ，否则返回 \c NO 。
 *
 * \note 该方法是异步执行方法，返回值表示方法是否被成功执行，不表示注销是否成功。
 */
- (BOOL)unregisterAccount;


//! 向指定号码的对端发起视频、语音呼叫。
/*!
 *
 * \note 此方法必须在 UI 线程中调用。
 *
 * \param callee 指定对端号码。
 * \param videoEnabled 指定是否使用视频通话。
 * \return 如果呼叫发起成功则返回 \c YES ，否则返回 \c NO 。
 */
- (BOOL)makeCall:(NSString *)callee videoEnabled:(BOOL)videoEnabled;


//! 应答对端发起的视频、语音呼叫。
/*!
 *
 * \note 此方法必须在 UI 线程中调用。
 *
 * \param videoEnabled 指定是否使用视频方法进行应答。
 * \return 如果应答被成功执行则返回 \c YES ，否则返回 \c NO 。
 */
- (BOOL)answerCall:(BOOL)videoEnabled;


//! 终止或拒绝呼叫。
/*!
 *
 * \note 此方法必须在 UI 线程中调用。
 *
 * \return 如果终止呼叫被成功执行则返回 \c YES ，否则返回 \c NO 。
 */
- (BOOL)terminateCall;

//! 判断本地音频是否已关闭。
/*!
 * \return 已关闭，则返回 \c，YES, 否则返回 \c NO。
 */
- (BOOL)isVoiceEnabled;

//! 打开本地音频。
/*!
 * 在通话时，调用该方法后可以打开本地音频。
 */

- (void)openVoice;

//! 关闭本地音频。
/*!
 * 在通话时，调用该方法后可以关闭本地音频。
 */
- (void)closeVoice;

//! 判断本地视频是否已关闭。
/*!
 * \return 已关闭，则返回 \c，YES, 否则返回 \c NO。
 */
- (BOOL)isVideoEnabled;

//! 打开本地视频。
/*!
 * 在通话时，调用该方法后可以打开本地视频。
 */
- (void)openVideo;

//! 关闭本地视频。
/*!
 * 在通话时，调用该方法后可以关闭本地视频。
 */
- (void)closeVideo;

//! 切换摄像头。
/*!
 * 在通话时，调用该方法后可以切换摄像头。
 */
- (void)switchCamera;

//! 发送指定的文本消息。
/*!
 * \param message 指定待发送的文本消息对象。
 * \return 如果消息被引擎正确处理则返回 \c YES ，否则返回 \c NO 。
 */
- (BOOL)sendTextMessage:(CubeTextMessage *)message;

//! 查询历史消息。
/*!
 * \return 如果历史消息查询被引擎正确处理则返回 \c YES ，否则返回 \c NO 。
 */
- (BOOL)queryMessageHistoryBegin:(long long)begin withEnd:(long long)end;

//! 查询用户状态。
/*!
 * \param acounts 用户账号
 * \param callback  回调
 * \return 如果用户状态查询被引擎正确处理则返回 \c YES ，否则返回 \c NO 。
 * \deprecated since version 1.3.3
 */
- (BOOL)queryRemoteAccounts:(NSArray *)acounts callBack:(void (^)(NSArray *array))callback;

//! 查询用户状态。
/*!
 * \param acounts 用户账号
 * \param callback  回调
 * \return 如果用户状态查询被引擎正确处理则返回 \c YES ，否则返回 \c NO 。
 */
- (BOOL)queryAccounts:(NSArray *)acounts callBack:(void (^)(NSArray *array))callback;

//! 发送指定的文件消息。
/*!
 * \param message 指定待发送的文件消息对象。
 * \return 如果消息被引擎正确处理则返回 \c YES ，否则返回 \c NO 。
 */
- (BOOL)sendFileMessage:(CubeFileMessage *)message;

//! 同意并接收来自服务器的指定文件消息内的文件。
/*!
 * \param message 指定文件消息。
 * \return 如果该操作被引擎正确处理则返回 \c YES ，否则返回 \c NO 。
 */
- (BOOL)acceptFileMessage:(CubeFileMessage *)message;

//! 决绝并终止来自服务器的指定文件消息内的文件。
/*!
 * \param message 指定文件消息。
 * \return 如果该操作被引擎正确处理则返回 \c YES ，否则返回 \c NO 。
 */
- (BOOL)rejectFileMessage:(CubeFileMessage *)message;

//! 返回未被处理的消息。
/*!
 * \return 返回为被处理的消息列表。
 */
- (NSArray *)getPendingFileMessages;

//! 智能白板模块。
/*! 加载智能白板模块。
 */
- (void)loadWhiteboard;

//! 发送指定的自定义消息。
/*!
 * \param message 指定待发送的自定义消息对象。
 * \return 如果消息被引擎正确处理则返回 \c YES ，否则返回 \c NO 。
 */
- (BOOL)sendCustomMessage:(CubeCustomMessage *)message;



/// \cond DE
/// \endcond
@end

#endif
