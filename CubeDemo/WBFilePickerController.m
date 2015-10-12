//
//  WBFilePickerController.m
//  CubeDemo
//
//  Created by guoqiangzhu on 15/9/20.
//  Copyright (c) 2015年 CubeTeam. All rights reserved.
//

#import "WBFilePickerController.h"

#define DOCUMENTS_DIR_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

@interface WBFilePickerController ()
{
    BOOL _edit;
    NSMutableArray *_selectedArray;
}
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *confirmItem;

@end

@implementation WBFilePickerController

@synthesize delegate;
@synthesize fileListTable = _fileListTable;
@synthesize dirArray;
@synthesize docInteractionController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _edit = NO;
    [_cancelItem setEnabled:NO];
    [_confirmItem setEnabled:NO];
    
    
    _fileListTable.dataSource = self;
    _fileListTable.delegate = self;
    
    [self buildData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)buildData
{
    //FileManager
    NSFileManager *fm = [NSFileManager defaultManager];
    
    //step5. 保存一份pdf文件到设备Documents文件夹中(为了测试方便)
    NSString *fileName = @"Test.pdf";
    NSString *pdfFilePath = [DOCUMENTS_DIR_PATH stringByAppendingPathComponent:fileName];
    NSString *tmpPath = [[NSBundle mainBundle] pathForResource:@"/assets/Test" ofType:@"pdf"];
    if (![fm fileExistsAtPath:pdfFilePath])
    {
        [fm copyItemAtPath:tmpPath toPath:pdfFilePath error:nil];
    }
    
    //step5. 保存一份pdf文件到设备document文件夹中(为了测试方便)
    NSString *docFileName = @"AliYunServer.doc";
    NSString *docFilepath = [DOCUMENTS_DIR_PATH stringByAppendingPathComponent:docFileName];
    NSString *tmpDocPath = [[NSBundle mainBundle] pathForResource:@"/assets/AliYunServer" ofType:@"doc"];
    if (![fm fileExistsAtPath:docFilepath])
    {
        [fm copyItemAtPath:tmpDocPath toPath:docFilepath error:nil];
    }
    
    //step6. 获取沙盒里所有文件
    NSError *error = nil;
    NSArray *fileList = [[NSArray alloc] init];
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    fileList = [fm contentsOfDirectoryAtPath:DOCUMENTS_DIR_PATH error:&error];
    
    self.dirArray = [[NSMutableArray alloc] init];
    for (NSString *file in fileList)
    {
        [self.dirArray addObject:file];
    }
    
    //step6. 刷新列表, 显示数据
    [_fileListTable reloadData];
}
- (IBAction)editItemAction:(id)sender
{
    _edit = YES;
    [_editItem setEnabled:NO];
    [_cancelItem setEnabled:YES];
}

- (IBAction)cancelItemAction:(id)sender
{
    _edit = NO;
    [_editItem setEnabled:YES];
    [_cancelItem setEnabled:NO];
    [_confirmItem setEnabled:NO];
    
    
    if (0 != _selectedArray.count)
    {
        [_selectedArray removeAllObjects];
    }
    
    if (nil != delegate && [delegate respondsToSelector:@selector(filePickerControllerDidCanclePicker:)])
    {
        [delegate filePickerControllerDidCanclePicker:self];
    }

}
- (IBAction)confirmItemAction:(id)sender
{
    _edit = NO;
    [_editItem setEnabled:YES];
    [_cancelItem setEnabled:NO];
    [_confirmItem setEnabled:NO];
    
    //TODO
    if (nil != delegate && [delegate respondsToSelector:@selector(filePickerController:didFinishPickingFiles:)])
    {
        [delegate filePickerController:self didFinishPickingFiles:_selectedArray];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}



//step7. 利用url路径打开UIDocumentInteractionController
- (void)setupDocumentControllerWithURL:(NSURL *)url
{
    if (self.docInteractionController == nil)
    {
        self.docInteractionController = [UIDocumentInteractionController interactionControllerWithURL:url];
        self.docInteractionController.delegate = self;
    }
    else
    {
        self.docInteractionController.URL = url;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- 列表操作
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellName = @"WBFilePickerControllerCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellName];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellName];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    NSURL *fileURL= nil;
    
    NSString *path = [DOCUMENTS_DIR_PATH stringByAppendingPathComponent:[self.dirArray objectAtIndex:indexPath.row]];
    fileURL = [NSURL fileURLWithPath:path];
    
    [self setupDocumentControllerWithURL:fileURL];
    cell.textLabel.text = [self.dirArray objectAtIndex:indexPath.row];
    NSInteger iconCount = [self.docInteractionController.icons count];
    if (iconCount > 0)
    {
        cell.imageView.image = [self.docInteractionController.icons objectAtIndex:iconCount - 1];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dirArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_edit)
    {
        UITableViewCell *cell = [_fileListTable cellForRowAtIndexPath:indexPath];
        NSString *path = [DOCUMENTS_DIR_PATH stringByAppendingPathComponent:[self.dirArray objectAtIndex:indexPath.row]];
        NSURL *URL = [NSURL fileURLWithPath:path];
        
        if (nil == _selectedArray)
        {
            _selectedArray = [[NSMutableArray alloc]initWithCapacity:2];
        }
        
        BOOL isChecked = cell.accessoryType == UITableViewCellAccessoryCheckmark;
        if (isChecked)
        {
            [cell setAccessoryType: UITableViewCellAccessoryNone];
            [_selectedArray removeObject:URL];
        }
        else
        {
            [cell setAccessoryType: UITableViewCellAccessoryCheckmark];
            [_selectedArray addObject:URL];
        }
        
        [self.confirmItem setEnabled:_selectedArray.count != 0];
    }
    else
    {
        QLPreviewController *previewController = [[QLPreviewController alloc] init];
        previewController.dataSource = self;
        previewController.delegate = self;
        
        // start previewing the document at the current section index
        previewController.currentPreviewItemIndex = indexPath.row;
        [[self navigationController] pushViewController:previewController animated:YES];
    }
}


#pragma mark - UIDocumentInteractionControllerDelegate

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)interactionController
{
    return self;
}

#pragma mark - QLPreviewControllerDataSource

// Returns the number of items that the preview controller should preview
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)previewController
{
    return 1;
}

- (void)previewControllerDidDismiss:(QLPreviewController *)controller
{
    // if the preview dismissed (done button touched), use this method to post-process previews
}

// returns the item that the preview controller should preview
- (id)previewController:(QLPreviewController *)previewController previewItemAtIndex:(NSInteger)idx
{
    NSURL *fileURL = nil;
    NSIndexPath *selectedIndexPath = [_fileListTable indexPathForSelectedRow];
    NSString *path = [DOCUMENTS_DIR_PATH stringByAppendingPathComponent:[self.dirArray objectAtIndex:selectedIndexPath.row]];
    fileURL = [NSURL fileURLWithPath:path];
    return fileURL;
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
