//
//  CubeLocalVideoView.h
//  CubeEngine
//
//  Created by Zhu on 15/6/5.
//  Copyright (c) 2015年 Cube Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CubePrerequisites.h"

//! 本地视频视图。
/*!
 *  用于显示本地摄像头采集的视频影像数据。
 *  \author Zhu
 */
@interface CubeLocalVideoView : UIView

//!
/*! 改变视频视图大小。
 *  \param frame 视图大小
 */
- (void)changeFrame:(CGRect)frame;

@end
