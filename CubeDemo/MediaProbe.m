//
//  MediaProbe.m
//  CubeDemo
//
//  Created by guoqiangzhu on 15/7/29.
//  Copyright (c) 2015年 Cube Team. All rights reserved.
//

#import "MediaProbe.h"
#import "Cube.h"

@implementation MediaProbe

@synthesize delegate = _delegate;

- (void)onRemoteVideo:(MediaController *)mediaController withFps:(int)fps withAvgFps:(int)avgFps
{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(onVideoFps:)])
    {
        [_delegate onVideoFps:fps];
    }
}

@end
