//
//  AdvertiseView.h
//  StartPageAdvertisement
//
//  Created by heivr.mxy on 16/7/8.
//  Copyright © 2016年 heivr.mxy. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kscreenWidth [UIScreen mainScreen].bounds.size.width
#define kscreenHeight [UIScreen mainScreen].bounds.size.height
#define kUserDefaults [NSUserDefaults standardUserDefaults]
static NSString *const adImageName = @"adImageName";
static NSString *const adUrl = @"adUrl";

@interface AdvertiseView : UIView
//现实广告页的方法
- (void)show;

@property (nonatomic,copy)NSString *filePath;

@end
