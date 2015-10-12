//
//  WBViewController.h
//  CubeDemo
//
//  Created by guoqiangzhu on 15/8/26.
//  Copyright (c) 2015年 CubeTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBFilePickerController.h"

@interface WBViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, WBFilePickerDelegate>
{
    NSString *_name;

}

@property (nonatomic, strong) NSString *peerName;

@end
