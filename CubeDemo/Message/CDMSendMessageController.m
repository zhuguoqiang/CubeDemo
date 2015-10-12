//
//  CDMSendMessageController.m
//  CubeDemo
//
//  Created by jerny on 13-8-11.
//  Copyright (c) 2013年 yglh. All rights reserved.
//


#import "CDMSendMessageController.h"
#import "CDMMessageCell.h"
#import "CDMMessageObject.h"
#import "CBUtils.h"
#import "MBProgressHUD+Add.h"
#import "CubeFileMessage.h"
#import "CubeImageMessage.h"
#import "CubeVoiceClipMessage.h"
#import "CubeVideoClipMessage.h"

#define kUTTypeJPEG @"public.jpeg"

#define KWidth [[UIScreen mainScreen] bounds].size.width
#define KHeight [[UIScreen mainScreen] bounds].size.height

@interface CDMSendMessageController () <UIAlertViewDelegate>
{
    NSMutableArray *_allMessages;
    NSMutableDictionary *_sendFileMessageDic;
    NSMutableDictionary *_sendFileMessageObjectDic;
    NSMutableDictionary *_receiveFileMessageDic;
    NSMutableDictionary *_receiveFileMessageObjectDic;
    
    NSString *_receiveFileMsgName;
}
@end

@implementation CDMSendMessageController

@synthesize myDisName, myCallName, peerName;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
            name:UIKeyboardWillChangeFrameNotification
                                            object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
    }
    
    self.title = [NSString stringWithFormat:@"%@", peerName];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    [_msgRecordTable addGestureRecognizer:tap];
    
    [_msgRecordTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    _shareMoreView = [[NSBundle mainBundle] loadNibNamed:@"CDMShareMoreView" owner:nil options:nil][0];
    _shareMoreView.frame = CGRectMake(0, 0, 320, 170);
    [_shareMoreView.picture addTarget:self action:@selector(pictureClick) forControlEvents:UIControlEventTouchUpInside];
    [_shareMoreView.video addTarget:self action:@selector(videoClick) forControlEvents:UIControlEventTouchUpInside];
    [_shareMoreView.blankSpace addTarget:self action:@selector(blankSpaceClick) forControlEvents:UIControlEventTouchUpInside];
    [_shareMoreView.btnHistory addTarget:self action:@selector(queryMessageHistory) forControlEvents:UIControlEventTouchUpInside];
    
    [_shareMoreView.btnSendFile addTarget:self action:@selector(btnSendFileAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _messageText.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeKeyBoard:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    _allMessages = [NSMutableArray array];
    
    _loadingArray = [[NSMutableArray alloc] init];
    for (int i = 1; i < 5; i ++)
    {
        NSString *imageName = [NSString stringWithFormat:@"loading%d.png",i];
        UIImage *image = [UIImage imageNamed:imageName];
        [_loadingArray addObject:image];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark 发送文本消息
-(void)sendMessage:(NSString *)message
{
    Receiver *receiver = [[Receiver alloc]initWithName:peerName];
    receiver.displayName = peerName;
//    CubeTextMessage *textMessage = [[CubeTextMessage alloc]initWithMessageContent:message
//                                                                      andReceiver:receiver];
//
//    if (nil != textMessage) {
//        [textMessage setStatus:CREATE];
//    }
//    
//    if ([[CubeEngine sharedSingleton] sendTextMessage:textMessage]) {
//        //TODO 消息发送成功
//    }
//    else
//    {
//        //TODO 消息发送失败
//    }
    
    CubeCustomMessage *customMessage = [[CubeCustomMessage alloc]initWithReceiver:receiver];
    customMessage.body = @"我是自定义消息";
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"我是头" forKey:@"headers"];
    customMessage.header = dic;
    if (nil != customMessage) {
        [customMessage setStatus:CREATE];
    }

    if ([[CubeEngine sharedSingleton] sendCustomMessage:customMessage]) {
        //TODO 自定义消息发送成功
    }
    else
    {
        //TODO 自定义消息发送失败
    }

    
}

#pragma mark 录制视频
-(void)videoClick
{
    [self handleTap:nil];
    self.tabBarController.hidesBottomBarWhenPushed = YES;
//    _cubeRecordView = [[CubeRecordVideoView alloc]initWithFrame:CGRectMake(0, 0, KWidth, KHeight)];
//    _cubeRecordView.myDisName = myDisName;
//    _cubeRecordView.myCallName = myCallName;
//    _cubeRecordView.peerName = peerName;
    [[CubeEngine sharedSingleton].mediaController loadRecordVideoViewWithReceiverName:peerName];
    [self.navigationController.view addSubview:[CubeEngine sharedSingleton].mediaController.recordView];
    
    
    
//    UIImagePickerController* pickerView = [[UIImagePickerController alloc] init];
//    pickerView.sourceType = UIImagePickerControllerSourceTypeCamera;
//    NSArray* availableMedia = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
//    pickerView.mediaTypes = [NSArray arrayWithObject:availableMedia[1]];
//    pickerView.videoQuality = UIImagePickerControllerQualityTypeMedium;
//    pickerView.allowsEditing = YES;
////    [self presentModalViewController:pickerView animated:YES];
//    [self presentViewController:pickerView animated:YES completion:^{
//    }];
//    pickerView.videoMaximumDuration = 10;
//    pickerView.delegate = self;

    
}

#pragma mark 白板
-(void)blankSpaceClick
{
    [self handleTap:nil];
}

#pragma  mark 历史记录
- (void)queryMessageHistory
{
    NSString *beginStr = @"2015-05-14 09:30:00";
    long long begin = [CBUtils timeStampMillsFromTime:beginStr];
    
    NSString *endStr = @"2015-05-21 18:30:00";
    long long end = [CBUtils timeStampMillsFromTime:endStr];
    
    [[CubeEngine sharedSingleton] queryMessageHistoryBegin:begin withEnd:end];
}

#pragma mark 加号按钮
- (IBAction)shareMore:(id)sender
{
    if (_messageText.inputView)
    {
        [_messageText setInputView:nil];
        [_messageText resignFirstResponder];
    }
    else
    {
        CGFloat deltaY = 0;
        if ([_messageText isFirstResponder])
        {
            deltaY = 37;
            CGRect tableFrame = _msgRecordTable.frame;
            tableFrame.origin.y += deltaY;
            _msgRecordTable.frame = tableFrame;
            [_msgRecordTable setContentInset:UIEdgeInsetsMake(_msgRecordTable.contentInset.top - deltaY, 0, 0, 0)];
        }
        CGRect frame = _inputBar.frame;
        frame.origin.y += deltaY;
        _inputBar.frame = frame;
        [_messageText setInputView:_shareMoreView];
        [_messageText reloadInputViews];
        [_messageText becomeFirstResponder];
    }
}

#pragma mark 发送文件

- (void)btnSendFileAction:(id)sender
{
    NSString *fileName = @"Test.pdf";
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [documentPath stringByAppendingPathComponent:fileName];
    
    NSString *tmpPath = [[NSBundle mainBundle] pathForResource:@"/Assets/Test" ofType:@"pdf"];
    if (![fm fileExistsAtPath:path])
    {
        [fm copyItemAtPath:tmpPath toPath:path error:nil];
    }
    
    NSData *fileData = [fm contentsAtPath:path];
    
    Receiver *receiver = [[Receiver alloc] initWithName:peerName];
    receiver.displayName = peerName;
    
    CubeFileMessage *fileMessage = [[CubeFileMessage alloc] initWithFile:fileData andFileName:fileName andReceiver:receiver];
    
    if ([[CubeEngine sharedSingleton] sendFileMessage:fileMessage])
    {
        
    }
    else
    {
        
    }
    
}
#pragma mark - 按住说话
- (IBAction)btnSpeakerDown:(id)sender
{
    [[[CubeEngine sharedSingleton] getMediaController] startRecordVoice:60];
}

#pragma mark - 松开结束
- (IBAction)btnSpeakerUp:(id)sender
{
    [[[CubeEngine sharedSingleton] getMediaController] stopRecordVoice];
    
    Receiver *receiver = [[Receiver alloc] initWithName:peerName];
    receiver.displayName = peerName;
//    DLog(@"---%@",receiver.displayName);
    Sender *sende = [[Sender alloc]initWithName:myCallName];
    sende.displayName = myDisName;
    NSString *filePath = [[[CubeEngine sharedSingleton] getMediaController] getVoiceFilePath];
    
    CubeVoiceClipMessage *audioClipMessage = [[CubeVoiceClipMessage alloc] initWithFilePath:filePath
                                                                                andReceiver:receiver
                                                                                  andSender:sende];

    CubeFileMessage *fileMessage = audioClipMessage;
    if ([[CubeEngine sharedSingleton] sendFileMessage:fileMessage])
    {
        //发送成功
//        DLog(@"发送成功!");
    }else{
        //发送失败
//        DLog(@"发送失败");
    }
}

#pragma mark - 切至语音聊天
- (IBAction)btnVoiceAction:(id)sender
{
    [self switchTextMessageMode:NO];
}

#pragma mark - 切至文本聊天
- (IBAction)btnKeyboardAction:(id)sender
{
    [self switchTextMessageMode:YES];
}

- (void)switchTextMessageMode:(BOOL)isTextMode
{
    [self.btnSpeaker setHidden:(isTextMode ? YES : NO)];
    [self.btnKeyboard setHidden:(isTextMode ? YES : NO)];
    [self.voiceBtn setHidden:(isTextMode ? NO : YES)];
    [_messageText setHidden:(isTextMode ? NO : YES)];
    if ([_messageText isFirstResponder])
    {
        [_messageText resignFirstResponder];
    }
    
}
#pragma mark 图片选择
-(void)pictureClick
{
    [self handleTap:nil];
    
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    [imgPicker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    [imgPicker setDelegate:self];
    [imgPicker setAllowsEditing:NO];
    [self presentViewController:imgPicker animated:YES completion:^{
    }];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendMessage:_messageText.text];
    [textField setText:nil];
    return YES;
}

- (void)backBtnAction
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [CubeEngine sharedSingleton].messagingDelegate = nil;
    }];
}

