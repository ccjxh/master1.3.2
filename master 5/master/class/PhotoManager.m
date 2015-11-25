//
//  PhotoManager.m
//  master
//
//  Created by jin on 15/11/1.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "PhotoManager.h"

@implementation PhotoManager
{

   id<PhotoDelegate>delegate;
   UINavigationController*_currentNavigation;
   NSMutableDictionary*_pictureDictionary;
}

+(PhotoManager*)share{

    static dispatch_once_t once;
    static PhotoManager*manager;
    dispatch_once(&once, ^{
       
        if (!manager) {
            manager=[[PhotoManager alloc]init];
        }
    });

    return manager;
}

/**
 *  调用照相机或者图库
 */
-(void)getimageFromPhotosWithNavigation:(UINavigationController *)nc{
    
    if (!_pictureDictionary) {
        _pictureDictionary=[[NSMutableDictionary alloc]init];
    }
    _currentNavigation=nc;
    [self setUserHeaderIamge];
    
}


- (void)setUserHeaderIamge
{
    UIActionSheet *sheet;
    if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)]) {
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
        
    }else  {
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
    }
    sheet.tag = 255;
    [sheet showInView:[[UIApplication sharedApplication].delegate window]];
    
}
#pragma mark - actionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet.tag == 255) {
        
        UIImagePickerControllerSourceType sourceType;
        // 判断是否支持相机
        if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)]) {
            
            switch (buttonIndex) {
                case 0:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                    
                    
                case 1:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                    
                case 2:
                    // 取消
                    return;
                    break;
            }
            
        }else {
            
            if (buttonIndex == 0) {
                
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                
            }else {
                
                return;
            }
        }
        
        // 跳转到相机或相册
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        //设置拍照后的图片可被编辑
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        [_currentNavigation presentViewController:imagePickerController animated:YES completion:^{
            
        }];
    }
}

#pragma mark - image picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        //        NSLog(@"image info : %@",info);
        [_pictureDictionary removeAllObjects];
        NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
        if ([type isEqualToString:@"public.image"]) {
            UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
            CGFloat length;
            if (image.size.width>image.size.height) {
                length=image.size.height;
            }else{
                
                length=image.size.width;
            }
            CGSize imagesize = CGSizeMake(length, length);
            UIImage *imageNew = [self imageWithImage:image scaledToSize:imagesize];
            NSData *imageData = UIImageJPEGRepresentation(imageNew, 0.3);
            [_pictureDictionary setObject:imageData forKey:@"image"];
            [self.delegate dealPhontDictory:_pictureDictionary];
            
        }
    }];
}


- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
