//   |\  |\
//  _| \_| \  JJSecureDefaults.h
// / |  \|  \
// \ |  /|  / JJLib  Copyright (c) 2007-2013  Ian Gordon
//  \__/\__/



#import <Foundation/Foundation.h>



@interface JJSecureDefaults : NSObject

// Attempting to create a drop in replacement for NSUserDefaults
// Code from SciFi-HiFi

+ (JJSecureDefaults *)standardSecureDefaults;

// Getting Default Values
//- (NSArray *)arrayForKey:(NSString *)defaultName;
//TODO: - (BOOL)boolForKey:(NSString *)defaultName;
//TODO: - (NSData *)dataForKey:(NSString *)defaultName;
//- (NSDictionary *)dictionaryForKey:(NSString *)defaultName;
//TODO: - (double)doubleForKey:(NSString *)defaultName;
//TODO: - (float)floatForKey:(NSString *)defaultName;
//TODO: - (NSInteger)integerForKey:(NSString *)defaultName;
//TODO: - (id)objectForKey:(NSString *)defaultName;
//- (NSArray *)stringArrayForKey:(NSString *)defaultName;
- (NSString *)stringForKey:(NSString *)defaultName;
//- (NSURL *)URLForKey:(NSString *)defaultName NS_AVAILABLE(10_6, 4_0);


// Setting Default Value
//TODO: - (void)setInteger:(NSInteger)value forKey:(NSString *)defaultName;
//TODO: - (void)setFloat:(float)value forKey:(NSString *)defaultName;
//TODO: - (void)setDouble:(double)value forKey:(NSString *)defaultName;
//TODO: - (void)setBool:(BOOL)value forKey:(NSString *)defaultName;
//TODO: - (void)setObject:(id)value forKey:(NSString *)defaultName;
//- (void)setURL:(NSURL *)url forKey:(NSString *)defaultName NS_AVAILABLE(10_6, 4_0);
- (void)setString:(NSString *)value forKey:(NSString *)defaultName; //KM

// Remove Default Value
- (void)removeObjectForKey:(NSString *)defaultName;

@end

FOUNDATION_EXPORT NSString * const JJSecureDefaultsDidChangeNotification;