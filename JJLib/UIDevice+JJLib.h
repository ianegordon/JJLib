//   |\  |\
//  _| \_| \  UIDevice+JJLib.h
// / |  \|  \
// \ |  /|  / JJLib  Copyright (c) 2007-2013  Ian Gordon
//  \__/\__/



#import <UIKit/UIKit.h>



@interface UIDevice (JJLib)

@property (readonly) NSString *hardwarePlatform; // iPhone3,1
@property (readonly) BOOL isRetina;
@property (readonly) BOOL isTablet;

@end
