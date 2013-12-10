//   |\  |\
//  _| \_| \  JJAssert.m
// / |  \|  \
// \ |  /|  / JJLib  Copyright (c) 2007-2013  Ian Gordon
//  \__/\__/



#import "JJAssert.h"

#include <assert.h>

//KM #import "JJBugReporter.h"



void JJAssertLogFailed(const char* filename, const int line, NSString* message)
{
	NSString* error = [NSString stringWithFormat:@"ASSERT %s : %d", filename, line];
	if (message && 0 != [message length] )
		error = [NSString stringWithFormat:@"ASSERT %s : %d : %@", filename, line, message];
	
	NSLog(@"%@", error);

#if defined(DEBUG)
	assert(0);
#elif !TARGET_IPHONE_SIMULATOR
	// Release build on Device
	/*
	//Pop BugReportControler
	 
	NSString* nsApplicationName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
	NSString* nsRevision = GetRevisionString();
	NSString* nsHostname = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"FogbugzHostname"];
	NSString* nsUsername = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"FogbugzUsername"];
	 
	// HTTP Post bug report to Fogbugz
	//FIXME [FJBugReporter submitAssertFogbugzProject:nsApplicationName revision:nsRevision filename:szFilename line:nLine message:nsMessage hostname:nsHostname username:nsUsername];
	 */
#endif // defined(DEBUG)
}


