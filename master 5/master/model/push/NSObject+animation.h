//
//  NSObject+animation.h
//  master
//
//  Created by jin on 15/5/6.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^imageSelect)(UIImage*image);
@interface NSObject (animation)<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
@property(nonatomic)UINavigationController*nc;
@property(nonatomic,copy)imageSelect imageblock;
-(void)pushWinthAnimation:(UINavigationController*)navigation Viewcontroller:(UIViewController*)viewcontroller;
-(void)popWithnimation:(UINavigationController*)navigation;
-(CGFloat)getScreenHeight;//得到屏幕的真实高度
-(CGFloat)getOrigin;//得到原点y点的坐标
-(CGFloat)accountStringHeightFromString:(NSString*)str Width:(CGFloat)width;
- (BOOL)isAllNum:(NSString *)string;
/**
 *  根据字体大小和空间宽度设置高度
 *
 *  @param str   <#str description#>
 *  @param width <#width description#>
 *  @param size  <#size description#>
 *
 *  @return <#return value description#>
 */
-(CGFloat)accountStringHeightFromString:(NSString *)str Width:(CGFloat)width FrontSize:(NSInteger)size;
@end