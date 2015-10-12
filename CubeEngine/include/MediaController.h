//
//  MediaController.h
//  CubeEngine
//
//  Created by Zhu on 15/6/10.
//  Copyright (c) 2015年 Cube Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CubeMediaProbe.h"
#include "CubePrerequisites.h"

//! 媒体控制器。
/*!
 * 用于操作媒体设备。
 *
 * \author Zhu
 */

@interface MediaController : NSObject

//!录制视频视图
@property (nonatomic,strong,readonly)CubeRecordVideoView *recordView;

//!播放视频视图
@property (nonatomic,strong,readonly)CubePlayVideoView *playView;

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
- (void)openVideoWithConsult:(BOOL)consult;

//! 关闭本地视频。
/*!
 * 在通话时，调用该方法后可以关闭本地视频。
 */
- (void)closeVideoWithConsult:(BOOL)consult;

//! 切换摄像头。
/*!
 * 在通话时，调用该方法后可以切换摄像头。
 */
- (void)switchCamera;

//! 添加媒体探针。
/*! 添加媒体探针。
 */
- (void)addMediaProbe:(CubeMediaProbe *)probe;

//! 删除媒体探针。
/*! 删除媒体探针。
 */
- (void)removeMediaProbe:(CubeMediaProbe *)probe;

//! 是否正在录制音频
/*! 是否正在录制音频
 *
 */
- (BOOL)isVoiceRecording;

//! 启动语音录制。
/*!
 * \param duration 指定本次录音的最大时长, 1 ~ 60s。
 * \return 如果录音被启动则返回 \c YES ，否则返回 \c NO 。
 */
- (BOOL)startRecordVoice:(long)duration;

//! 停止语音录制。
/*!
 * \return 如果录音被停止则返回 \c YES ，否则返回 \c NO 。
 */
- (BOOL)stopRecordVoice;

//! 取消语音录制。
/*!
 *
 */
- (void)cancelRecordVoice;

//! 获取录制的语音文件地址
/*!
 */
- (NSString *)getVoiceFilePath;

//!播放录制的语音
/*!
 * \param path 录制的语音文件路径
 */
- (void)playRecordVoice:(NSString *)path;

//!停止播放录制的语音
/*!
 */
- (void)stopPlayRecordVoice;

/// \cond DE
//! 启动视频录制。
/*!
 * \param duration 指定本次录制视频的最大时长, 1 ~ 30s。
 * \return 如果视频录制成功启动则返回 \c YES ，否则返回 \c NO 。
 */
- (BOOL)startRecordVideo:(NSTimeInterval)duration;

//! 停止视频录制。
/*!
 * \return 如果视频录制停止则返回 \c YES ，否则返回 \c NO 。
 */
- (BOOL)stopRecordVideo;

//! 取消视频录制。
/*!
 *
 */
- (void)cancelRecordVideo;

//! 是否正在录制视频
/*! 是否正在录制视频
 *
 */
- (BOOL)isVideoRecording;

//! 获取录制的视频文件地址
/*!
 */
- (NSString *)getVideoFilePath;


//! 停止本地音视频录制
/*! 停止本地音视频录制
 *
 */

//!录制视频前先传一个接受者的名字
/*
 
 */
- (void)loadRecordVideoViewWithReceiverName:(NSString *)name;

//!播放视频的URL
- (void)loadPlayVideoViewWithPlayURL:(NSString *)url;

//!播放录制的视频
/*!
 * \param path 录制的视频文件路径
 */
- (void)playRecordedVideo:(NSString *)path;

//!停止播放录制的视频
/*!
 */
- (void)stopPlayRecordedVideo;
///condEnd
@end
