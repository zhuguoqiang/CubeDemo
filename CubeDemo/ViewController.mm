//
//  ViewController.m
//  CubeDemo
//
//  Created by guoqiangzhu on 15/8/13.
//  Copyright (c) 2015年 CubeTeam. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "ViewController.h"
#import "CDMSendMessageController.h"
#import "WBViewController.h"

@interface ViewController ()
{
    AVAudioPlayer *_callPlayer;
    AVAudioPlayer *_ringBackPlayer;
    
    MediaProbe *_mediaProbe;
    WBViewController *_wbController;
}

//label
@property (strong, nonatomic) IBOutlet UILabel *lbState;
@property (strong, nonatomic) IBOutlet UILabel *lbHB;
@property (strong, nonatomic) IBOutlet UILabel *lbMyDisName;
@property (strong, nonatomic) IBOutlet UILabel *lbMyName;
@property (strong, nonatomic) IBOutlet UILabel *lbPeerName;
@property (strong, nonatomic) UILabel *lbFPS;

//textFiled
@property (strong, nonatomic) IBOutlet UITextField *tfMyName;
@property (strong, nonatomic) IBOutlet UITextField *tfMyAcount;
@property (strong, nonatomic) IBOutlet UITextField *tfPeerAcount;

//button
@property (strong, nonatomic) IBOutlet UIButton *btnRegister;
@property (strong, nonatomic) IBOutlet UIButton *btnUnregister;
@property (strong, nonatomic) IBOutlet UIButton *btnCall;
@property (strong, nonatomic) IBOutlet UIButton *btnMessage;
@property (strong, nonatomic) IBOutlet UIButton *btnAnswer;
@property (strong, nonatomic) IBOutlet UIButton *btnTerminal;
@property (strong, nonatomic) IBOutlet UIButton *btnVoice;
@property (strong, nonatomic) IBOutlet UIButton *btnVideo;
@property (strong, nonatomic) IBOutlet UIButton *btnSwitchCamera;
@property (strong, nonatomic) IBOutlet UIButton *btnWhiteboard;

//uiview
@property (nonatomic, strong) UIView *viewVideo;

//avfoundation
@property (nonatomic, strong) AVAudioPlayer *callPlayer;
@property (nonatomic, strong) AVAudioPlayer *ringBackPlayer;

@end

@implementation ViewController

@synthesize callPlayer = _callPlayer;
@synthesize ringBackPlayer = _ringBackPlayer;

- (id)init
{
    self = [super init];
    if (self) {
        [[CubeEngine sharedSingleton] loadSignaling];
        //添加媒体探针
        [self addMediaProbe];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [[CubeEngine sharedSingleton] loadSignaling];
        //添加媒体探针
        [self addMediaProbe];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [[CubeEngine sharedSingleton] loadSignaling];
        //添加媒体探针
        [self addMediaProbe];
    }
    return self;
}

- (void)dealloc
{
    [CubeEngine sharedSingleton].callDelegate = nil;
    [CubeEngine sharedSingleton].registrationDelegate = nil;
    [CubeEngine sharedSingleton].mediaDelegate = nil;
    
    [[CubeEngine sharedSingleton] unloadSignaling];
    
    //移除媒体探针
    [self removeMediaProbe];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    self.viewVideo = [[UIView alloc] initWithFrame:CGRectMake(0, 80
                                                              , self.view.frame.size.width, self.view.frame.size.height - 80)];
    [self.viewVideo setBackgroundColor:[UIColor whiteColor]];
    
    [self.view insertSubview:self.viewVideo atIndex:0];
    
    [self.btnWhiteboard setEnabled:NO];
    [self.btnMessage setEnabled:NO];
    [self.btnCall setEnabled:NO];
    [self.btnVoice setEnabled:NO];
    [self.btnVideo setEnabled:NO];
    [self.btnSwitchCamera setEnabled:NO];
    [self.btnAnswer setEnabled:NO];
    [self.btnTerminal setEnabled:NO];
    
    [self.btnRegister setEnabled:YES];
    [self.btnUnregister setEnabled:NO];
    
    [self.lbHB setHidden:YES];
    
    [self.tfMyName setEnabled:YES];
    [self.tfMyAcount setEnabled:YES];
    [self.tfPeerAcount setEnabled:YES];
    [self.tfMyName setPlaceholder:@"小友"];
    [self.tfMyAcount setPlaceholder:@"13000"];
    [self.tfPeerAcount setPlaceholder:@"13002"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self configCallPlayer];
        [self configRingBackPlayer];
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [CubeEngine sharedSingleton].registrationDelegate = self;
    [CubeEngine sharedSingleton].callDelegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSString *text = [NSString stringWithFormat:@"Cube Engine %@", [Cube versionDescription]];
    
    [self.lbState setText:text];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - IBActionMethod
- (IBAction)fireRegister:(UIButton *)sender
{
    if ([CubeEngine sharedSingleton].session.calling)
    {
        NSString *text = [NSString stringWithString:self.lbState.text];
        
        [self.lbState setText:@"正在通话，不能执行注册操作"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
                           [self.lbState setText:text];
                       });
        return;
    }
    
    NSString *myName = self.tfMyAcount.text;
    if (myName.length < 4)
    {
        [self.lbState setText:@"请输入正确的注册名"];
        return;
    }
    NSString *myDisName = self.tfMyName.text;
    
    [self.tfMyName resignFirstResponder];
    [self.tfMyAcount resignFirstResponder];
    [self.tfPeerAcount resignFirstResponder];
    
    if ([[CubeEngine sharedSingleton] registerAccount:myName password:@"123456" displayName:myDisName])
    {
        [self.lbState setText:@"正在注册，请稍候……"];
        [self.btnRegister setEnabled:NO];
    }
    else
    {
        [self.lbState setText:@"执行注册失败"];
    }

}

