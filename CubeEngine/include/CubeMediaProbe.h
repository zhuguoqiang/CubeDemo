//
//  CubeMediaProbe.h
//  CubeEngine
//
//  Created by guoqiangzhu on 15/7/28.
//  Copyright (c) 2015年 Cube Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MediaController;

//! 媒体层探针接口。
/*! 
 *  媒体层探针用于实时监测媒体设备的工作状态。
 *  \author Zhu
 */
@interface CubeMediaProbe : NSObject

//!
/*!
 * 当远端视频帧率数据刷新时该方法被调用。
 */
- (void)onRemoteVideo:(MediaController *)mediaController withFps:(int)fps withAvgFps:(int)avgFps;

@end
