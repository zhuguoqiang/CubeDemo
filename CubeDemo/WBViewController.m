//
//  WBViewController.m
//  CubeDemo
//
//  Created by guoqiangzhu on 15/8/26.
//  Copyright (c) 2015年 CubeTeam. All rights reserved.
//

#import "WBViewController.h"
#import "Cube.h"
#import "CBUtils.h"
#import "MBProgressHUD+Add.h"

#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height
#define BTN_W 60
#define BTN_H 40
#define PADDING 10
#define TOOLBAR_H 44

@interface WBViewController () <CubeWhiteboardDelegate>
{
    UILabel *_lbFileName;
    UILabel *_lbPage;
    UIButton *_prevBtn;
    UIButton *_nextBtn;
    UIView *_slideView;
    
    MBProgressHUD *_processHUD;
}

@end

@implementation WBViewController

@synthesize peerName = _peerName;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [CubeEngine sharedSingleton].whiteboardDelegate = self;
    
    [[CubeEngine sharedSingleton] loadWhiteboard];
    
    CGRect frame = self.view.frame;
    frame.size.height -= TOOLBAR_H;
    
    [[[CubeEngine sharedSingleton] getWhiteboard] changeFrame:frame];
    
    [self.view addSubview:[[CubeEngine sharedSingleton] getWhiteboard].view];
    
    UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, frame.size.height, frame.size.width, TOOLBAR_H)];
    //分享
    UIBarButtonItem *shareWithItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(shareWithItemAction:)];
    //取消选择
    //铅笔
    UIBarButtonItem *pencilItem = [[UIBarButtonItem alloc] initWithTitle:@"铅笔" style:UIBarButtonItemStylePlain target:self action:@selector(pencilItemAction:)];
    //文本
    UIBarButtonItem *textItem = [[UIBarButtonItem alloc] initWithTitle:@"文本" style:UIBarButtonItemStylePlain target:self action:@selector(textItemAction:)];
    //方框
    UIBarButtonItem *rectItem = [[UIBarButtonItem alloc] initWithTitle:@"方框" style:UIBarButtonItemStylePlain target:self action:@selector(rectItemAction:)];
    //圆圈
    UIBarButtonItem *ellipseItem = [[UIBarButtonItem alloc] initWithTitle:@"圆圈" style:UIBarButtonItemStylePlain target:self action:@selector(ellipseItemAction:)];
    //撤销
    UIBarButtonItem *undoItem = [[UIBarButtonItem alloc] initWithTitle:@"撤销" style:UIBarButtonItemStylePlain target:self action:@selector(undoItemAction:)];
    //重做
    UIBarButtonItem *redoItem = [[UIBarButtonItem alloc] initWithTitle:@"重做" style:UIBarButtonItemStylePlain target:self action:@selector(redoItemAction:)];
    
    //擦除
    UIBarButtonItem *eraseItem = [[UIBarButtonItem alloc] initWithTitle:@"擦除" style:UIBarButtonItemStylePlain target:self action:@selector(eraseItemAction:)];
    //清空
    UIBarButtonItem *cleanupItem = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(cleanupItemAction:)];
    //保存
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveItemAction:)];
    //改颜色
    UIBarButtonItem *colorItem = [[UIBarButtonItem alloc] initWithTitle:@"调色" style:UIBarButtonItemStylePlain target:self action:@selector(colorItemAction:)];
    //粗细
    UIBarButtonItem *lineWeightItem = [[UIBarButtonItem alloc] initWithTitle:@"线重" style:UIBarButtonItemStylePlain target:self action:@selector(lineWeightItemAction:)];
    //缩放
    UIBarButtonItem *zoomItem = [[UIBarButtonItem alloc] initWithTitle:@"缩放" style:UIBarButtonItemStylePlain target:self action:@selector(zoomItemAction:)];
    
    // 文件
    UIBarButtonItem *fileItem = [[UIBarButtonItem alloc] initWithTitle:@"文件" style:UIBarButtonItemStylePlain target:self action:@selector(fileItemAction:)];
    toolbar.items = [NSArray arrayWithObjects:pencilItem, colorItem, lineWeightItem, undoItem, redoItem, eraseItem, fileItem, nil];
    
    [self.view addSubview:toolbar];
    
    //翻页
    _slideView = [[UIView alloc] initWithFrame:CGRectZero];
    //文件名
    _lbFileName = [[UILabel alloc] initWithFrame:CGRectMake(PADDING, 0, SCREEN_W - 4 * PADDING - 3 * BTN_W, BTN_H)];
    [_lbFileName setBackgroundColor:[UIColor clearColor]];
    [_lbFileName setText:@""];
    [_slideView addSubview:_lbFileName];
    
    // 当前页/总页数
    _lbPage = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_W - 3 * PADDING - 3 * BTN_W, 0, BTN_W, BTN_H)];
    [_lbPage setBackgroundColor:[UIColor clearColor]];
    [_lbPage setText:@"0/0"];
    [_slideView addSubview:_lbPage];
    //上一页
    _prevBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_W - 2 * PADDING - 2 * BTN_W, 0, BTN_W, BTN_H)];
    [_prevBtn addTarget:self action:@selector(prevBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_prevBtn setTitle:@"上一页" forState:UIControlStateNormal];
    [_prevBtn setBackgroundColor:[UIColor clearColor]];
    [_prevBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_slideView addSubview:_prevBtn];
    
    //下一页
    _nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_W - PADDING - BTN_W, 0, BTN_W, BTN_H)];
    [_nextBtn addTarget:self action:@selector(nextBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_nextBtn setTitle:@"下一页" forState:UIControlStateNormal];
    [_nextBtn setBackgroundColor:[UIColor clearColor]];
    [_nextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_slideView addSubview:_nextBtn];
    [_slideView setFrame:CGRectMake(0, SCREEN_H - BTN_H - TOOLBAR_H - PADDING , SCREEN_W, BTN_H)];
    [_slideView setHidden:YES];
    [self.view addSubview:_slideView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.title = [NSString stringWithFormat:@"%@", _peerName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CubeWhiteboardDelegate
- (void)onReady:(CubeWhiteboard *)whiteboard
{
    [[[CubeEngine sharedSingleton] getWhiteboard] shareWith:[NSArray arrayWithObjects:_peerName, nil]];
}

- (void)onShared:(CubeWhiteboard *)whiteboard andSharedList:(NSArray *)sharedList
{
    if (sharedList.count != 0)
    {
        for (NSString *name in sharedList)
        {
            NSString *str =[NSString stringWithFormat:@"与%@分享白板", name];
            self.title = str;
        }
    }
}
- (void)onFileShared:(CubeWhiteboard *)whiteboard andFile:(CubeSharedFile *)file
{
    DLog(@"分享文件信息: %@", file.originFileName);
}

- (void)onFileSharing:(CubeWhiteboard *)whiteboard andProgress:(NSString *)progress
{
    //TODO 转换进度
    DLog(@"fileSharing: %@", progress);
    if ([progress isEqualToString:@"RUNNING"])
    {
        [self setProcessInfo:@"文件处理..."];
        
    }
    else if ([progress isEqualToString:@"COMPLETED"])
    {
        [self setProcessInfo:@"文件处理完成"];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (nil != _processHUD)
            {
                [_processHUD hide:YES];
            }
        });
        
    }
}

- (void)onWhiteboard:(CubeWhiteboard *)whiteboard andSlide:(CubeSlideEntity *)slide
{
    [_slideView setHidden:NO];

    [_lbFileName setText:slide.docName];
    [_lbPage setText:[NSString stringWithFormat:@"%d/%d", slide.currentPage, slide.numsOfPage]];
}

- (void)onRevoke:(CubeWhiteboard *)whiteboard
{
    //停止分享
    self.title = [NSString stringWithFormat:@"停止分享"];
}

- (void)onFailed:(CubeWhiteboard *)whiteboard andErrorCode:(CubeWBErrorCode)errorCode
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (nil != _processHUD)
        {
            [_processHUD hide:YES];
        }
        
        NSString *err = [NSString stringWithFormat:@"分享错误码： %d", errorCode];
        [MBProgressHUD showError:err toView:self.view];
    });
}

