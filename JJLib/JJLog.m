//   |\  |\
//  _| \_| \  JJLog.m
// / |  \|  \
// \ |  /|  / JJLib  Copyright (c) 2007-2012  Ian Gordon
//  \__/\__/



#import "JJLog.h"



static BOOL logToNSLog = NO;
static BOOL logToFile = NO;
static NSString *logFilename = @"JJLog.txt";



void JJLog(NSString *format, ...) 
{
    if (NO == logToNSLog)
        return;
    
    if (format == nil)
        return;
    
    va_list args;
    va_start(args, format);
    
    NSString *formattedString = [[[NSString alloc] initWithFormat:format arguments:args] autorelease];
    NSLog(@"%@", formattedString);
    
    va_end(args);
    
    return;
}

void JJFileLog(NSString *format, ...) 
{
    if (NO == logToNSLog)
        return;
    
    if (format == nil)
        return;
    
    va_list args;
    va_start(args, format);
    
    NSString *formattedString = [[[NSString alloc] initWithFormat:format arguments:args] autorelease];

    NSError *error = nil;
    [formattedString writeToFile:logFilename atomically:YES encoding:NSUTF8StringEncoding error:&error];
    //TODO Handle error
    
    va_end(args);
    
    return;
}

void JJSetEnableLog(BOOL enableLog)
{
    logToNSLog = enableLog;
}

void JJSetEnableFileLog(BOOL enableFileLog)
{
    logToFile = enableFileLog;
}

void JJSetLogFilename(NSString *newlogFilename)
{
    logFilename = newlogFilename;
}




