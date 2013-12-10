//   |\  |\
//  _| \_| \  UIImage+JJLib.m
// / |  \|  \
// \ |  /|  / JJLib  Copyright (c) 2007-2013  Ian Gordon
//  \__/\__/



#import "UIImage+JJLib.h"

#import <QuartzCore/QuartzCore.h>



@implementation UIImage (JJLib)

+ (UIImage *)imageWithScreenshot
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    // Take and orient Screenshot
    UIGraphicsBeginImageContext(window.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [window.layer renderInContext:context];
    UIImage *screenImage = UIGraphicsGetImageFromCurrentImageContext();  
    UIGraphicsEndImageContext();
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    UIImageOrientation imageOrientation;
    if (orientation == UIInterfaceOrientationLandscapeLeft)
    {
        imageOrientation = UIImageOrientationRight;
    }
    else if (orientation == UIInterfaceOrientationLandscapeRight)
    {
        imageOrientation = UIImageOrientationLeft;
    }
    else if (orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        imageOrientation = UIImageOrientationDown;
    }
    else
    {
        imageOrientation = UIImageOrientationUp;
    }
    
    UIImage *screenshotImage = [UIImage imageWithCGImage:screenImage.CGImage scale:screenImage.scale orientation:imageOrientation];
    
    return screenshotImage;
}

@end
