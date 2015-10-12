//
//  CDMSendMessageController.h
//  CubeDemo
//
//  Created by jerny on 13-8-11.
//  Copyright (c) 2013年 yglh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDMShareMoreView.h"
#import "Cube.h"
#import <MediaPlayer/MediaPlayer.h>
@interface CDMSendMessageController : UIViewController<UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, CubeMessagingDelegate>
{
    IBOutlet UITableView *_msgRecordTable;
    IBOutlet UITextField *_messageText;
    IBOutlet UIView *_inputBar;
    CDMShareMoreView *_shareMoreView;
}

- (IBAction)shareMore:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *voiceBtn;
@property (strong, nonatomic) IBOutlet UIButton *btnKeyboard;
@property (strong, nonatomic) IBOutlet UIButton *btnSpeaker;

@property (nonatomic, strong) NSString *myDisName;

@property (nonatomic, strong) NSString *myCallName;

@property (nonatomic, strong) NSString *peerName;

@property (nonatomic,strong)MPMoviePlayerViewController *player;
//@property (nonatomic,strong)UIImage *thumImage;

@property (nonatomic,strong)NSMutableArray *loadingArray;

@property (nonatomic,strong)UIView *bigView;
@property (nonatomic,strong)UITapGestureRecognizer *tap;
@property (nonatomic,strong)UIImageView *bigImage;

@end
