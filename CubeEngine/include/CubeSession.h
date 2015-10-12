//
//  CubeSession.h
//  Cube Engine
//
//  Created by Ambrose Xu on 14/9/28.
//  Copyright (c) 2014年 Cube Team. All rights reserved.
//

#ifndef CubeSession_h
#define CubeSession_h

#include "CubePrerequisites.h"

//! 协作交互时通信会话对象。
/*!
 * 每个会话表示一个可被管理的端到端的状态描述。
 * 可以从会话对象中获取关于本次会话相关的信息。
 */
@interface CubeSession : NSObject

//! 正在使用的音/视频通话对端。
@property (nonatomic, strong, readonly) CubeCallPeer *callPeer;

//! 己方（本地端）名称。
@property (nonatomic, strong, readonly) NSString *name;

//! 己方 （本地端） 显示名称。
@property (nonatomic, strong, readonly) NSString *displayName;

//! 己方的注册状态。
@property (nonatomic, assign, readonly) CubeRegistrationState registrationState;

//! 是否正在进行语音/视频通话。
@property (nonatomic, assign, readonly) BOOL calling;
//! 己方是否是主叫端。
@property (nonatomic, assign, readonly) BOOL initiated;
//! 己方通话时是否使用视频。
@property (nonatomic, assign, readonly) BOOL videoEnabled;
//! 当前通话的通话方向。
@property (nonatomic, assign, readonly) CubeCallDirection callDirection;

//! 本地视频视图。
@property (nonatomic, weak, readonly) UIView *localVideoView;
//! 远程视频视图。
@property (nonatomic, weak, readonly) UIView *remoteViewView;

//! 是否静音。
- (BOOL)isMuted;

//! 设置是否静音。
- (void)mute:(BOOL)muted;

@end

#endif
