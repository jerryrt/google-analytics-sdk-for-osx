//
//  AnalyticsHelper.m
//  Google Analytics SDK for OSX
//
//  Created by Noah Spitzer-Williams on 11/27/11.
//  http://github.com/noahsw/google-analytics-sdk-for-osx
//

#import "AnalyticsHelper.h"
#import "GoogleEvent.h"
#import "TrackingRequest.h"
#import "GoogleTracking.h"
#import "TrackingRequest.h"
#import "RequestFactory.h"

#import "GoogleUniversalTracking.h"

#import "DDLog.h"
static const int ddLogLevel = LOG_LEVEL_VERBOSE | LOG_LEVEL_INFO | LOG_LEVEL_ERROR | LOG_LEVEL_WARN;

static NSOperationQueue* operationQueue;


@implementation AnalyticsHelper


+(BOOL) fireEvent: (NSString*)eventAction eventValue:(NSNumber*)eventValue
{
    
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString* eventCategory = [NSString stringWithFormat:@"Mac %@", infoDict[@"CFBundleShortVersionString"]];
    
    NSString* eventLabel = @"empty";
    NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults)
    {
        NSString* userUUID = [standardUserDefaults stringForKey:@"UserUUID"];
        if ([userUUID length] == 0)
        { // generate one for the first time
            userUUID = [self UUIDString];
            [standardUserDefaults setObject:userUUID forKey:@"UserUUID"];
            [standardUserDefaults synchronize];
        }
        
        eventLabel = userUUID;
    }
    
    DDLogInfo(@"%@, %@, %@, %@", eventCategory, eventAction, eventLabel, eventValue);
    
    GoogleEvent* googleEvent = [[GoogleEvent alloc] initWithParams:GANALYTICS_DOMAIN category:eventCategory action:eventAction label:eventLabel value:eventValue];
    
    
    if (googleEvent != nil)
    {
        RequestFactory* requestFactory = [RequestFactory new];
        TrackingRequest* request = [requestFactory buildRequest:googleEvent];
        
        if (operationQueue == nil)
        {
            operationQueue = [NSOperationQueue new];
            operationQueue.maxConcurrentOperationCount = 1;
        }
        
        GoogleTracking* trackingOperation = [GoogleTracking new];
        trackingOperation.request = request;
        
        [operationQueue addOperation:trackingOperation];
        
    }
    
    return YES;
    
}

+(BOOL) mearsureEvent: (NSString*)eventAction eventValue:(NSNumber*)eventValue {
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString* eventCategory = [NSString stringWithFormat:@"Mac %@", infoDict[@"CFBundleShortVersionString"]];
    
    NSString* eventLabel = @"empty";
    NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults)
    {
        NSString* userUUID = [standardUserDefaults stringForKey:@"UserUUID"];
        if ([userUUID length] == 0)
        { // generate one for the first time
            userUUID = [self UUIDString];
            [standardUserDefaults setObject:userUUID forKey:@"UserUUID"];
            [standardUserDefaults synchronize];
        }
        
        eventLabel = userUUID;
    }
    
    DDLogInfo(@"%@, %@, %@, %@", eventCategory, eventAction, eventLabel, eventValue);
    
    GoogleEvent* googleEvent = [[GoogleEvent alloc] initWithParams:GANALYTICS_DOMAIN category:eventCategory action:eventAction label:eventLabel value:eventValue];
    
    
    if (googleEvent != nil)
    {
        RequestFactory* requestFactory = [RequestFactory new];
        TrackingRequest* request = [requestFactory buildRequest:googleEvent];
        
        if (operationQueue == nil)
        {
            operationQueue = [NSOperationQueue new];
            operationQueue.maxConcurrentOperationCount = 1;
        }
        
        GoogleUniversalTracking* trackingOperation = [GoogleUniversalTracking new];
        trackingOperation.request = request;
        
        [operationQueue addOperation:trackingOperation];
        
    }
    
    return YES;

}

+(NSString*)UUIDString
{
    CFUUIDRef  uuidObj = CFUUIDCreate(nil);
    NSString  *uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return uuidString;
}



@end