- (IBAction)fireUnregister:(UIButton *)sender
{
    if ([CubeEngine sharedSingleton].session.calling)
    {
        NSString *text = [NSString stringWithString:self.lbState.text];
        [self.lbState setText:@"正在通话，不能执行注销操作"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
                           [self.lbState setText:text];
                       });
        return;
    }
    
    if ([[CubeEngine sharedSingleton] unregisterAccount])
    {
        [self.lbState setText:@"正在注销，请稍候……"];
        [self.btnUnregister setEnabled:NO];
    }
    else
    {
        [self.lbState setText:@"执行注销失败"];
    }
    
    [self.tfMyAcount setEnabled:YES];
    [self.tfMyName setEnabled:YES];

}

- (IBAction)fireCall:(UIButton *)sender
{
    NSString *peerName = self.tfPeerAcount.text;
    
    if (peerName.length < 4)
    {
        [self.lbState setText:@"请输入正确的对端号码"];
        return;
    }
    
    [self.tfPeerAcount resignFirstResponder];
    
    dispatch_async(dispatch_get_main_queue(), ^ {
        BOOL ret = [[CubeEngine sharedSingleton] makeCall:peerName videoEnabled:YES];
        if (ret)
        {
            NSString *info = [NSString stringWithFormat:@"正在呼叫 %@", peerName];
            [self.lbState setText:info];
            
            [self.btnCall setEnabled:NO];
            [self.btnAnswer setEnabled:NO];
            [self.btnTerminal setEnabled:YES];
        }
        else
        {
            NSString *info = [NSString stringWithFormat:@"呼叫 %@ 失败，请稍候重试", peerName];
            [self.lbState setText:info];
            
            [self.btnCall setEnabled:YES];
            [self.btnAnswer setEnabled:NO];
            [self.btnTerminal setEnabled:NO];
        }
    });
}

- (IBAction)fireAnswer:(UIButton *)sender
{
    dispatch_async(dispatch_get_main_queue(), ^ {
        BOOL ret = [[CubeEngine sharedSingleton] answerCall:YES];
        if (ret)
        {
            NSString *info = [NSString stringWithFormat:@"已应答 %@ 呼叫", [CubeEngine sharedSingleton].session.callPeer.displayName];
            [self.lbState setText:info];
            
            [self.btnCall setEnabled:NO];
            [self.btnAnswer setEnabled:NO];
            [self.btnTerminal setEnabled:YES];
            [self.btnVideo setEnabled:YES];
            [self.btnVoice setEnabled:YES];
            [self.btnSwitchCamera setEnabled:YES];
        }
        else
        {
            NSString *info = [NSString stringWithFormat:@"应答 %@ 呼叫失败", [CubeEngine sharedSingleton].session.callPeer.displayName];
            [self.lbState setText:info];
            
            [self.btnCall setEnabled:NO];
            [self.btnAnswer setEnabled:YES];
            [self.btnTerminal setEnabled:YES];
            [self.btnVideo setEnabled:NO];
            [self.btnVoice setEnabled:NO];
            [self.btnSwitchCamera setEnabled:NO];
        }
        
    });
}