#pragma mark - CubeMessagingDelegate
- (void)onSent:(CubeSession *)session withMessageEntity:(MessageEntity *)message
{
    
    if (message.messageType == CUBE_MT_TEXT) {
        CubeTextMessage *textMsg = (CubeTextMessage *)message;
        DLog(@"onSent : textMessage = %@", textMsg.content);
        
        [self createTimestamp:message.sendTime];
        
        CDMMessageObject *msgObject = [[CDMMessageObject alloc] init];
        msgObject.name = textMsg.sender.displayName;
        DLog(@"发消息：sender.displayName = %@", textMsg.sender.displayName);
        msgObject.message = textMsg.content;
        msgObject.msgStyle = KMessageCellStyleMe;
        [_allMessages addObject:msgObject];
        [_msgRecordTable reloadData];
        [_msgRecordTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_allMessages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }else if (message.messageType == CUBE_MT_CUSTOM) {
    
        CubeCustomMessage *customMsg = (CubeCustomMessage *)message;
        DLog(@"onSent : customMessage.header = %@",customMsg.header);
        DLog(@"onSent : customMessage.body = %@",customMsg.body);
        
        
    }else{
        
        CDMMessageObject *msgObject;
        CubeFileMessage *fileMsg = (CubeFileMessage *)message;
        [self createTimestamp:message.sendTime];
        
        if (message.messageType == CUBE_MT_FILE)
        {
            msgObject = [[CDMMessageObject alloc] init];
            msgObject.name = fileMsg.sender.displayName;
            msgObject.message = [NSString stringWithFormat:@"发送文件: %@ \n 0 %%",fileMsg.fileName];
            msgObject.msgStyle = KMessageCellStyleMe;
        }
        else if (message.messageType == CUBE_MT_IMAGE)
        {
            msgObject = [[CDMMessageObject alloc] init];
            msgObject.name = fileMsg.sender.displayName;
            msgObject.fileData = fileMsg.file;
            NSData *data = fileMsg.file;
            UIImage *image = [UIImage imageWithData:data];
            //TODO 生成缩略图
            msgObject.image = image;
            msgObject.msgStyle = KMessageCellStyleMeWithImage;
        }
        else if (message.messageType == CUBE_MT_AUDIO)
        {
            CubeVoiceClipMessage *voiceMsg = (CubeVoiceClipMessage *)fileMsg;
            msgObject = [[CDMMessageObject alloc] init];
            msgObject.name = voiceMsg.sender.displayName;
            msgObject._voiceBtn = [UIImage imageNamed:@"ToolViewInputVoice"];
            msgObject.filePath = voiceMsg.filePath;
            msgObject.msgStyle = KMessageCellStyleMeWithVoice;
        }
        else if (message.messageType == CUBE_MT_VIDEO)
        {
            CubeVideoClipMessage *videoMsg = (CubeVideoClipMessage *)fileMsg;
            msgObject = [[CDMMessageObject alloc] init];
            msgObject.name = videoMsg.sender.displayName;
            msgObject.fileData = videoMsg.file;
            msgObject.fileName = videoMsg.fileName;
            msgObject._videoBtn = [CubeEngine sharedSingleton].mediaController.recordView.thumbImage;
            msgObject.progress = @"0%%";
            msgObject.loadingArray = _loadingArray;
            msgObject.msgStyle = kmessagecellstyleMeWithVideo;
        }
        
        if (nil == _sendFileMessageDic)
        {
            _sendFileMessageDic = [NSMutableDictionary dictionary];
        }
        [_sendFileMessageDic setObject:message forKey:fileMsg.fileName];
        
        if (nil == _sendFileMessageObjectDic)
        {
            _sendFileMessageObjectDic  = [NSMutableDictionary dictionary];
        }
        [_sendFileMessageObjectDic setObject:msgObject forKey:fileMsg.fileName];
        
        [_allMessages addObject:msgObject];
        [_msgRecordTable reloadData];
        [_msgRecordTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_allMessages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}
//- (void)onSent:(CubeSession *)session withTextMessage:(CubeTextMessage *)message
//{
//    DLog(@"onSent : textMessage = %@", message.content);
//    
//    [self createTimestamp:message.sendTime];
//    
//    CDMMessageObject *msgObject = [[CDMMessageObject alloc] init];
//    msgObject.name = message.sender.displayName;
//    DLog(@"发消息：sender.displayName = %@", message.sender.displayName);
//    msgObject.message = message.content;
//    msgObject.msgStyle = KMessageCellStyleMe;
//    [_allMessages addObject:msgObject];
//    [_msgRecordTable reloadData];
//    [_msgRecordTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_allMessages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//}

//- (void)onSent:(CubeSession *)session withFileMessage:(CubeFileMessage *)message
//{
//    [self createTimestamp:message.sendTime];
//    
//    CDMMessageObject *msgObject;
//    if (message.messageType == CUBE_MT_FILE)
//    {
//        msgObject = [[CDMMessageObject alloc] init];
//        msgObject.name = message.sender.displayName;
//        msgObject.message = [NSString stringWithFormat:@"发送文件: %@ \n 0 %%",message.fileName];
//        msgObject.msgStyle = KMessageCellStyleMe;
//    }
//    else if (message.messageType == CUBE_MT_IMAGE)
//    {
//        msgObject = [[CDMMessageObject alloc] init];
//        msgObject.name = message.sender.displayName;
//        msgObject.fileData = message.file;
//        NSData *data = message.file;
//        UIImage *image = [UIImage imageWithData:data];
//        //TODO 生成缩略图
//        msgObject.image = image;
//        msgObject.msgStyle = KMessageCellStyleMeWithImage;
//    }
//    else if (message.messageType == CUBE_MT_AUDIO)
//    {
//        CubeVoiceClipMessage *voiceMsg = (CubeVoiceClipMessage *)message;
//        //TODO
//        msgObject = [[CDMMessageObject alloc] init];
//        msgObject.name = voiceMsg.sender.displayName;
//        msgObject._voiceBtn = [UIImage imageNamed:@"ToolViewInputVoice"];
//        msgObject.filePath = voiceMsg.filePath;
//        msgObject.msgStyle = KMessageCellStyleMeWithVoice;
//    }
//    else if (message.messageType == CUBE_MT_VIDEO)
//    {
//        CubeVideoClipMessage *videoMsg = (CubeVideoClipMessage *)message;
//        msgObject = [[CDMMessageObject alloc] init];
//        msgObject.name = videoMsg.sender.displayName;
//        msgObject.fileData = videoMsg.file;
//        msgObject.fileName = videoMsg.fileName;
//        msgObject._videoBtn = [CubeEngine sharedSingleton].mediaController.recordView.thumbImage;
//        msgObject.progress = @"0%%";
//        msgObject.loadingArray = _loadingArray;
//        msgObject.msgStyle = kmessagecellstyleMeWithVideo;
//    }else if (message.messageType == CUBE_MT_CUSTOM)
//    {
//        //TODO  自定义消息
//    }
//
//    if (nil == _sendFileMessageDic)
//    {
//        _sendFileMessageDic = [NSMutableDictionary dictionary];
//    }
//    [_sendFileMessageDic setObject:message forKey:message.fileName];
//    
//    if (nil == _sendFileMessageObjectDic)
//    {
//        _sendFileMessageObjectDic  = [NSMutableDictionary dictionary];
//    }
//    [_sendFileMessageObjectDic setObject:msgObject forKey:message.fileName];
//    
//    [_allMessages addObject:msgObject];
//    [_msgRecordTable reloadData];
//    [_msgRecordTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_allMessages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//}
- (void)onReceived:(CubeSession *)session withMessageEntity:(MessageEntity *)message
{
    if (message.messageType == CUBE_MT_TEXT) {
        CubeTextMessage *textMsg = (CubeTextMessage *)message;
        DLog(@"onReceived TextMessage: %@", textMsg.content);
        
        [self createTimestamp:message.sendTime];
        
        CDMMessageObject *msgObject = [[CDMMessageObject alloc] init];
        msgObject.name = message.sender.displayName;//发件人
        DLog(@"收消息：sender.displayName = %@", message.sender.displayName);
        msgObject.message = textMsg.content;
        msgObject.msgStyle = KMessageCellStyleOther;
        [_allMessages addObject:msgObject];
        [_msgRecordTable reloadData];
        [_msgRecordTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_allMessages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];

    }else if (message.messageType == CUBE_MT_CUSTOM) {
        //TODO
        CubeCustomMessage *customMsg = (CubeCustomMessage *)message;
        DLog(@"onReceived CustomMessage.header:%@",customMsg.header);
        DLog(@"onReceived CustomMessage.body:%@",customMsg.body);
        
        
    }else{
        CubeFileMessage *fileMsg = (CubeFileMessage *)message;
        _receiveFileMsgName = fileMsg.fileName;
        
        if (nil == _receiveFileMessageDic)
        {
            _receiveFileMessageDic = [NSMutableDictionary dictionary];
        }
        [_receiveFileMessageDic setObject:fileMsg forKey:fileMsg.fileName];
        
        if (message.messageType == CUBE_MT_IMAGE)
        {
            CubeImageMessage *imgMsg = (CubeImageMessage *)fileMsg;
            [self acceptImageMessage:imgMsg];
        }
        else if (message.messageType == CUBE_MT_AUDIO)
        {
            //TODO
            CubeVoiceClipMessage *audioClipMessage = (CubeVoiceClipMessage *)fileMsg;
            [self acceptAudioMessage:audioClipMessage];
        }
        else if ( message.messageType == CUBE_MT_VIDEO ||
                 message.messageType == CUBE_MT_FILE)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"接收文件 ？" message:fileMsg.fileName delegate:self cancelButtonTitle:@"拒绝" otherButtonTitles:@"接收", nil];
            [alert show];
        }
      
    }
        
}
//- (void)onReceived:(CubeSession *)session withTextMessage:(CubeTextMessage *)message
//{
//    DLog(@"onReceived TextMessage: %@", message.content);
//    
//    [self createTimestamp:message.sendTime];
//    
//    CDMMessageObject *msgObject = [[CDMMessageObject alloc] init];
//    msgObject.name = message.sender.displayName;//发件人
//    DLog(@"收消息：sender.displayName = %@", message.sender.displayName);
//    msgObject.message = message.content;
//    msgObject.msgStyle = KMessageCellStyleOther;
//    [_allMessages addObject:msgObject];
//    [_msgRecordTable reloadData];
//    [_msgRecordTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_allMessages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//    
//}

//- (void)onReceived:(CubeSession *)session withFileMessage:(CubeFileMessage *)message
//{
//    _receiveFileMsgName = message.fileName;
//    
//    if (nil == _receiveFileMessageDic)
//    {
//        _receiveFileMessageDic = [NSMutableDictionary dictionary];
//    }
//    [_receiveFileMessageDic setObject:message forKey:message.fileName];
//    
//    if (message.messageType == CUBE_MT_IMAGE)
//    {
//        CubeImageMessage *imgMsg = (CubeImageMessage *)message;
//        [self acceptImageMessage:imgMsg];
//    }
//    else if (message.messageType == CUBE_MT_AUDIO)
//    {
//        //TODO
//        CubeVoiceClipMessage *audioClipMessage = (CubeVoiceClipMessage *)message;
//        [self acceptAudioMessage:audioClipMessage];
//    }
//    else if ( message.messageType == CUBE_MT_VIDEO ||
//         message.messageType == CUBE_MT_FILE)
//    {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"接收文件 ？" message:message.fileName delegate:self cancelButtonTitle:@"拒绝" otherButtonTitles:@"接收", nil];
//        [alert show];
//    }
//    else if (message.messageType == CUBE_MT_CUSTOM)
//    {
//        //TODO
//    }
//
//}

- (void)onReceiveMessageHistory:(NSArray *)messages begin:(long long)begin end:(long long)end
{
    //获取历史消息
    DLog(@"Message history begin : %@ : end : %@ ",
          [CBUtils dateFromTimeStampMillis:begin withDateFormat:@"yyyy-MM-dd HH:mm:ss"],
          [CBUtils dateFromTimeStampMillis:end withDateFormat:@"yyyy-MM-dd HH:mm:ss"]);
    
    for (int i = 0; i < messages.count; i++)
    {
        CubeTextMessage *message = [messages objectAtIndex:i];
        NSString *msgStr = [CBUtils dictionaryToJSON:[message toJSONObject]];
        DLog(@"message ( %d ) is : %@ ", i, msgStr);
    }

}
- (void)onMessageFailed:(CubeSession *)session withMessageErrorCode:(CubeMessageErrorCode)errorCode withMessageEntity:(MessageEntity *)message
{
    if (message.messageType == CUBE_MT_TEXT) {
        CubeTextMessage *textMsg = (CubeTextMessage *)message;
        DLog(@"Message : %@ send Failed, errorCode : %d",textMsg.content, errorCode);
        [self closeKeyBoard];
        [MBProgressHUD showError:[NSString stringWithFormat:@"发送失败 ,错误码 : %d",errorCode ] toView:_msgRecordTable];
    }else{
        CubeFileMessage *fileMsg = (CubeFileMessage *)message;
        DLog(@"发送失败,错误码%u",errorCode);
        
        CDMMessageObject *messageObject;
        messageObject = [_sendFileMessageObjectDic objectForKey:fileMsg.fileName];
        messageObject.loadingArray = nil;

    }
   

}
//- (void)onMessageFailed:(CubeSession *)session withMessageErrorCode:(CubeMessageErrorCode)errorCode withTextMessage:(CubeTextMessage *)message
//{
//    DLog(@"Message : %@ send Failed, errorCode : %d",message.content, errorCode);
//    [self closeKeyBoard];
//    [MBProgressHUD showError:[NSString stringWithFormat:@"发送失败 ,错误码 : %d",errorCode ] toView:_msgRecordTable];
//}

//- (void)onMessageFailed:(CubeSession *)session withMessageErrorCode:(CubeMessageErrorCode)errorCode withFileMessage:(CubeFileMessage *)message
//{
//    DLog(@"发送失败,错误码%u",errorCode);
//    
//    CDMMessageObject *messageObject;
//    messageObject = [_sendFileMessageObjectDic objectForKey:message.fileName];
//    messageObject.loadingArray = nil;
//
//    //TODO
//}
- (void)onSendProgress:(CubeSession *)session withMessageEntity:(MessageEntity *)message withProcessed:(long)processed withTotal:(long)total
{
    if (message.messageType == CUBE_MT_TEXT) {
        
    }else{
        CubeFileMessage *fileMsg = (CubeFileMessage *)message;
        CDMMessageObject *messageObj;
        int index;
        if (fileMsg.messageType == CUBE_MT_FILE)
        {
            messageObj = [_sendFileMessageObjectDic objectForKey:fileMsg.fileName];
            index = (int)[_allMessages indexOfObject:messageObj];
            if (nil != messageObj)
            {
                messageObj.message = [NSString stringWithFormat:@"发送文件: %@ \n %ld %%",fileMsg.fileName, 100 * processed / total];
            }
            [_allMessages replaceObjectAtIndex:index withObject:messageObj];
        }
        else if (fileMsg.messageType == CUBE_MT_IMAGE)
        {
            //TODO
            messageObj = [_sendFileMessageObjectDic objectForKey:fileMsg.fileName];
            index = (int)[_allMessages indexOfObject:messageObj];
            if (nil != messageObj)
            {
                messageObj.progress = [NSString stringWithFormat:@"%ld%%",100 * processed / total];
                
            }
            [_allMessages replaceObjectAtIndex:index withObject:messageObj];
        }
        else if (fileMsg.messageType == CUBE_MT_AUDIO)
        {
            //TODO
        }
        else if (fileMsg.messageType == CUBE_MT_VIDEO)
        {
            messageObj = [_sendFileMessageObjectDic objectForKey:fileMsg.fileName];
            index = (int)[_allMessages indexOfObject:messageObj];
            if (nil != messageObj)
            {
                messageObj.progress = [NSString stringWithFormat:@"%ld%%",100 * processed / total];
                
            }
            [_allMessages replaceObjectAtIndex:index withObject:messageObj];
        }
        
        [_msgRecordTable reloadData];

    }
    
    
}
//- (void)onSendProgress:(CubeSession *)session withFileMessage:(CubeFileMessage *)fileMessage withProcessed:(long)processed withTotal:(long)total
//{
//    //DLog(@"文件发送中。。。");
//    CDMMessageObject *message;
//    int index;
//    if (fileMessage.messageType == CUBE_MT_FILE)
//    {
//        message = [_sendFileMessageObjectDic objectForKey:fileMessage.fileName];
//        index = (int)[_allMessages indexOfObject:message];
//        if (nil != message)
//        {
//            message.message = [NSString stringWithFormat:@"发送文件: %@ \n %ld %%",fileMessage.fileName, 100 * processed / total];
//        }
//        [_allMessages replaceObjectAtIndex:index withObject:message];
//    }
//    else if (fileMessage.messageType == CUBE_MT_IMAGE)
//    {
//        //TODO
//        message = [_sendFileMessageObjectDic objectForKey:fileMessage.fileName];
//        index = (int)[_allMessages indexOfObject:message];
//        if (nil != message)
//        {
//            message.progress = [NSString stringWithFormat:@"%ld%%",100 * processed / total];
//            
//        }
//        [_allMessages replaceObjectAtIndex:index withObject:message];
//    }
//    else if (fileMessage.messageType == CUBE_MT_AUDIO)
//    {
//        //TODO
//    }
//    else if (fileMessage.messageType == CUBE_MT_VIDEO)
//    {
//        message = [_sendFileMessageObjectDic objectForKey:fileMessage.fileName];
//        index = (int)[_allMessages indexOfObject:message];
//        if (nil != message)
//        {
//            message.progress = [NSString stringWithFormat:@"%ld%%",100 * processed / total];
//
//        }
//        [_allMessages replaceObjectAtIndex:index withObject:message];
//    }
//    
//    [_msgRecordTable reloadData];
//    
//}
- (void)onSendCompleted:(CubeSession *)session withMessageEntity:(MessageEntity *)message
{
    if (message.messageType == CUBE_MT_TEXT) {
        
    }else{
    DLog(@"文件发送成功");
    CubeFileMessage *fileMsg = (CubeFileMessage *)message;
    CDMMessageObject *messageObj;
    messageObj = [_sendFileMessageObjectDic objectForKey:fileMsg.fileName];
    messageObj.loadingArray = nil;
    [_sendFileMessageDic removeObjectForKey:fileMsg.fileName];
    [_sendFileMessageObjectDic removeObjectForKey:fileMsg.fileName];
    
    [_msgRecordTable reloadData];
    }
}
//- (void)onSendCompleted:(CubeSession *)session withFileMessage:(CubeFileMessage *)fileMessage
//{
//    //TODO
//    DLog(@"文件发送成功");
//    CDMMessageObject *message;
//    message = [_sendFileMessageObjectDic objectForKey:fileMessage.fileName];
//    message.loadingArray = nil;
//    [_sendFileMessageDic removeObjectForKey:fileMessage.fileName];
//    [_sendFileMessageObjectDic removeObjectForKey:fileMessage.fileName];
//
//    [_msgRecordTable reloadData];
//}
- (void)onReceiveProgress:(CubeSession *)session withMessageEntity:(MessageEntity *)message withProcessed:(long)processed withTotal:(long)total
{
    if (message.messageType == CUBE_MT_TEXT) {
        
    }else{
        
    DLog(@"接受中...");
    CubeFileMessage *fileMsg = (CubeFileMessage *)message;
    CDMMessageObject *messageObject;
    NSInteger index;
    //TODO
    if ([fileMsg isKindOfClass:[CubeImageMessage class]])
    {
        messageObject = [_receiveFileMessageObjectDic objectForKey:fileMsg.fileName];
        index = [_allMessages indexOfObject:messageObject];
        
        if (nil != messageObject)
        {
        }else{
            messageObject = [_receiveFileMessageObjectDic objectForKey:[NSString stringWithFormat:@"%@.thumb.jpg",fileMsg.fileName]];
            index = [_allMessages indexOfObject:messageObject];
            messageObject.progress = [NSString stringWithFormat:@"%ld%%",100 * processed / total];
            messageObject.isCurrentPull = YES;
        }
        
    }
    else if ([fileMsg isKindOfClass:[CubeVoiceClipMessage class]])
    {
        //TODO
        messageObject = [_receiveFileMessageObjectDic objectForKey:fileMsg.fileName];
        index = [_allMessages indexOfObject:messageObject];
    }
    else if ([fileMsg isKindOfClass:[CubeVideoClipMessage class]])
    {
        //TODO
        messageObject = [_receiveFileMessageObjectDic objectForKey:fileMsg.fileName];
        index = [_allMessages indexOfObject:messageObject];
        if (nil != messageObject)
        {
            messageObject.progress = nil;
        }else{
            messageObject = [_receiveFileMessageObjectDic objectForKey:[NSString stringWithFormat:@"%@.thumb.jpg",fileMsg.fileName]];
            index = [_allMessages indexOfObject:messageObject];
            
            messageObject.progress = [NSString stringWithFormat:@"%ld%%",100 * processed / total];
            messageObject.isCurrentPull = YES;
        }
        
    }
    else
    {
        messageObject = [_receiveFileMessageObjectDic objectForKey:fileMsg.fileName];
        index = [_allMessages indexOfObject:messageObject];
        if (nil != messageObject)
        {
            messageObject.message = [NSString stringWithFormat:@"接收文件: %@ \n %ld %%",fileMsg.fileName, 100 * processed / total];
        }
        else
        {
        }
    }
    //    if (messageObject != nil) {
    [_allMessages replaceObjectAtIndex:index withObject:messageObject];
    
    [_msgRecordTable reloadData];

    }
}
//- (void)onReceiveProgress:(CubeSession *)session withFileMessage:(CubeFileMessage *)fileMessage withProcessed:(long)processed withTotal:(long)total
//{
//    DLog(@"接受中...");
//    CDMMessageObject *messageObject;
//    NSInteger index;
//    //TODO
//    if ([fileMessage isKindOfClass:[CubeImageMessage class]])
//    {
//        messageObject = [_receiveFileMessageObjectDic objectForKey:fileMessage.fileName];
//        index = [_allMessages indexOfObject:messageObject];
//        
//        if (nil != messageObject)
//        {
//        }else{
//            messageObject = [_receiveFileMessageObjectDic objectForKey:[NSString stringWithFormat:@"%@.thumb.jpg",fileMessage.fileName]];
//            index = [_allMessages indexOfObject:messageObject];
//            messageObject.progress = [NSString stringWithFormat:@"%ld%%",100 * processed / total];
//            messageObject.isCurrentPull = YES;
//        }
//
//    }
//    else if ([fileMessage isKindOfClass:[CubeVoiceClipMessage class]])
//    {
//        //TODO
//        messageObject = [_receiveFileMessageObjectDic objectForKey:fileMessage.fileName];
//        index = [_allMessages indexOfObject:messageObject];
//    }
//    else if ([fileMessage isKindOfClass:[CubeVideoClipMessage class]])
//    {
//        //TODO
//        messageObject = [_receiveFileMessageObjectDic objectForKey:fileMessage.fileName];
//        index = [_allMessages indexOfObject:messageObject];
//        if (nil != messageObject)
//        {
//           messageObject.progress = nil;
//        }else{
//            messageObject = [_receiveFileMessageObjectDic objectForKey:[NSString stringWithFormat:@"%@.thumb.jpg",fileMessage.fileName]];
//            index = [_allMessages indexOfObject:messageObject];
//
//            messageObject.progress = [NSString stringWithFormat:@"%ld%%",100 * processed / total];
//            messageObject.isCurrentPull = YES;
//        }
//
//    }
//    else
//    {
//        messageObject = [_receiveFileMessageObjectDic objectForKey:fileMessage.fileName];
//        index = [_allMessages indexOfObject:messageObject];
//        if (nil != messageObject)
//        {
//            messageObject.message = [NSString stringWithFormat:@"接收文件: %@ \n %ld %%",fileMessage.fileName, 100 * processed / total];
//        }
//        else
//        {
//        }
//    }
////    if (messageObject != nil) {
//        [_allMessages replaceObjectAtIndex:index withObject:messageObject];
//        
//        [_msgRecordTable reloadData];
//
////    }
//}
- (void)onReceiveCompleted:(CubeSession *)session withMessageEntity:(MessageEntity *)message
{
    if (message.messageType == CUBE_MT_TEXT) {
        
    }else{
    CubeFileMessage *fileMessage = (CubeFileMessage *)message;
    DLog(@"接收完成");
    CDMMessageObject *messageObject;
    NSInteger index;
    if ([fileMessage isKindOfClass:[CubeImageMessage class]])
    {
        CubeImageMessage *imageMessage = (CubeImageMessage *)fileMessage;
        messageObject = [_receiveFileMessageObjectDic objectForKey:imageMessage.fileName];
        index = [_allMessages indexOfObject:messageObject];
        if (nil != messageObject)
        {
            UIImage *img;
            if (nil != imageMessage.thumbFile)
            {
                img = [UIImage imageWithData:imageMessage.thumbFile];
                img = [UIImage imageWithCGImage:img.CGImage scale:0 orientation:UIImageOrientationRight];
            }
            else
            {
                img = [UIImage imageNamed:@"error.png"];
            }
            
            messageObject.image = img;
        }else{
            
            messageObject = [_receiveFileMessageObjectDic objectForKey:[NSString stringWithFormat:@"%@.thumb.jpg",imageMessage.fileName]];
            index = [_allMessages indexOfObject:messageObject];
            messageObject.fileData = imageMessage.file;
            messageObject.isComplePlay = YES;
            
            [_receiveFileMessageObjectDic removeObjectForKey:fileMessage.fileName];
        }
        
    }else if ([fileMessage isKindOfClass:[CubeVoiceClipMessage class]])
    {
        CubeVoiceClipMessage *audioClipMessage = (CubeVoiceClipMessage *)fileMessage;
        
        messageObject = [_receiveFileMessageObjectDic objectForKey:audioClipMessage.fileName];
        index = [_allMessages indexOfObject:messageObject];
        if (nil != messageObject)
        {
            messageObject.filePath = audioClipMessage.filePath;
        }
    }
    else if ([fileMessage isKindOfClass:[CubeVideoClipMessage class]])
    {
        CubeVideoClipMessage *videoMessage = (CubeVideoClipMessage *)fileMessage;
        
        messageObject = [_receiveFileMessageObjectDic objectForKey:videoMessage.fileName];
        index = [_allMessages indexOfObject:messageObject];
        if (nil != messageObject)
        {
            messageObject.filePath = videoMessage.filePath;
            
            UIImage *img;
            if (nil != videoMessage.thumbFile)
            {
                img = [UIImage imageWithData:videoMessage.thumbFile];
            }
            else
            {
                img = [UIImage imageNamed:@"error.png"];
            }
            
            messageObject._videoBtn = img;
            
        }
        else
        {
            messageObject = [_receiveFileMessageObjectDic objectForKey:[NSString stringWithFormat:@"%@.thumb.jpg",videoMessage.fileName]];
            index = [_allMessages indexOfObject:messageObject];
            messageObject.fileData = videoMessage.file;
            messageObject.fileName = videoMessage.fileName;
            
            messageObject.isComplePlay = YES;
            
            [_receiveFileMessageObjectDic removeObjectForKey:fileMessage.fileName];
        }
        
    }else
    {
        messageObject = [_receiveFileMessageObjectDic objectForKey:fileMessage.fileName];
        index = [_allMessages indexOfObject:messageObject];
    }
    
    [_allMessages replaceObjectAtIndex:index withObject:messageObject];
    
    [_msgRecordTable reloadData];
    
    [_receiveFileMessageDic removeObjectForKey:fileMessage.fileName];
    
    }
}
//- (void)onReceiveCompleted:(CubeSession *)session withFileMessage:(CubeFileMessage *)fileMessage
//{
//    //TODO
//    DLog(@"接收完成");
////    DLog(@"onReceiveCompleted imgMsg.name = %@", fileMessage.fileName);
////    DLog(@"onReceiveCompleted imgMsg.file = %@",fileMessage.file);
//    CDMMessageObject *messageObject;
//    NSInteger index;
//    if ([fileMessage isKindOfClass:[CubeImageMessage class]])
//    {
//        CubeImageMessage *imageMessage = (CubeImageMessage *)fileMessage;
//        messageObject = [_receiveFileMessageObjectDic objectForKey:imageMessage.fileName];
//        index = [_allMessages indexOfObject:messageObject];
//        if (nil != messageObject)
//        {
//            UIImage *img;
//            if (nil != imageMessage.thumbFile)
//            {
//                img = [UIImage imageWithData:imageMessage.thumbFile];
//            }
//            else
//            {
//                img = [UIImage imageNamed:@"error.png"];
//            }
//            
//            messageObject.image = img;
//        }else{
//            
//            messageObject = [_receiveFileMessageObjectDic objectForKey:[NSString stringWithFormat:@"%@.thumb.jpg",imageMessage.fileName]];
//            index = [_allMessages indexOfObject:messageObject];
//            messageObject.fileData = imageMessage.file;
//            messageObject.isComplePlay = YES;
//            
//            [_receiveFileMessageObjectDic removeObjectForKey:fileMessage.fileName];
//        }
//
//    }else if ([fileMessage isKindOfClass:[CubeVoiceClipMessage class]])
//    {
//        CubeVoiceClipMessage *audioClipMessage = (CubeVoiceClipMessage *)fileMessage;
//
//        messageObject = [_receiveFileMessageObjectDic objectForKey:audioClipMessage.fileName];
//        index = [_allMessages indexOfObject:messageObject];
//        if (nil != messageObject)
//        {
//            messageObject.filePath = audioClipMessage.filePath;
//        }
//    }
//    else if ([fileMessage isKindOfClass:[CubeVideoClipMessage class]])
//    {
//        CubeVideoClipMessage *videoMessage = (CubeVideoClipMessage *)fileMessage;
//        
//        messageObject = [_receiveFileMessageObjectDic objectForKey:videoMessage.fileName];
//        index = [_allMessages indexOfObject:messageObject];
//        if (nil != messageObject)
//        {
//            messageObject.filePath = videoMessage.filePath;
//            
//            UIImage *img;
//            if (nil != videoMessage.thumbFile)
//            {
//                img = [UIImage imageWithData:videoMessage.thumbFile];
//            }
//            else
//            {
//                img = [UIImage imageNamed:@"error.png"];
//            }
//            
//            messageObject._videoBtn = img;
//
//        }
//        else
//        {
//            messageObject = [_receiveFileMessageObjectDic objectForKey:[NSString stringWithFormat:@"%@.thumb.jpg",videoMessage.fileName]];
//            index = [_allMessages indexOfObject:messageObject];
//            messageObject.fileData = videoMessage.file;
//            messageObject.fileName = videoMessage.fileName;
//
//            messageObject.isComplePlay = YES;
//            
//            [_receiveFileMessageObjectDic removeObjectForKey:fileMessage.fileName];
//        }
//        
//    }else
//    {
//        messageObject = [_receiveFileMessageObjectDic objectForKey:fileMessage.fileName];
//        index = [_allMessages indexOfObject:messageObject];
//    }
//    
//    [_allMessages replaceObjectAtIndex:index withObject:messageObject];
//
//    [_msgRecordTable reloadData];
//    
//    [_receiveFileMessageDic removeObjectForKey:fileMessage.fileName];
//}

#pragma mark - PrivateMethod
- (void)acceptImageMessage:(CubeImageMessage *)imgMsg
{
    DLog(@"imgMsg.name = %@", imgMsg.fileName);
    [[CubeEngine sharedSingleton] acceptFileMessage:imgMsg];
    
    [self createTimestamp:imgMsg.sendTime];

    CDMMessageObject *msgObject = [[CDMMessageObject alloc] init];
    msgObject.name = imgMsg.sender.displayName;
    msgObject.msgStyle = KMessageCellStyleOtherWithImage;
    
    if (nil == _receiveFileMessageObjectDic)
    {
        _receiveFileMessageObjectDic  = [NSMutableDictionary dictionary];
    }
    [_receiveFileMessageObjectDic setObject:msgObject forKey:imgMsg.fileName];
    
    [_allMessages addObject:msgObject];
    [_msgRecordTable reloadData];
    [_msgRecordTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_allMessages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)acceptAudioMessage:(CubeVoiceClipMessage *)audioMsg
{
    DLog(@"audioMsg.name = %@", audioMsg.fileName);
    //TODO 收语音
    [[CubeEngine sharedSingleton] acceptFileMessage:audioMsg];
    
    [self createTimestamp:audioMsg.sendTime];

    CDMMessageObject *msgObject = [[CDMMessageObject alloc] init];
    msgObject.name = audioMsg.sender.displayName;
    msgObject._voiceBtn = [UIImage imageNamed:@"ToolViewInputVoice"];
    msgObject.msgStyle = KMessageCellStyleOtherWithVoice;
    
    if (nil == _receiveFileMessageObjectDic)
    {
        _receiveFileMessageObjectDic  = [NSMutableDictionary dictionary];
    }
    [_receiveFileMessageObjectDic setObject:msgObject forKey:audioMsg.fileName];
    
    [_allMessages addObject:msgObject];
    [_msgRecordTable reloadData];
    [_msgRecordTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_allMessages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)createTimestamp:(long long)time
{
    //TODO 时间戳
    CDMMessageObject *timeObject = [[CDMMessageObject alloc]init];
    timeObject.timeStamp = [NSString stringWithFormat:@"%@", [CBUtils dateFromTimeStampMillis:time withDateFormat:@"HH:mm:ss"]];
    timeObject.msgStyle = KMessageCellStyleTimeStamp;
    [_allMessages addObject:timeObject];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    CubeFileMessage *message = [_receiveFileMessageDic objectForKey:_receiveFileMsgName];
    if (0 == buttonIndex)
    {
        //reject
        [[CubeEngine sharedSingleton] rejectFileMessage:message];
        
        [self createTimestamp:message.sendTime];
        
        CDMMessageObject *msgObject = [[CDMMessageObject alloc] init];
        msgObject.name = message.sender.displayName;
        msgObject.message = [NSString stringWithFormat:@"拒绝文件: %@ 0 %%",message.fileName];
        msgObject.msgStyle = KMessageCellStyleMe;
        
        [_allMessages addObject:msgObject];
        [_msgRecordTable reloadData];
        [_msgRecordTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_allMessages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    else if (1 == buttonIndex)
    {
        //accept
        [[CubeEngine sharedSingleton] acceptFileMessage:message];
        
        [self createTimestamp:message.sendTime];
        
        CDMMessageObject *msgObject;

        if ([message isKindOfClass:[CubeVideoClipMessage class]])
        {
            //TODO 视频文件
            msgObject = [[CDMMessageObject alloc] init];
            msgObject.name = message.sender.displayName;
            msgObject.msgStyle = kmessagecellstyleOtherWithVideo;
        }
        else if ([message isKindOfClass:[CubeFileMessage class]])
        {
            msgObject = [[CDMMessageObject alloc] init];
            msgObject.name = message.sender.displayName;
            msgObject.message = [NSString stringWithFormat:@"接收文件: %@ \n 0 %%",message.fileName];
            msgObject.msgStyle = KMessageCellStyleOther;
        }
        
        if (nil == _receiveFileMessageObjectDic)
        {
            _receiveFileMessageObjectDic  = [NSMutableDictionary dictionary];
        }
        [_receiveFileMessageObjectDic setObject:msgObject forKey:message.fileName];
        
        [_allMessages addObject:msgObject];
        [_msgRecordTable reloadData];
        [_msgRecordTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_allMessages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    else
    {
        //Nothing
    }
}

#pragma mark   ---------tableView协议----------------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _allMessages.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier=@"friendCell";
    CDMMessageCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[CDMMessageCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    CDMMessageObject *msg = _allMessages[indexPath.row];
    cell.messageObject = msg;
    
    if (msg.msgStyle == kmessagecellstyleMeWithVideo || msg.msgStyle == kmessagecellstyleOtherWithVideo) {
        
        cell.videoBtn.tag = indexPath.row;
        [cell.videoBtn addTarget:self action:@selector(playVideoBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (msg.msgStyle == KMessageCellStyleMeWithImage || msg.msgStyle == KMessageCellStyleOtherWithImage) {
        
        cell.chatImage.tag = indexPath.row;
        [cell.chatImage addTarget:self action:@selector(checkClickImage:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return cell;
}

- (void)playVideoBtn:(UIButton *)btn
{
     CDMMessageObject *msg = _allMessages[btn.tag];
    if (msg.msgStyle == kmessagecellstyleMeWithVideo)
    {
        msg.isComplePlay = YES;
    }
    else if (msg.msgStyle == kmessagecellstyleOtherWithVideo)
    {
        if (msg.isCurrentPull == YES)
        {
            DLog(@"当前正在加载。。。");
        }
        else
        {
            CubeFileMessage *message = [_receiveFileMessageDic objectForKey:_receiveFileMsgName];
            [[CubeEngine sharedSingleton] acceptFileMessage:message];
        }
    }

    if (msg.isComplePlay == YES) {
        
        [self closeKeyBoard];
        DLog(@"msg.fileName =++= %@",msg.fileName);
        NSString *videoFilePath = [self RecordVideoDatatoURL:msg.fileData withFileName:msg.fileName];

        [[CubeEngine sharedSingleton].mediaController loadPlayVideoViewWithPlayURL:videoFilePath];
        [self.navigationController.view addSubview:[CubeEngine sharedSingleton].mediaController.playView];
        
//        MPMoviePlayerViewController *mp = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:videoFilePath]];
//        
//        [self presentMoviePlayerViewControllerAnimated:mp];
//        [mp.moviePlayer play];
        

    }else{
        DLog(@"正在加载。。。");
    }
   
}

- (NSString *)RecordVideoDatatoURL:(NSData *)data withFileName:(NSString *)fileName
{
    
    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString* filePath = [directory stringByAppendingPathComponent:fileName];

    
    NSFileManager *ma = [NSFileManager defaultManager];
    if ([ma fileExistsAtPath:filePath]) {
//        NSURL *videoUrl = [NSURL fileURLWithPath:filePath];
        
        return filePath;
    }else
   
    [data writeToFile:filePath atomically:YES];
//    NSURL *videoUrl = [NSURL fileURLWithPath:filePath];
    
    return filePath;
}
- (void)checkClickImage:(UIButton *)btn
{
    
    CDMMessageObject *msg = _allMessages[btn.tag];

    if (msg.msgStyle == KMessageCellStyleMeWithImage) {
        msg.isComplePlay = YES;
    }else if (msg.msgStyle == KMessageCellStyleOtherWithImage){
        if (msg.isCurrentPull == YES) {
            
            DLog(@"当前正在加载。。。");
        }else{
            CubeFileMessage *message = [_receiveFileMessageDic objectForKey:_receiveFileMsgName];
            [[CubeEngine sharedSingleton] acceptFileMessage:message];
        }
    }
    
    if (msg.isComplePlay == YES) {
        
        [self closeKeyBoard];
        
        _bigView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWidth, KHeight)];
        _bigView.backgroundColor = [UIColor blackColor];
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backClickImage:)];
        [_bigView addGestureRecognizer:_tap];
        
        _bigImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, (KHeight-KWidth)/2, KWidth, KWidth)];
//        im.userInteractionEnabled = YES;
        _bigImage.image = [UIImage imageWithData:msg.fileData];
        [_bigView addSubview:_bigImage];
        [self.navigationController.view addSubview:_bigView];
            
    }else{
        DLog(@"正在加载。。。");
    }

}
- (void)backClickImage:(UITapGestureRecognizer *)tapGesture
{
    [_bigView removeGestureRecognizer:_tap];
    [_bigView removeFromSuperview];
    [_bigImage removeFromSuperview];
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CDMMessageObject *msgObject = _allMessages[indexPath.row];
    
    if (msgObject.msgStyle == KMessageCellStyleMeWithImage || msgObject.msgStyle == KMessageCellStyleOtherWithImage || msgObject.msgStyle == kmessagecellstyleMeWithVideo || msgObject.msgStyle == kmessagecellstyleOtherWithVideo){
        
        return 55 + 100;
    }else{
        
        NSString *orgin = [_allMessages[indexPath.row] message];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CGSize textSize = [orgin sizeWithFont:[UIFont systemFontOfSize:15]
                        constrainedToSize:CGSizeMake((320-HEAD_SIZE-3*INSETS-40), TEXT_MAX_HEIGHT) lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
    return 55 + textSize.height;
    }
    
}

#pragma mark ----------图片选择完成-------------
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //图片时
    [picker dismissViewControllerAnimated:YES completion:nil];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        CubeFileMessage *fileMessage;
        UIImage *pickerImage = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        if ([mediaType isEqualToString:@"public.image"])
        {
            //图片名称
            NSDateFormatter *inFormat = [NSDateFormatter new];
            [inFormat setDateFormat:@"yyMMdd-HHmmss"];
            NSString *imageName = [NSString stringWithFormat:@"image-%@.JPG", [inFormat stringFromDate:[NSDate date]]];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];
            //UIImage -->> NSData
            NSData *imageData = UIImageJPEGRepresentation(pickerImage, 1.0);
            //写入沙盒
            [imageData writeToFile:filePath atomically:YES];
            
            Receiver *receiver = [[Receiver alloc] initWithName:peerName];
            receiver.displayName = peerName;
            
            Sender *sender = [[Sender alloc]initWithName:myCallName];
            sender.displayName = myDisName;
            
            CubeImageMessage *imageMessage = [[CubeImageMessage alloc]initWithFile:imageData andFileName:imageName andReceiver:receiver andSender:sender];
            [imageMessage setImageWidth:pickerImage.size.width andHeight:pickerImage.size.height];
            
            fileMessage = imageMessage;
        }
        
        if ([[CubeEngine sharedSingleton] sendFileMessage:fileMessage])
        {}
        else
        {}
    });
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark ---触摸关闭键盘----
-(void)handleTap:(UIGestureRecognizer *)gesture
{
    [self closeKeyBoard];
}

- (void)closeKeyBoard
{
    if ([_messageText isFirstResponder])
    {
        [_messageText resignFirstResponder];
        [_messageText setInputView:nil];
    }
    CGRect frame = _inputBar.frame;
    frame.origin.y = self.view.frame.size.height - frame.size.height;
    _inputBar.frame = frame;
    
    CGRect tableFrame = _msgRecordTable.frame;
    tableFrame.origin.y = 0;
    _msgRecordTable.frame = tableFrame;
    [_msgRecordTable setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
}


#pragma mark ----键盘高度变化------
-(void)changeKeyBoard:(NSNotification *)aNotifacation
{
    NSDictionary *info = [aNotifacation userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSValue *keyboardEndBounds=[info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect endRect=[keyboardEndBounds CGRectValue];

    [CATransaction begin];
    [UIView animateWithDuration:duration animations:^{
        CGRect frame = _inputBar.frame;
        
        if (_messageText.isFirstResponder) {
            frame.origin.y = self.view.frame.size.height - endRect.size.height - frame.size.height;
        } else {
            //没有调用
            frame.origin.y = self.view.frame.size.height - frame.size.height;
        }
        _inputBar.frame = frame;
        
        CGRect tableFrame = _msgRecordTable.frame;
        tableFrame.origin.y = - endRect.size.height;
        _msgRecordTable.frame = tableFrame;
        [_msgRecordTable setContentInset:UIEdgeInsetsMake(endRect.size.height, 0, 0, 0)];
        
    } completion:^(BOOL finished) {
        
    }];
    [CATransaction commit];
}

@end
