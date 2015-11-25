//
//  ExampleViewController.h
//  master
//
//  Created by jin on 15/11/10.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "RootViewController.h"

@interface ExampleViewController : RootViewController
@property(nonatomic)NSInteger type;
@property (weak, nonatomic) IBOutlet UIImageView *photosImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;
@property(nonatomic)NSString*imageName;
@end
