//
//  CDMMessageCell.h
//  CubeDemo
//
//  Created by jerny on 13-8-15.
//  Copyright (c) 2013年 yglh. All rights reserved.
//
//头像大小
#define HEAD_SIZE 50.0f
#define TEXT_MAX_HEIGHT 500.0f
//间距
#define INSETS 8.0f
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <UIKit/UIKit.h>
#import "CDMMessageObject.h"
#import "Cube.h"

@interface CDMMessageCell : UITableViewCell
{
    UIImageView *_userHead;
    UIImageView *_bubbleBg;
    UIImageView *_headMask;
//    UIImageView *_chatImage;
    UILabel *_messageConent;
    UILabel *_messageTimeStamp;
    
    UIButton *_voiceBtn;

    UILabel *progressLabel;
    
}
@property(nonatomic, strong) CDMMessageObject *messageObject;

@property (nonatomic, assign) int height;

@property (nonatomic,strong) UIButton *videoBtn;
@property (nonatomic,strong)UIImageView *loadingImage;
@property (nonatomic,strong) UIButton *chatImage;
//@property (nonatomic,strong)NSMutableArray *loadingArr;

@end
