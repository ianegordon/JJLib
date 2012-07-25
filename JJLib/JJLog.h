//   |\  |\
//  _| \_| \  JJLog.h
// / |  \|  \
// \ |  /|  / JJLib  Copyright (c) 2007-2012  Ian Gordon
//  \__/\__/

// JJLog is an alternative to NSLog that can be enabled or disabled with JJSetEnableLog()
//
// By default, both logging to console and logging to file are disabled.  The default log filename is JJLog.txt
//
// To enable for DEBUG builds:
//
// #if defined(DEBUG)
// FFSetEnableLog(YES);
// #endif // defined(DEBUG)
//



void JJLog(NSString *format, ...);
void JJFileLog(NSString *format, ...);

void JJSetEnableLog(BOOL enableLog);
void JJSetEnableFileLog(BOOL enableFileLog);
void JJSetLogFilename(NSString *newlogFilename);

