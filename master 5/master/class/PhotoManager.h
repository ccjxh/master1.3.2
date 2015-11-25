//
//  PhotoManager.h
//  master
//
//  Created by jin on 15/11/1.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol PhotoDelegate<NSObject,UIImagePickerControllerDelegate,UIActionSheetDelegate>
@optional


-(void)dealPhontDictory:(NSMutableDictionary*)dict;
@end;
@interface PhotoManager : NSObject
@property(nonatomic) id<PhotoDelegate>delegate;

+(PhotoManager*)share;
/**
 *  调用照相机或者图库
 */
-(void)getimageFromPhotosWithNavigation:(UINavigationController *)nc;
@end
