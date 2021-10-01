#import "ReactNativeCacheManager.h"
#import "ReactNativeCache.h"

#import <React/RCTBridge.h>
#import <React/RCTUIManager.h>
#import <AVFoundation/AVFoundation.h>

@implementation ReactNativeCacheManager

ReactNativeCache *cache;

RCT_EXPORT_MODULE()

- (UIView *)view
{
    return [[UIView alloc] init];
}

- (dispatch_queue_t)methodQueue
{
    return self.bridge.uiManager.methodQueue;
}


RCT_REMAP_METHOD(init,
                 withResolver:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)
{
 
    cache = [[ReactNativeCache alloc] init];
    resolve(@1);
}

RCT_REMAP_METHOD(saveToCache,
                 url:(nonnull NSString*)url
                 resolve_saveToCache:(RCTPromiseResolveBlock)resolve
                 reject_saveToCache:(RCTPromiseRejectBlock)reject)
{
    return [cache saveToCache:url resolve:resolve reject:reject];
}

RCT_REMAP_METHOD(getCachedData,
                 url:(nonnull NSString*)url
                 resolve_getCachedData:(RCTPromiseResolveBlock)resolve
                 reject_getCachedData:(RCTPromiseRejectBlock)reject)
{
    return [cache getCachedData:(NSString *)url resolve:(RCTPromiseResolveBlock)resolve reject:reject];
}



@end
