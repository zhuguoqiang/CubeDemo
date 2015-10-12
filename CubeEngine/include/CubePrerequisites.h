//
//  CubePrerequisites.h
//  Cube Engine
//
//  Created by Ambrose Xu on 14/9/28.
//  Copyright (c) 2014年 Cube Team. All rights reserved.
//

#ifndef CubePrerequisites_h
#define CubePrerequisites_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class CubeEngine;
@class CubeSession;
@class CubePeer;
@class CubeCallPeer;
@class CubeVideoView;
@class CubeLocalVideoView;
@class CubeRemoteVideoView;
@class CubeConfig;
@class CubeTextMessage;
@class CubeFileMessage;
@class CubeWhiteboard;
@class CubePlayVideoView;
@class CubeRecordVideoView;
@class CubeCustomMessage;
@class MessageEntity;
@class CubeSharedFile;
@class CubeSlideEntity;

/*! 引擎接口定义。
 */
@interface Cube : NSObject


//! 注册状态枚举。
/*!
 * 当执行注册流程时，引擎通过委派机制向应用程序通知注册状态。
 * 通过获知注册状态，应用程序开发者可以及时了解到用户使用帐号的注册状态。
 */
typedef enum _CubeRegistrationState {
    CubeRegistrationNone,       //!< 引擎初始化时使用的状态，表示没有执行过注册流程。
    CubeRegistrationProgress,   //!< 正在处理注册状态。
    CubeRegistrationOk,         //!< 注册成功状态。
    CubeRegistrationCleared,    //!< 成功清理注册状态。
    CubeRegistrationFailed      //!< 注册失败。
} CubeRegistrationState;


//! 通话呼叫方向枚举。
/*!
 * 视频/语音通话呼叫方向，即主、被叫枚举。
 * 应用程序可根据此判断呼叫时的通话方向。
 */
typedef enum _CubeCallDirection {
    CubeCallOutgoing = 1 << 0,  /*!< 主叫呼出，呼叫方向为呼出。 */
    CubeCallIncoming = 1 << 1,  /*!< 被叫呼入，呼叫方向为呼入。 */
    CubeCallNone = 0            /*!< 表示呼叫方向未定义。 */
} CubeCallDirection;

//! 媒体状态枚举。
/*!
 * 媒体状态枚举。
 */
typedef enum _CubeMediaState {
    CubeAudioOpened = 2001, //!< 音频开启
    CubeAudioClosed = 2000, //!< 音频关闭
    CubeVideoOpened = 1001, //!< 视频开启
    CubeVideoClosed = 1000  //!< 视频关闭
} CubeMediaState;


//! 通话呼叫错误码定义。
/*!
 * 通话呼叫错误码定义。
 */
typedef enum _CubeCallErrorCode {
    CubeCallErrorBadRequest = 400,              //!< 请求无效。
    CubeCallErrorUnauthorized = 401,            //!< 未授权请求。
    CubeCallErrorPaymentRequired = 402,
    CubeCallErrorForbidden = 403,               //!< 服务器无法识别请求。
    CubeCallErrorNotFound = 404,                //!< 服务器没有找到对应的请求 URI 。
    CubeCallErrorMethodNotAllowed = 405,        //!< 请求指定的方法服务器不允许执行。
    CubeCallErrorProxyAuthenticationRequired = 407, //!< 代理需要授权。
    CubeCallErrorRequestTimeout = 408,          //!< 客户端的请求超时。
    CubeCallErrorUnsupportedMediaType  = 415,   //!< 不支持的媒体类型。
    CubeCallErrorRequestSendFailed = 477,       //!< 请求数据发送失败。
    CubeCallErrorTemporarilyUnavailable = 480,  //!< 临时不可用。
    CubeCallErrorBusyHere = 486,                //!< 线路正忙。
    CubeCallErrorRequestTerminated = 487,       //!< 对方未接听。
    CubeCallErrorServerInternalError = 500,     //!< 服务器内部错误。
    CubeCallErrorDoNotDisturb = 600,            //!< 勿扰模式。
    CubeCallErrorDeclined = 603,                //!< 拒绝请求。

    CubeCallErrorConnectionFailed = 700,        //!< 连接失败。
    CubeCallErrorSIPError = 701,                //!< SIP 错误。
    CubeCallErrorTransportError = 702,          //!< 信令链路传输数据错误。
    CubeCallErrorICEConnectionFailed = 703,     //!< ICE 连接失败。
    CubeCallErrorCreateSessionDescriptionFailed = 705,  //!< 创建 SDP 失败。
    CubeCallErrorSetSessionDescriptionFailed = 706,     //!< 设置 SDP 失败。
    CubeCallErrorDuplicationException = 801,    //!< 正在呼叫时，新呼叫进入。
    CubeCallErrorWorkerStateException = 802,    //!< 工作机状态异常。
    CubeCallErrorCallTimeout = 804,             //!< 呼叫超时。
    CubeCallErrorNetworkNotReachable = 809,     //!< 网络不可达。

    CubeCallErrorCameraOpenFailed = 901,        //!< 摄像头开启失败。

    CubeCallErrorUnknown = 0                    //!< 未知的错误发生。
} CubeCallErrorCode;

//! 消息错误码定义。
/*!
 * 消息错误码定义。
 */
typedef enum _CubeMessageErrorCode{
    BadRequest = 400,			//!< 请求无效。
    ConnectionTimeout = 401,	//!< 建立连接超时。
    BlockOversize = 403,		//!< 消息缓存块大小超限。
    FormatError = 404,			//!< 消息格式错误。
    ContentError = 405,			//!< 消息内容错误。
    OutOfLimit = 406,			//!< 消息内容参数越限，比如文件大小越限。
    NoReceiver = 407,			//!< 消息没有接收人。
    RequestTimeout = 408,		//!< 请求超时。
    RequestTerminated = 487,	//!< 请求终止。
    
    Declined = 603,				//!< 被拒绝。
    
    ServerInternalError = 500,	//!< 服务器发生内存错误。
    ServiceUnavailable = 503,	//!< 当前执行的无法不可用。
    GatewayTimeout = 504,		//!< 网关超时。
    
    Unknown = 0                 //!< 未知的错误发生。
} CubeMessageErrorCode;

//! 文件分享错误码定义。
/*!
 * 文件分享错误码定义。
 */
typedef enum _CubeWBErrorCode {
    LostAssets = 820,    //!< 丢失资源文件。
    UploadFailed = 823,  //!< 上传文件失败。
    ProcessFailed = 825, //!< 处理文件失败。
    UnkownError = 0         //!< 未知的错误发生。
} CubeWBErrorCode;

//! 返回魔方引擎的版本信息。
/*!
 * 引擎版本信息包括主版本号、副版本号和修订号。
 *
 * \return 返回字符串形式的版本描述信息。
 */
+ (NSString *)versionDescription;

@end


#import "CubeDelegate.h"
#import "CubeConfig.h"

#endif
