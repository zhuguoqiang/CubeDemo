//
//  ViewController.h
//  CubeDemo
//
//  Created by Ambrose Xu on 14-10-8.
//  Copyright (c) 2014年 Cube Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cube.h"
#import "MediaProbe.h"

@interface ViewController : UIViewController <CubeRegistrationDelegate, CubeCallDelegate, MediaProbeDelegate, CubeMediaDelegate>
@end