- (IBAction)fireTerminal:(UIButton *)sender
{
    dispatch_async(dispatch_get_main_queue(), ^ {
        
        BOOL ret = [[CubeEngine sharedSingleton] terminateCall];
        if (ret)
        {
            NSString *info = [NSString stringWithFormat:@"正在挂断 %@，请稍候……", [CubeEngine sharedSingleton].session.callPeer.displayName];
            [self.lbState setText:info];
            
            [self.btnCall setEnabled:NO];
            [self.btnAnswer setEnabled:NO];
            [self.btnTerminal setEnabled:NO];
            [self.btnVideo setEnabled:NO];
            [self.btnVoice setEnabled:NO];
            [self.btnSwitchCamera setEnabled:NO];
            
            [self.viewVideo setHidden:YES];
        }
        else
        {
            NSString *info = [NSString stringWithFormat:@"挂断呼叫 %@ 失败", [CubeEngine sharedSingleton].session.callPeer.displayName];
            [self.lbState setText:info];
            
            [self.btnCall setEnabled:NO];
            [self.btnAnswer setEnabled:NO];
            [self.btnTerminal setEnabled:YES];
            [self.btnVideo setEnabled:YES];
            [self.btnVoice setEnabled:YES];
            [self.btnSwitchCamera setEnabled:YES];
            
        }
    });

}

- (IBAction)fireLocalVoice:(UIButton *)sender
{
    if ([[CubeEngine sharedSingleton]isVoiceEnabled])
    {
        [[CubeEngine sharedSingleton] closeVoice];
    }
    else
    {
        [[CubeEngine sharedSingleton] openVoice];
    }
}

- (IBAction)fireLocalVideo:(UIButton *)sender
{
    if ([[CubeEngine sharedSingleton] isVideoEnabled])
    {
        [[CubeEngine sharedSingleton] closeVideo];
    }
    else
    {
        [[CubeEngine sharedSingleton] openVideo];
    }
}

- (IBAction)fireSwitchCamera:(UIButton *)sender
{
    [[CubeEngine sharedSingleton] switchCamera];
}

- (IBAction)btnWhiteboardAction:(UIButton *)sender
{
    NSString *peerName = self.tfPeerAcount.text;
    _wbController = [self.storyboard instantiateViewControllerWithIdentifier:@"whiteboardController"];
    _wbController.peerName = peerName;
    [self.navigationController pushViewController:_wbController animated:YES];
}

- (IBAction)btnMessageAction:(UIButton *)sender
{
    CDMSendMessageController *sendMsgVc = [[CDMSendMessageController alloc]initWithNibName:@"CDMSendMessageController" bundle:nil];
    [CubeEngine sharedSingleton].messagingDelegate = sendMsgVc;
    sendMsgVc.myCallName = _tfMyAcount.text;
    sendMsgVc.myDisName= _tfMyName.text;
    sendMsgVc.peerName = _tfPeerAcount.text;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:sendMsgVc];
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}

- (IBAction)fireMyDisnameReturnEditing:(id)sender
{
    [sender resignFirstResponder];
}

- (IBAction)fireMyNameReturnEditing:(id)sender
{
    [sender resignFirstResponder];
}

- (IBAction)firePeerNameReturnEditing:(id)sender
{
    [sender resignFirstResponder];
}

#pragma mark - Private Method

- (void)addMediaProbe
{
    _mediaProbe = [[MediaProbe alloc]init];
    _mediaProbe.delegate = self;
    [[CubeEngine sharedSingleton].mediaController addMediaProbe:_mediaProbe];
}

- (void)removeMediaProbe
{
    if (_mediaProbe != nil)
    {
        _mediaProbe.delegate = nil;
    }
    [[CubeEngine sharedSingleton].mediaController removeMediaProbe:_mediaProbe];
}

- (void)switchUI:(BOOL)hidden
{
    [self.tfMyAcount setHidden:hidden];
    [self.tfMyName setHidden:hidden];
    [self.tfPeerAcount setHidden:hidden];
    [self.lbMyDisName setHidden:hidden];
    [self.lbMyName setHidden:hidden];
    [self.lbPeerName setHidden:hidden];
    
    [self.btnRegister setHidden:hidden];
    [self.btnUnregister setHidden:hidden];
    [self.btnMessage setHidden:hidden];
    [self.btnWhiteboard setHidden:hidden];
    [self.btnCall setHidden:hidden];
    [self switchMediaControl:hidden];
    [self.btnAnswer setHidden:hidden];
    
    // 终断会话按钮始终显示
    [self.btnTerminal setHidden:NO];
}

