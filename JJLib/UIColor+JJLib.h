//   |\  |\
//  _| \_| \  UIColor+JJLib.h
// / |  \|  \
// \ |  /|  / JJLib  Copyright (c) 2007-2013  Ian Gordon
//  \__/\__/



#import <UIKit/UIKit.h>



@interface UIColor (JJLib)

+ (UIColor *)colorWithBytesRed:(uint8_t)red green:(uint8_t)green blue:(uint8_t)blue;
+ (UIColor *)colorWithBytesRed:(uint8_t)red green:(uint8_t)green blue:(uint8_t)blue alpha:(uint8_t)alpha;

@end
