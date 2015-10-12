//
//  CubeCallPeer.h
//  Cube Engine
//
//  Created by Ambrose Xu on 15/1/27.
//  Copyright (c) 2015年 Cube Team. All rights reserved.
//

#ifndef CubeCallPeer_h
#define CubeCallPeer_h

#import "CubePeer.h"

//! 用于描述视频、语音通话对端的 Peer 类。
 /*!
  * \author Zhu
  */
@interface CubeCallPeer : CubePeer

//! 对端是否使用了视频呼叫。
/*!
 * 如果对端使用了视频则值为 \c YES ，否则值为 \c NO 。
 */
@property (nonatomic, assign, readonly) BOOL videoEnabled;

//! 浮点数形式对端视频纵横比
/*!
 * 此方法采用的计算公式为：ratio = width / height 。
 */
@property (nonatomic, assign) float aspectRatio;

@end

#endif
