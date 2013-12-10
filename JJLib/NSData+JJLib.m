//   |\  |\
//  _| \_| \  NSData+JJLib.m
// / |  \|  \
// \ |  /|  / JJLib  Copyright (c) 2007-2013  Ian Gordon
//  \__/\__/



#import "NSData+JJLib.h"

#import "JJBase64.h"



@implementation NSData (JJLib)

+ (NSData*)dataWithBase64String:(NSString*)base64String
{
    if (nil == base64String)
        return nil;

    bool boolRetVal;

    unsigned char* pachDecoded = NULL;
    size_t cbDecoded;

    boolRetVal = Base64Decode([base64String cStringUsingEncoding:NSASCIIStringEncoding], [base64String length], &pachDecoded, &cbDecoded);

    if (boolRetVal)
    {
        NSData* dataDecoded = [NSData dataWithBytes:pachDecoded length:cbDecoded];
    
        free(pachDecoded);
        pachDecoded = NULL;
    
        return dataDecoded;
    }
    else 
    {
        return nil;
    }
}

@end