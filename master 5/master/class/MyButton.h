//
//  MyButton.h
//  master
//
//  Created by jin on 15/11/3.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyButton : UIButton
@property (nonatomic, copy) NSString *name;
- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state;
- (UIColor *)backgroundColorForState:(UIControlState)state;
@end