- (void)switchMediaControl:(BOOL)hidden
{
    [self.btnVoice setHidden:hidden];
    [self.btnVideo setHidden:hidden];
    [self.btnSwitchCamera setHidden:hidden];
}

- (void)configCallPlayer
{
    NSError* err;
    NSString *path = [[NSBundle mainBundle]
                      pathForResource:@"oldphone"
                      ofType:@"wav"];
    NSURL *url = [NSURL fileURLWithPath: path];
    _callPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url
                                                         error:&err];
    _callPlayer.numberOfLoops = -1;
    _callPlayer.volume = 0.5;
    
    if (!err)
    {
        [_callPlayer prepareToPlay];
    }
    else
    {
        DLog(@"callPlayer : error : %@", err);
    }
}

- (void)configRingBackPlayer
{
    NSError *error;
    NSString *path = [[NSBundle mainBundle]
                      pathForResource:@"ringback"
                      ofType:@"wav"];
    NSURL *url = [NSURL fileURLWithPath: path];
    _ringBackPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    _ringBackPlayer.numberOfLoops = -1;
    _ringBackPlayer.volume = 1;
    
    if (!error)
    {
        [_ringBackPlayer prepareToPlay];
    }
    else
    {
        DLog(@"ringBackPlayer : error : %@", error);
    }
}

#pragma mark - MediaProbeDelegate
- (void)onVideoFps:(int)fps
{
    [self.lbFPS setText:[NSString stringWithFormat:@"FPS: %d", fps]];
}

#pragma mark - CubeAccountDelegate
- (void)onRegistrationProgress:(CubeSession *)session
{
    DLog(@"CUBE: onRegistrationProgress");
    
    [self.lbState setText:[NSString stringWithFormat:@"正在注册账号 %@", session.name]];
    self.tfMyAcount.text = session.name;
    [self.tfMyAcount setEnabled:NO];
    [self.tfMyName setEnabled:NO];
    
    [self.btnCall setEnabled:NO];
    [self.btnAnswer setEnabled:NO];
}

- (void)onRegistrationOk:(CubeSession *)session
{
    DLog(@"CUBE: onRegistrationOk");
    
    [self.lbState setText:[NSString stringWithFormat:@"账号 %@ 在线", session.name]];
    
    self.tfMyAcount.text = session.name;
    
    [self.tfMyAcount setEnabled:NO];
    [self.tfMyName setEnabled:NO];
    
    [self.btnRegister setEnabled:NO];
    [self.btnUnregister setEnabled:YES];
    [self.btnCall setEnabled:YES];
    [self.btnMessage setEnabled:YES];
    [self.btnWhiteboard setEnabled:YES];
}

- (void)onRegistrationCleared:(CubeSession *)session
{
    DLog(@"CUBE: onRegistrationCleared");
    [self.lbState setText:[NSString stringWithFormat:@"账号 %@ 注销成功", session.name]];
    self.tfMyAcount.text = session.name;
    [self.tfMyAcount setEnabled:YES];
    [self.tfMyName setEnabled:YES];
    
    [self.btnRegister setEnabled:YES];
    [self.btnUnregister setEnabled:NO];
    [self.btnCall setEnabled:NO];
    [self.btnMessage setEnabled:NO];
    [self.btnWhiteboard setEnabled:NO];
}

- (void)onRegistrationFailed:(CubeSession *)session
{
    DLog(@"CUBE: onRegistrationFailed");
    [self.lbState setText:[NSString stringWithFormat:@"账号 %@ 注册失败", session.name]];
    self.tfMyAcount.text = session.name;
    [self.tfMyAcount setEnabled:YES];
    [self.tfMyName setEnabled:YES];
    
    [self.btnRegister setEnabled:YES];
    [self.btnUnregister setEnabled:YES];
    [self.btnCall setEnabled:NO];
    [self.btnMessage setEnabled:NO];
    [self.btnWhiteboard setEnabled:NO];
}

- (void)onHeartbeat:(CubeSession *)session
{
    DLog(@"CUBE: onHeartbeat");
    
    NSString *text = [NSString stringWithString:self.lbState.text];
    
    [self.lbState setText:@"引擎信令状态正常"];
    
    [self.lbHB setHidden:NO];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       [self.lbHB setHidden:YES];
                   });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       if (nil != text)
                       {
                           [self.lbState setText:text];
                       }
                   });
}

