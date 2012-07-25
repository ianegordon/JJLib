//   |\  |\
//  _| \_| \  JJAssert.h
// / |  \|  \
// \ |  /|  / JJLib  Copyright (c) 2007-2012  Ian Gordon
//  \__/\__/



#import <UIKit/UIKit.h>



void JJAssertLogFailed(const char* filename, const int line, NSString* message);

//TODO #defines -> function()s

#define JJAssert(boolToAssert)  do { if (!(boolToAssert)) FJAssertLogFailed(__FILE__, __LINE__, nil); } while(0)
#define JJAssertLog(boolToAssert, snMessage)  do { if (!(boolToAssert)) FJAssertLogFailed(__FILE__, __LINE__, snMessage); } while(0)


