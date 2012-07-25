//   |\  |\
//  _| \_| \  NSString+JJLib.h
// / |  \|  \
// \ |  /|  / JJLib  Copyright (c) 2007-2012  Ian Gordon
//  \__/\__/



#import <Foundation/Foundation.h>



@interface NSString (JJLIB)

+ (NSString *)UUIDString;

+ (NSString*)base64StringWithData:(NSData*)data;

- (NSString *)stringWithURIPercentEncoding;
- (NSString *)stringWithURIPercentDecoding;

@end