#pragma mark - Whiteboard Control
- (void)pencilItemAction:(id)sender
{
    [[[CubeEngine sharedSingleton] getWhiteboard] selectPencil];
}

- (void)textItemAction:(id)sender
{
    [[[CubeEngine sharedSingleton] getWhiteboard] selectText];
}

- (void)rectItemAction:(id)sender
{
    [[[CubeEngine sharedSingleton] getWhiteboard] selectRect];
}

- (void)ellipseItemAction:(id)sender
{
    [[[CubeEngine sharedSingleton] getWhiteboard] selectEllipse];
}

- (void)undoItemAction:(id)sender
{
    [[[CubeEngine sharedSingleton] getWhiteboard] undo];
}

- (void)redoItemAction:(id)sender
{
    [[[CubeEngine sharedSingleton] getWhiteboard] redo];
}

- (void)eraseItemAction:(id)sender
{
    [[[CubeEngine sharedSingleton] getWhiteboard] erase];
}

- (void)cleanupItemAction:(id)sender
{
    [[[CubeEngine sharedSingleton] getWhiteboard] cleanup];
}

- (void)saveItemAction:(id)sender
{
    [[[CubeEngine sharedSingleton] getWhiteboard] saveToServer];
}

- (void)colorItemAction:(id)sender
{
    UIColor *color = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
    [[[CubeEngine sharedSingleton] getWhiteboard] configLineColor:color];
}

