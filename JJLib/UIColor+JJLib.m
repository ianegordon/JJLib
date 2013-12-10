//   |\  |\
//  _| \_| \  UIColor+JJLib.m
// / |  \|  \
// \ |  /|  / JJLib  Copyright (c) 2007-2013  Ian Gordon
//  \__/\__/



#import "UIColor+JJLib.h"



@implementation UIColor (JJLib)


+ (UIColor *)colorWithBytesRed:(uint8_t)red green:(uint8_t)green blue:(uint8_t)blue
{
    return [UIColor colorWithBytesRed:red green:green blue:blue alpha:255];
}


+ (UIColor *)colorWithBytesRed:(uint8_t)red green:(uint8_t)green blue:(uint8_t)blue alpha:(uint8_t)alpha
{
    return [UIColor colorWithRed:(float)red/255.0 green:(float)green/255.0 blue:(float)blue/255.0 alpha:alpha];
}


@end
