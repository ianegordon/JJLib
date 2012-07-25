//   |\  |\
//  _| \_| \  JJSecureDefaults.m
// / |  \|  \
// \ |  /|  / JJLib  Copyright (c) 2007-2012  Ian Gordon
//  \__/\__/



#import "JJSecureDefaults.h"



static NSString *JJLibErrorDomain = @"JJLibErrorDomain";

@implementation JJSecureDefaults

static NSString *_serviceName = @"com.none";

// NSUserDefaults

+ (JJSecureDefaults *)standardSecureDefaults
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
        _serviceName =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    });
    
    return sharedInstance;
}

// Getting Default Values
- (NSArray *)arrayForKey:(NSString *)defaultName
{
    NSLog(@"get %@", defaultName);
    
    return nil;
}

//TODO: 
/*
- (BOOL)boolForKey:(NSString *)defaultName
{
    return NO;
}

- (NSData *)dataForKey:(NSString *)defaultName
{
    return nil;
}

- (NSDictionary *)dictionaryForKey:(NSString *)defaultName
{
    return nil;
}

- (double)doubleForKey:(NSString *)defaultName
{
    return 0.0;
}

- (float)floatForKey:(NSString *)defaultName
{
    return 0.0f;
}

- (NSInteger)integerForKey:(NSString *)defaultName
{
    return 0;
}

- (id)objectForKey:(NSString *)defaultName
{
    return nil;
}

- (NSArray *)stringArrayForKey:(NSString *)defaultName
{
    return nil;
}
*/

- (NSString *)stringForKey:(NSString *)defaultName
{
    NSError **error = nil;
    
    // Set up a query dictionary with the base query attributes: item type (generic), username, and service
    
    NSArray *keys = [[[NSArray alloc] initWithObjects: (NSString *)kSecClass, kSecAttrAccount, kSecAttrService, nil] autorelease];
	NSArray *objects = [[[NSArray alloc] initWithObjects: (NSString *)kSecClassGenericPassword, defaultName, _serviceName, nil] autorelease];
    
	NSMutableDictionary *query = [[[NSMutableDictionary alloc] initWithObjects: objects forKeys: keys] autorelease];
    
    
    // First do a query for attributes, in case we already have a Keychain item with no password data set.
	// One likely way such an incorrect item could have come about is due to the previous (incorrect)
	// version of this code (which set the password as a generic attribute instead of password data).
    
	NSDictionary *attributeResult = NULL;
	NSMutableDictionary *attributeQuery = [query mutableCopy];
	[attributeQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnAttributes];
	OSStatus status = SecItemCopyMatching((CFDictionaryRef)attributeQuery, (CFTypeRef *)&attributeResult);
    
	[attributeResult release];
	[attributeQuery release];
    
	if (status != noErr) 
    {
		// No existing item found--simply return nil for the password
		if (error != nil && status != errSecItemNotFound) 
        {
			//Only return an error if a real exception happened--not simply for "not found."
			*error = [NSError errorWithDomain:JJLibErrorDomain code:status userInfo:nil];
		}
        
		return nil;
	}    
    
    
    // We have an existing item, now query for the password data associated with it.
    
	NSData *resultData = nil;
	NSMutableDictionary *passwordQuery = [query mutableCopy];
	[passwordQuery setObject: (id) kCFBooleanTrue forKey: (id) kSecReturnData];
    
	status = SecItemCopyMatching((CFDictionaryRef) passwordQuery, (CFTypeRef *) &resultData);
    
	[resultData autorelease];
	[passwordQuery release];
    
	if (status != noErr) 
    {
		if (status == errSecItemNotFound) 
        {
			// We found attributes for the item previously, but no password now, so return a special error.
			// Users of this API will probably want to detect this error and prompt the user to
			// re-enter their credentials.  When you attempt to store the re-entered credentials
			// using storeUsername:andPassword:forServiceName:updateExisting:error
			// the old, incorrect entry will be deleted and a new one with a properly encrypted
			// password will be added.
			if (error != nil) 
            {
				*error = [NSError errorWithDomain: JJLibErrorDomain code: -1999 userInfo: nil];
			}
		}
		else 
        {
			// Something else went wrong. Simply return the normal Keychain API error code.
			if (error != nil) 
            {
				*error = [NSError errorWithDomain: JJLibErrorDomain code: status userInfo: nil];
			}
		}
        
		return nil;
	}
    
	NSString *password = nil;	
    
	if (resultData) 
    {
		password = [[NSString alloc] initWithData: resultData encoding: NSUTF8StringEncoding];
	}
	else 
    {
		// There is an existing item, but we weren't able to get password data for it for some reason,
		// Possibly as a result of an item being incorrectly entered by the previous code.
		// Set the -1999 error so the code above us can prompt the user again.
		if (error != nil) 
        {
			*error = [NSError errorWithDomain: JJLibErrorDomain code: -1999 userInfo: nil];
		}
	}
    
	return [password autorelease];
}