#pragma mark - CubeCallingDelegate

- (void)onNewCall:(CubeCallDirection)callDirection session:(CubeSession *)session
{
    NSString *dir = callDirection == CubeCallOutgoing ? @"呼出" : @"呼入";
    NSString *target = session.callPeer.displayName;
    
    DLog(@"CUBE: onNewCall : %@ - %@", dir, session.callPeer.name);
    
    if (callDirection == CubeCallOutgoing)
    {
        [self.lbState setText:[NSString stringWithFormat:@"正在呼叫 %@", target]];
        [self.btnAnswer setEnabled:NO];
    }
    else
    {
        [_callPlayer play];
        [self.lbState setText:[NSString stringWithFormat:@"来电，请接听"]];
        [self.btnAnswer setEnabled:YES];
        
        [self.tfPeerAcount setText:session.callPeer.name];
    }
    
    [self.tfPeerAcount setEnabled:NO];
    
    [self.btnCall setEnabled:NO];
    [self.btnTerminal setEnabled:YES];
    
    [self switchUI:YES];
    [self.btnAnswer setHidden:NO];
    
    [self.viewVideo setHidden:NO];
}

- (void)onInProgress:(CubeSession *)session
{
    [self.lbState setText:@"正在接通，请稍候……"];
}

- (void)onCallRinging:(CubeSession *)session
{
    NSString *dir = session.callDirection == CubeCallOutgoing ? @"呼出" : @"呼入";
    NSString *target = session.callPeer.name;
    DLog(@"CUBE: onCallRinging : %@ - %@", dir, target);
    
    if (session.callDirection == CubeCallOutgoing)
    {
        [_ringBackPlayer play];
        [self.lbState setText:[NSString stringWithFormat:@"对方正在响铃"]];
        [self.btnAnswer setEnabled:NO];
    }
    
    [self.btnCall setEnabled:NO];
    [self.btnTerminal setEnabled:YES];
    
    [self.btnAnswer setHidden:YES];
}

- (void)onCallConnected:(CubeSession *)session
{
    NSString *dir = session.callDirection == CubeCallOutgoing ? @"呼出" : @"呼入";
    NSString *target = session.callPeer.displayName;
    DLog(@"CUBE: onCallConnected : %@ - %@", dir, target);
    
    if (session.callDirection == CubeCallOutgoing)
    {
        [self stopPlayer:_callPlayer];
        [self stopPlayer:_ringBackPlayer];
    }
    [self.lbState setText:[NSString stringWithFormat:@"正在与 %@ 通话", target]];
    
    [self.btnAnswer setEnabled:NO];
    [self.btnCall setEnabled:NO];
    [self.btnTerminal setEnabled:YES];
    
    [self.btnVideo setEnabled:YES];
    [self.btnVoice setEnabled:YES];
    [self.btnSwitchCamera setEnabled:YES];
    
    [self switchUI:YES];
    [self switchMediaControl:NO];
    
    // 添加视图
    [self.viewVideo addSubview:session.localVideoView];
    __block CubeLocalVideoView *cubeVideoView = (CubeLocalVideoView *)session.localVideoView;
    
    [self.viewVideo insertSubview:session.remoteViewView belowSubview:session.localVideoView];
    
    // 添加fps标签
    if (nil == self.lbFPS)
    {
        self.lbFPS = [[UILabel alloc]initWithFrame:CGRectMake(self.viewVideo.frame.size.width  - 100, 20, 80, 30)];
        [self.lbFPS setTextColor:[UIColor whiteColor]];
        [self.lbFPS setTextAlignment:NSTextAlignmentRight];
    }
    [self.viewVideo insertSubview:self.lbFPS aboveSubview:session.remoteViewView];
    
    [self.lbFPS setHidden:NO];
    
    // 改变view大小
    [UIView animateWithDuration:0.4f
                     animations:^{
                         CGRect localFrame = self.viewVideo.bounds;
                         localFrame.origin.y = 0;
                         localFrame.origin.x = 0;
                         localFrame.size.width = localFrame.size.width * 0.4;
                         localFrame.size.height = localFrame.size.height * 0.4;
                         [cubeVideoView changeFrame:localFrame];
                     } completion:^(BOOL finished) {
                         
                     }];
    
    [UIView animateWithDuration:0.4f
                     animations:^{
                         CubeRemoteVideoView *remoteVideoView = (CubeRemoteVideoView *)session.remoteViewView;
                         CGRect localFrame = self.viewVideo.bounds;
                         localFrame.origin.y = 0;
                         localFrame.origin.x = 0;
                         localFrame.size.width = localFrame.size.width;
                         localFrame.size.height = localFrame.size.height;
                         [remoteVideoView changeFrame:localFrame];
                         [remoteVideoView setBackgroundColor:[UIColor blackColor]];
                         
                     } completion:^(BOOL finished) {
                         
                     }];
    
}

