//
//  CDMMessageObject.h
//  CubeDemo
//
//  Created by jerny on 10/22/14.
//  Copyright (c) 2014 yglh. All rights reserved.
//
typedef enum {
    KMessageCellStyleMe = 0,
    KMessageCellStyleOther = 1,
    KMessageCellStyleMeWithImage=2,
    KMessageCellStyleOtherWithImage=3,
    KMessageCellStyleMeWithVoice=4,
    KMessageCellStyleOtherWithVoice=5,
    kmessagecellstyleMeWithVideo=6,
    kmessagecellstyleOtherWithVideo=7,
    KMessageCellStyleTimeStamp = 8,
    KMessageCellStyleSendFile = 9,
    KMessageCellStyleReceiveFile = 10
} KMessageCellStyle;

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CDMMessageObject : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, assign) KMessageCellStyle msgStyle;
@property (nonatomic, strong) NSString *timeStamp;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *_voiceBtn;
@property (nonatomic,strong) NSString *fileName;
@property (nonatomic, strong) NSData *fileData;
//@property (nonatomic, strong) NSData *fileData;
@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, strong) UIImage *_videoBtn;

@property (nonatomic, strong) NSString *progress;
@property (nonatomic, strong) NSMutableArray *loadingArray;
@property (nonatomic,assign)BOOL isComplePlay;
@property (nonatomic,assign)BOOL isCurrentPull;

@end