//- (NSURL *)URLForKey:(NSString *)defaultName NS_AVAILABLE(10_6, 4_0);


// Setting Default Value
//TODO
/*
- (void)setInteger:(NSInteger)value forKey:(NSString *)defaultName
{
    NSLog(@"setInteger %@ : %d", defaultName, value);
    
    return;
}

- (void)setFloat:(float)value forKey:(NSString *)defaultName
{
    NSLog(@"setFloat %@ : %f", defaultName, value);
    
    return;
}

- (void)setDouble:(double)value forKey:(NSString *)defaultName
{
    NSLog(@"setDouble %@ : %f", defaultName, value);
    
    return;
}

- (void)setBool:(BOOL)value forKey:(NSString *)defaultName
{
    NSLog(@"setInteger %@ : %d", defaultName, value);
    
    return;
}

- (void)setObject:(id)value forKey:(NSString *)defaultName
{
    NSLog(@"setObject %@ : %@", defaultName, value);
    
    return;
}
 */

//KM
- (void)setString:(NSString *)value forKey:(NSString *)defaultName
{
	if (!defaultName || !value) 
    {
		return;
	}
    
	// See if we already have a password entered for these credentials.
//KM	NSError *getError = nil;
	NSString *existingValue = [self stringForKey:value];
    
    /* TODO Handle this version
	if (existingValue) 
    {
		// There is an existing entry without a password properly stored (possibly as a result of the previous incorrect version of this code.
		// Delete the existing item before moving on entering a correct one.
        
		getError = nil;
        
		[self removeObjectForKey:value];
	}
     */
    
	OSStatus status = noErr;
    
	if (existingValue) 
    {
		// We have an existing, properly entered item with a password.
		// Update the existing item.
        
		if (![existingValue isEqualToString:value]) 
        {
			//Only update if we're allowed to update existing.  If not, simply do nothing.
            
			NSArray *keys = [[[NSArray alloc] initWithObjects:(NSString *)kSecClass, kSecAttrService, kSecAttrLabel, kSecAttrAccount, nil] autorelease];
            
			NSArray *objects = [[[NSArray alloc] initWithObjects: (NSString *)kSecClassGenericPassword, _serviceName, _serviceName, value, nil] autorelease];
            
			NSDictionary *queryDictionary = [[[NSDictionary alloc] initWithObjects: objects forKeys: keys] autorelease];			
            NSDictionary *valueDictionary = [NSDictionary dictionaryWithObject:[value dataUsingEncoding: NSUTF8StringEncoding] forKey:(NSString *)kSecValueData];
            
			status = SecItemUpdate((CFDictionaryRef)queryDictionary, (CFDictionaryRef)valueDictionary);
		}
	}
	else 
    {
		// No existing entry (or an existing, improperly entered, and therefore now
		// deleted, entry).  Create a new entry.
        
		NSArray *keys = [[[NSArray alloc] initWithObjects:(NSString *)kSecClass, kSecAttrService, kSecAttrLabel, kSecAttrAccount, kSecValueData, nil] autorelease];
        
		NSArray *objects = [[[NSArray alloc] initWithObjects:(NSString *)kSecClassGenericPassword, _serviceName, _serviceName, defaultName, [value dataUsingEncoding:NSUTF8StringEncoding], nil] autorelease];
        
		NSDictionary *query = [[[NSDictionary alloc] initWithObjects: objects forKeys: keys] autorelease];			
        
		status = SecItemAdd((CFDictionaryRef)query, NULL);
	}
}

//- (void)setURL:(NSURL *)url forKey:(NSString *)defaultName NS_AVAILABLE(10_6, 4_0);


// Remove Default Value
- (void)removeObjectForKey:(NSString *)defaultName
{
    NSLog(@"Remove : %@", defaultName);
    
	if (!defaultName) 
    {
		return;
	}
    
	NSArray *keys = [[[NSArray alloc] initWithObjects:(NSString *)kSecClass, kSecAttrAccount, kSecAttrService, kSecReturnAttributes, nil] autorelease];
	NSArray *objects = [[[NSArray alloc] initWithObjects:(NSString *)kSecClassGenericPassword, defaultName, _serviceName, kCFBooleanTrue, nil] autorelease];
    
	NSDictionary *query = [[[NSDictionary alloc] initWithObjects:objects forKeys:keys] autorelease];
    
	OSStatus status = SecItemDelete((CFDictionaryRef)query);
    
	if (status != noErr) 
    {
	}
}


@end