- (void)onCallEnded:(CubeSession *)session
{
    NSString *dir = session.callDirection == CubeCallOutgoing ? @"呼出" : @"呼入";
    NSString *target = session.callPeer.name;
    DLog(@"CUBE: onCallEnded : %@ - %@", dir, target);
    
    [self stopPlayer:_callPlayer];
    [self stopPlayer:_ringBackPlayer];
    [self.lbState setText:@"通话结束"];
    
    [self.tfPeerAcount setEnabled:YES];
    
    [self.btnCall setEnabled:YES];
    [self.btnAnswer setEnabled:NO];
    [self.btnTerminal setEnabled:NO];
    [self.btnVideo setEnabled:NO];
    [self.btnVoice setEnabled:NO];
    [self.btnSwitchCamera setEnabled:NO];
    
    [self switchUI:NO];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       if ([self.lbState.text isEqualToString:@"通话结束"])
                       {
                           if (session.registrationState == CubeRegistrationOk)
                           {
                               [self.lbState setText:[NSString stringWithFormat:@"帐号 %@ 在线", session.name]];
                           }
                           else
                           {
                               [self.lbState setText:[NSString stringWithFormat:@"帐号 %@ 离线", session.name]];
                           }
                       }
                   });
    
    [self.viewVideo setHidden:YES];
    [self.lbFPS setHidden:YES];
}

- (void)onCallFailed:(CubeSession *)session errorCode:(CubeCallErrorCode)errorCode
{
    NSString *dir = session.callDirection == CubeCallOutgoing ? @"呼出" : @"呼入";
    NSString *target = session.callPeer.name ? session.callPeer.name : @"?";
    DLog(@"CUBE: onCallFailed : %@ - %@, code: %d", dir, target, errorCode);
    
    [self stopPlayer:_callPlayer];
    [self stopPlayer:_ringBackPlayer];
    if (errorCode == CubeCallErrorConnectionFailed)
    {
        [self.lbState setText:@"网络连接出错"];
    }
    else if (errorCode == CubeCallErrorNetworkNotReachable)
    {
        [self.lbState setText:@"网络连接不通，请检查网络"];
    }
    else if (errorCode == CubeCallErrorCreateSessionDescriptionFailed
             || errorCode == CubeCallErrorSetSessionDescriptionFailed)
    {
        [self.lbState setText:@"SDP 协商失败，请再次尝试"];
    }
    else if (errorCode == CubeCallErrorRequestTimeout)
    {
        [self.lbState setText:@"对端不在线"];
    }
    else
    {
        NSString *info = [NSString stringWithFormat:@"通话失败: %d", errorCode];
        [self.lbState setText:info];
    }
    
    [self.btnCall setEnabled:YES];
    [self.btnAnswer setEnabled:NO];
    [self.btnTerminal setEnabled:NO];
    [self.btnVideo setEnabled:NO];
    [self.btnVoice setEnabled:NO];
    [self.btnSwitchCamera setEnabled:NO];
    
    [self switchUI:NO];
    
    [self.viewVideo setHidden:YES];
    [self.lbFPS setHidden:YES];
}

#pragma mark - CubeMediaDelegate
- (void)onMediaStateChanged:(CubeMediaState)state
{
    //TODO
    //update UI
    switch (state) {
        case CubeVideoOpened:
        {
            DLog(@"CubeVideoOpened");
        }
            break;
        case CubeVideoClosed:
        {
            DLog(@"CubeVideoClosed");
        }
            break;
        case CubeAudioOpened:
        {
            //Nothing
        }
            break;
        case CubeAudioClosed:
        {
            //Nothing
        }
            break;
        default:
            break;
    }
}

#pragma mark - Sound
- (void)stopPlayer:(AVAudioPlayer *)player
{
    if (!player)
        return;
    
    if ([player isPlaying])
    {
        [player stop];
        player.currentTime = 0;
        player = nil;
    }
}

@end
