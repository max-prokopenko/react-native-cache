#import <React/RCTBridgeModule.h>
#import <SPTPersistentCache/SPTPersistentCache.h>

@interface ReactNativeCache : NSObject

-(id)init;
-(void)saveToCache:(NSString *)url resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject;
-(void)getCachedData:(NSString *)url resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject;

- (void)garbageCollection;

- (NSString *)sha1:(NSString *)key;
- (BOOL)createCacheDirectory;



@property (nonatomic, strong) SPTPersistentCache *cache;
@property (nonatomic, strong) NSString *cacheIdentifier;

@property (nonatomic, strong) NSString *cachePath;
@property (nonatomic, strong) NSString *temporaryCachePath;
@property int expirationPeriod;
@property int sizeConstraintBytes;

@end
