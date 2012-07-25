//   |\  |\
//  _| \_| \  NSString+JJLib.m
// / |  \|  \
// \ |  /|  / JJLib  Copyright (c) 2007-2012  Ian Gordon
//  \__/\__/



#import "NSString+JJLIB.h"

#import "JJBase64.h"



@implementation NSString (JJLIB)

//REF: http://developer.apple.com/library/ios/#documentation/CoreFoundation/Reference/CFUUIDRef/Reference/reference.html
+ (NSString *)UUIDString
{
    CFUUIDRef UUID = CFUUIDCreate(kCFAllocatorDefault);
    
    NSString *UUIDString = [(NSString *)CFUUIDCreateString(kCFAllocatorDefault, UUID) autorelease];
    
    CFRelease(UUID);
    UUID = nil;
    
    return UUIDString;
}


+ (NSString*)base64StringWithData:(NSData*)data
{
	if (nil == data)
		return nil;
	
	bool boolRetVal;
	
	char* pachOutput = NULL;
	size_t cbEncodedLength = 0;
	boolRetVal = Base64Encode( [data bytes], [data length], &pachOutput, &cbEncodedLength, YES);
	
	if (false == boolRetVal)
		return nil;
	else 
	{
		NSString* nsEncoded = [[[NSString alloc] initWithBytes:pachOutput length:cbEncodedLength encoding:NSASCIIStringEncoding] autorelease];
		
		free(pachOutput);
		pachOutput = NULL;
		
		return nsEncoded;
	}
}

// URL Escaping per RFC 3986
// http://www.ietf.org/rfc/rfc3986.txt
- (NSString *)stringWithURIPercentEncoding
{
    NSString *charactersToLeaveUnescaped = nil; // nil == Don't leave any Illegal Characters escaped
    
    NSString *charactersToEscape = @"!*'\"();:@&=+$,/?%#[]% ";
    
    NSString *encodedString = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self,                                                                                   (CFStringRef)charactersToLeaveUnescaped, (CFStringRef)charactersToEscape, kCFStringEncodingUTF8);
    
    return [encodedString autorelease];
}

- (NSString *)stringWithURIPercentDecoding
{
    NSString *charactersToLeaveEscaped = nil;
    
    NSString *decodedString = (NSString *)CFURLCreateStringByReplacingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, (CFStringRef)charactersToLeaveEscaped);    
    
    return [decodedString autorelease];
}

@end
