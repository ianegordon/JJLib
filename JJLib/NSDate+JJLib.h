//   |\  |\
//  _| \_| \  NSDate+JJLib.h
// / |  \|  \
// \ |  /|  / JJLib  Copyright (c) 2007-2013  Ian Gordon
//  \__/\__/



#import <Foundation/Foundation.h>

@interface NSDate (JJLib)


// http://www.w3.org/Protocols/rfc822/#z28
//FROM: https://gist.github.com/953664
+ (NSDate *)dateFromRFC822String:(NSString *)dateString;


// http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.3.1
//FROM: http://blog.mro.name/2009/08/nsdateformatter-http-header/
//??? + (NSDate*)dateFromRFC2616String:(NSString*)dateString;

// See http://www.faqs.org/rfcs/rfc3339.html
//FROM: https://gist.github.com/953664
+ (NSDate*)dateFromRFC3339String:(NSString*)dateString;

@end
