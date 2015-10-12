//
//  WBFilePickerController.h
//  CubeDemo
//
//  Created by guoqiangzhu on 15/9/20.
//  Copyright (c) 2015年 CubeTeam. All rights reserved.
//

#import "ViewController.h"
#import <QuickLook/QuickLook.h>

@class WBFilePickerController;

@protocol WBFilePickerDelegate <NSObject>

- (void)filePickerController:(WBFilePickerController *)pickerController didFinishPickingFiles:(NSArray *)fileUrls;

- (void)filePickerControllerDidCanclePicker:(WBFilePickerController *)pickerController;

@end

@interface WBFilePickerController : ViewController <UITableViewDataSource,
UITableViewDelegate,QLPreviewControllerDataSource,QLPreviewControllerDelegate,UIDocumentInteractionControllerDelegate>

@property (nonatomic, assign) id<WBFilePickerDelegate>delegate;

//fileListTable : 文件选择列表
@property (strong, nonatomic) IBOutlet UITableView *fileListTable;

//dirArray : 存储沙盒子里面的所有文件
@property(nonatomic,retain) NSMutableArray *dirArray;

//UIDocumentInteractionController : 一个文件交互控制器,提供应用程序管理与本地系统中的文件的用户交互的支持
@property (nonatomic, strong) UIDocumentInteractionController *docInteractionController;

@end
