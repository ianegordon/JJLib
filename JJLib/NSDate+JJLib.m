//   |\  |\
//  _| \_| \  NSDate+JJLib.h
// / |  \|  \
// \ |  /|  / JJLib  Copyright (c) 2007-2012  Ian Gordon
//  \__/\__/



#import "NSDate+JJLib.h"

#import "JJLog.h"



@implementation NSDate (JJLib)


+ (NSDate *)dateFromRFC822String:(NSString *)dateString 
{
	// Create date formatter
    static dispatch_once_t once;
    static NSDateFormatter *dateFormatter = nil;
    dispatch_once(&once, ^{
		NSLocale *systemLocale = [NSLocale systemLocale];
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setLocale:systemLocale];
        //		[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    });

	NSDate *date = nil;

	NSString *RFC822String = [[NSString stringWithString:dateString] uppercaseString];
    if (0 == [RFC822String length])
        date = nil;
	//Short circuit for Betfair
    else if (NSOrderedSame == [RFC822String compare:@"3 JAN 0001 00:00:00"])
        date = nil;
	else if ([RFC822String rangeOfString:@","].location != NSNotFound) 
    {
		if (!date) 
        { // Sun, 19 May 2002 15:21:36 GMT
			[dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss zzz"]; 
			date = [dateFormatter dateFromString:RFC822String];
		}
		if (!date) 
        { // Sun, 19 May 2002 15:21 GMT
			[dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm zzz"]; 
			date = [dateFormatter dateFromString:RFC822String];
		}
		if (!date) 
        { // Sun, 19 May 2002 15:21:36
			[dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss"]; 
			date = [dateFormatter dateFromString:RFC822String];
		}
		if (!date) 
        { // Sun, 19 May 2002 15:21
			[dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm"]; 
			date = [dateFormatter dateFromString:RFC822String];
		}
	} 
    else 
    {
		if (!date) 
        { // 19 May 2002 15:21:36 GMT
			[dateFormatter setDateFormat:@"d MMM yyyy HH:mm:ss zzz"]; 
			date = [dateFormatter dateFromString:RFC822String];
		}
		if (!date) 
        { // 19 May 2002 15:21 GMT
			[dateFormatter setDateFormat:@"d MMM yyyy HH:mm zzz"]; 
			date = [dateFormatter dateFromString:RFC822String];
		}
		if (!date) 
        { // 19 May 2002 15:21:36
			[dateFormatter setDateFormat:@"d MMM yyyy HH:mm:ss"]; 
			date = [dateFormatter dateFromString:RFC822String];
		}
		if (!date) 
        { // 19 May 2002 15:21
			[dateFormatter setDateFormat:@"d MMM yyyy HH:mm"]; 
			date = [dateFormatter dateFromString:RFC822String];
		}
	}
	
	if (!date) 
        JJLog(@"Unable to parse RFC822 date:\n%@\nPossibly invalid format.", dateString);
	
	return date;
}

/*
 //???
+(NSDate*)dateFromRFC1123:(NSString*)value_
{
    if(value_ == nil)
        return nil;
    static NSDateFormatter *rfc1123 = nil;
    if(rfc1123 == nil)
    {
        rfc1123 = [[NSDateFormatter alloc] init];
        rfc1123.locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease];
        rfc1123.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        rfc1123.dateFormat = @"EEE',' dd MMM yyyy HH':'mm':'ss z";
    }
    NSDate *ret = [rfc1123 dateFromString:value_];
    if(ret != nil)
        return ret;
	
    static NSDateFormatter *rfc850 = nil;
    if(rfc850 == nil)
    {
        rfc850 = [[NSDateFormatter alloc] init];
        rfc850.locale = rfc1123.locale;
        rfc850.timeZone = rfc1123.timeZone;
        rfc850.dateFormat = @"EEEE',' dd'-'MMM'-'yy HH':'mm':'ss z";
    }
    ret = [rfc850 dateFromString:value_];
    if(ret != nil)
        return ret;
	
    static NSDateFormatter *asctime = nil;
    if(asctime == nil)
    {
        asctime = [[NSDateFormatter alloc] init];
        asctime.locale = rfc1123.locale;
        asctime.timeZone = rfc1123.timeZone;
        asctime.dateFormat = @"EEE MMM d HH':'mm':'ss yyyy";
    }
    return [asctime dateFromString:value_];
}
 */


+ (NSDate *)dateFromRFC3339String:(NSString *)dateString
{
	// Create date formatter
    static dispatch_once_t once;
    static NSDateFormatter *dateFormatter = nil;
    dispatch_once(&once, ^{
		NSLocale *systemLocale = [NSLocale systemLocale];
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setLocale:systemLocale];
        //		[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    });
    
	NSDate *date = nil;

	NSString *RFC3339String = [[NSString stringWithString:dateString] uppercaseString];
	RFC3339String = [RFC3339String stringByReplacingOccurrencesOfString:@"Z" withString:@"-0000"];
	// Remove colon in timezone as iOS 4+ NSDateFormatter breaks. See https://devforums.apple.com/thread/45837
	if (RFC3339String.length > 20) 
	{
		RFC3339String = [RFC3339String stringByReplacingOccurrencesOfString:@":" 
																 withString:@"" 
																	options:0
																	  range:NSMakeRange(20, RFC3339String.length-20)];
	}

	if (!date) { // 1996-12-19T16:39:57-0800
		[dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"]; 
		date = [dateFormatter dateFromString:RFC3339String];
	}
	if (!date) { // 1937-01-01T12:00:27.87+0020
		[dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSSZZZ"]; 
		date = [dateFormatter dateFromString:RFC3339String];
	}
	if (!date) { // 1937-01-01T12:00:27
		[dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss"]; 
		date = [dateFormatter dateFromString:RFC3339String];
	}
	
	if (!date) 
        JJLog(@"Unable to parse RFC3339 date:\n%@\nPossibly invalid format.", dateString);

	return date;
	
}


@end
