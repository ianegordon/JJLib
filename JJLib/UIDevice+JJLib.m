//   |\  |\
//  _| \_| \  UIDevice+JJLib.m
// / |  \|  \
// \ |  /|  / JJLib  Copyright (c) 2007-2012  Ian Gordon
//  \__/\__/



#import "UIDevice+JJLib.h"

#import <sys/utsname.h>
#import <sys/sysctl.h>



@implementation UIDevice (JJLib)

- (NSString *)hardwarePlatform
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    return platform;
}

/* ALTERNATIVE
- (NSString *)systemPlatform
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding: NSUTF8StringEncoding];
    free(machine);
    machine = NULL;
    
    return platform;
}
*/

- (BOOL)isRetina
{
    BOOL isRetina = [[UIScreen mainScreen] scale] == 2.0;
    
    return isRetina;
}

- (BOOL)isTablet
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
