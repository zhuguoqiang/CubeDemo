//
//  CubeWhiteboard.h
//  CubeEngine
//
//  Created by guoqiangzhu on 15/8/26.
//  Copyright (c) 2015年 Cube Team. All rights reserved.
//

#import <UIKit/UIKit.h>

//! 白板类。
/*!
 * \author Zhu
 */
@interface CubeWhiteboard : NSObject

@property (nonatomic, strong) UIView *view;

//! 加载白板。
/*!  加载白板，完成白板初始化操作。
 */
- (void)load;

//! 白板适配大小。
/*! 完成白板适配大小操作。
 */
- (void)changeFrame:(CGRect)frame;

//! 分享。
/*! 发起分享白板。
 *  \param list 分享白板人员列表。
 */
- (void)shareWith:(NSArray *)list;

//! 停止分享。
/*! 停止分享白板。
 */
- (void)revokeSharing;

//! 是否分享白板。
/*! 是否分享了白板。
 */
- (BOOL)isSharing;

//! 取消选择。
/*! 取消选择工具。
 */
- (void)unselect;

//! 铅笔。
/*! 选择铅笔工具。
 */
- (void)selectPencil;

//! 方框。
/*! 选择方框工具。
 */
- (void)selectRect;

//! 文本。
/*! 选择文本输入工具。
 */
- (void)selectText;

//! 圆圈。
/*! 选择圆圈工具。
 */
- (void)selectEllipse;

//! 撤销。
/*! 撤销白板操作。
 */
- (void)undo;

//! 重做。
/*! 恢复一步白板操作。
 */
- (void)redo;

//! 擦除。
/*! 擦除白板操作。
 */
- (void)erase;

//! 清空。
/*! 清空白板操作。
 */
- (void)cleanup;

/// \cond DE
//! 保存。
/*! 保存白板操作至服务器。
 */
- (void)saveToServer;

//! 设置笔触。
/*! 设置笔触相关参数。
 *  \param weight 线重。
 */
- (void)configLineWeight:(int)weight;

//! 设置笔触。
/*! 设置笔触相关参数。
 *  \param color 颜色。
 */
- (void)configLineColor:(UIColor *)color;

//! 缩放。
/*! 缩放白板。
 * \param ratio 缩放比例。
 */
- (void)zoomWithRatio:(float)ratio;
/// \endcond

//! 文件。
/*! 发送文件。
 * \param fileURL 文件URL。
 */
- (void)sendFile:(NSURL *)fileURL;

//! 文件分享。
/*! 下一页。
 *
 */
- (void)nextPage;

//! 文件分享。
/*! 上一页。
 *
 */
- (void)prevPage;

@end