- (void)lineWeightItemAction:(id)sender
{
    int lineWeight = 12;
    [[[CubeEngine sharedSingleton] getWhiteboard] configLineWeight:lineWeight];
}

- (void)zoomItemAction:(id)sender
{
//    [[[CubeEngine sharedSingleton] getWhiteboard] zoomWithRatio:0.5];
}

- (void)fileItemAction:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"文件" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"本地图片" otherButtonTitles:@"本地文件", nil];
    [actionSheet showInView:self.view];
}


- (void)shareWithItemAction:(id)sender
{
    if ([[[CubeEngine sharedSingleton]getWhiteboard] isSharing])
    {
        [[[CubeEngine sharedSingleton] getWhiteboard] revokeSharing];
    }else
    {
        [[[CubeEngine sharedSingleton] getWhiteboard] shareWith:@[_peerName]];
    }
}

- (void)prevBtnAction:(id)sender
{
    [[[CubeEngine sharedSingleton] getWhiteboard] prevPage];
}

- (void)nextBtnAction:(id)sender
{
    [[[CubeEngine sharedSingleton] getWhiteboard] nextPage];
}

#pragma mark - Private

- (void)setProcessInfo:(NSString *)info
{
     dispatch_async(dispatch_get_main_queue(), ^{
        if (nil == _processHUD)
        {
            _processHUD = [[MBProgressHUD alloc] initWithView:self.view];
    
        }
        [self.view addSubview:_processHUD];
        _processHUD.labelText = info;
        _processHUD.mode = MBProgressHUDModeIndeterminate;
        _processHUD.removeFromSuperViewOnHide = YES;
    
        [_processHUD show:YES];
    });
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    switch (buttonIndex)
    {
        case 0:
        {
            //本地图片
            UIImagePickerController *imgPicker = [[UIImagePickerController alloc]init];
            [imgPicker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
            [imgPicker setDelegate:self];
            [imgPicker setAllowsEditing:NO];
            [self presentViewController:imgPicker animated:YES completion:^{
                //Nothing
            }];
        }
            break;
        case 1:
        {
            //本地文件
            WBFilePickerController *filePicker = [[WBFilePickerController alloc] initWithNibName:@"WBFilePickerController" bundle:nil];
            filePicker.delegate = self;
            [filePicker setTitle:@"本地文件"];
            [self.navigationController pushViewController:filePicker animated:YES];
        }
            break;
        case 2:
        {
            //Cancel
            //Nothing
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (picker.sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum) {
        //图片时
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        UIImage *pickerImage = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        NSURL *fileUrl = nil;
        if ([mediaType isEqualToString:@"public.image"])
        {
            //UIImage -->> NSData
            NSData *imageData = UIImageJPEGRepresentation(pickerImage, 1.0);
            //图片名称
            NSDateFormatter *inFormat = [NSDateFormatter new];
            [inFormat setDateFormat:@"yyMMdd-HHmmss"];
            NSString *imageName = [NSString stringWithFormat:@"image-%@.JPG", [inFormat stringFromDate:[NSDate date]]];
            //沙盒路径
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsPath = [paths objectAtIndex:0];
            NSString *filePath = [documentsPath stringByAppendingPathComponent:imageName];
            //写入沙盒
            [imageData writeToFile:filePath atomically:YES];
            
            fileUrl = [NSURL fileURLWithPath:filePath];
        }
        //白板发送文件
        [self setProcessInfo:[NSString stringWithFormat:@"上传文件"]];
        [[[CubeEngine sharedSingleton] getWhiteboard] sendFile:fileUrl];
        

    }

}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - WBFilePickerDelegate

- (void)filePickerController:(WBFilePickerController *)pickerController didFinishPickingFiles:(NSArray *)fileUrls
{
    for (NSURL *fileUrl in fileUrls)
    {
        [self setProcessInfo:[NSString stringWithFormat:@"上传文件"]];
        //白板发送文件
        [[[CubeEngine sharedSingleton] getWhiteboard] sendFile:fileUrl];
        
    }
}

- (void)filePickerControllerDidCanclePicker:(WBFilePickerController *)pickerController
{
    //Nothing
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
