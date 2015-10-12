//
//  MediaProbe.h
//  CubeDemo
//
//  Created by guoqiangzhu on 15/7/29.
//  Copyright (c) 2015年 Cube Team. All rights reserved.
//

#import "CubeMediaProbe.h"

@protocol MediaProbeDelegate <NSObject>

- (void)onVideoFps:(int)fps;

@end

@interface MediaProbe : CubeMediaProbe

@property (nonatomic, assign) id<MediaProbeDelegate> delegate;

@end
