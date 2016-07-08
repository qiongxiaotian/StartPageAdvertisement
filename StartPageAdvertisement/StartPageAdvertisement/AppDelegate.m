//
//  AppDelegate.m
//  StartPageAdvertisement
//
//  Created by heivr.mxy on 16/7/8.
//  Copyright © 2016年 heivr.mxy. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "AdvertiseView.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:[[ViewController alloc]init]];
    [self.window makeKeyAndVisible];
    
    //1.判断沙盒中是否存在广告图片，如果存在直接显示
    NSString *filePath = [self getFilePathWithImageName:[kUserDefaults valueForKey:adImageName]];
    
    //判断文件是否存在
    BOOL isExist = [self isFileExistFilePath:filePath];
    if (isExist) {
        //调用广告视图
        
        AdvertiseView *advertise = [[AdvertiseView alloc]initWithFrame:self.window.bounds];
        advertise.filePath = filePath;
        [advertise show];
    }
    
    //2.无论沙盒中是否存在图片，都需要重新调用接口，判断图片是否更新
    [self getAdvertisingImage];
    
    return YES;
}
//初始化广告页面
- (void)getAdvertisingImage{
    
    NSArray *imageArray =@[@"http://img.r1.market.hiapk.com/data/upload/2014/08_21/17/201408211735376270.jpg",
                           @"http://p7.qhimg.com/t017de86989ea030df3.jpg",
                           @"http://img5.pcpop.com/ArticleImages/picshow/0x0/20110801/2011080114495843125.jpg",
                           @"http://content.52pk.com/files/120608/781866_1F552221.jpg"];
    NSString *imageUrl = imageArray[arc4random() % imageArray.count];

    //获取图片名
    NSArray *stringArr = [imageUrl componentsSeparatedByString:@"/"];//字符串切割
    NSString *imageName = stringArr.lastObject;
    
    //拼接沙盒路径
    NSString *filePath = [self getFilePathWithImageName:imageName];
    BOOL isExist = [self isFileExistFilePath:filePath];
    //如果图片不存在，则删除老照片，下载新图片
    if (!isExist) {
        [self downloadAddImageWithUrl:imageUrl imageName:imageName];
    }
    
}

//异步下载新图片
- (void)downloadAddImageWithUrl:(NSString *)imageUrl imageName:(NSString *)imageName{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        UIImage *image = [UIImage imageWithData:data];
        
        //保存文件的名称
        NSString *filePath = [self getFilePathWithImageName:imageName];
    
        if ([UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]) {//保存成功
            
            [self deleteOldImage];
            
            [kUserDefaults setValue:imageName forKey:adImageName];
            [kUserDefaults synchronize];
            // 如果有广告链接，将广告链接也保存下来
            NSLog(@"保存成功");

        }else{
            NSLog(@"保存失败");
        }
        
    });
}
//删除以前的图片
- (void)deleteOldImage{
    
    NSString *imageName = [kUserDefaults valueForKey:adImageName];
    if (imageName) {
        NSString *filePath = [self getFilePathWithImageName:imageName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:filePath error:nil];
    }
}




//判断文件是否存在
- (BOOL)isFileExistFilePath:(NSString *)filePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = FALSE;
    return [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
}

//根据图片名拼接图片路径
- (NSString *)getFilePathWithImageName:(NSString *)imageName{
    
    if (imageName) {
        //获得沙盒路径
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        //拼接路径
        NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:imageName];
        return filePath;
    }
    return nil;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
