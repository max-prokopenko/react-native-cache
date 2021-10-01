#import "ReactNativeCache.h"
#import <React/RCTLog.h>
#import <AVFoundation/AVFoundation.h>
#import <CommonCrypto/CommonDigest.h>

@implementation ReactNativeCache

-(id)init
{
    NSString *cacheIdentifier = @"com.dev.lowkeychat.video.cache";
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingString:@"/com.dev.lowkeychat.video.cache"];
    
    self.cacheIdentifier = cacheIdentifier;
    self.cachePath = cachePath;
    
    [self createCacheDirectory];
    
    self.expirationPeriod = 7; // 7 days
    self.sizeConstraintBytes = 1024 * 1024 * 50; // 50 MiB // To Be Done
    
    dispatch_queue_t queue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0ul);
    dispatch_async(queue, ^{
        [self garbageCollection];
    });
    
        
    return self;
    
}

-(void)saveToCache:(NSString *)url resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
    NSURL *URL = [NSURL URLWithString:url];
        
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:URL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error) {
            reject(@"error", @"dataTaskWithURL failed", error);
        }
        NSString *key = [[self sha1:url] stringByAppendingString:@".mp4"];
        NSString * path = [self.cachePath stringByAppendingPathComponent:key];
        if([data writeToFile:path atomically:YES]) {
            resolve(path);
        }
    }] resume];
}

-(void)getCachedData:(NSString *)url resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
    
    NSString *key = [[self sha1:url] stringByAppendingString:@".mp4"];
    NSString * path = [self.cachePath stringByAppendingPathComponent:key];
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL fileExists = [fm fileExistsAtPath:path];
    
    if (fileExists) {
        resolve(path);
    } else {
        dispatch_queue_t queue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0ul);
        dispatch_async(queue, ^{
            [self saveToCache:url resolve:resolve reject:reject];
        });
    }
}

- (void)garbageCollection {
    NSArray* dirs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.cachePath
                                                                        error:NULL];
    NSFileManager *fm = [NSFileManager defaultManager];
    
    [dirs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *filename = (NSString *)obj;
        NSString *path = [self.cachePath stringByAppendingString:[@"/" stringByAppendingString:filename]];
        
        NSDate * now = [NSDate date];
        NSDate *createdAt =  [[fm attributesOfItemAtPath:path error:NULL] fileModificationDate];
        
        NSCalendar* calendar = [NSCalendar currentCalendar];
        int differenceInDays = (int)([calendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitEra forDate:now] - [calendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitEra forDate:createdAt]);
       
        if (differenceInDays > self.expirationPeriod) {
            [fm removeItemAtPath:path error:nil];
        }
    }];
}

- (NSString *)sha1:(NSString *)key
{
    NSData *data = [key dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];

    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];

    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }

    return output;
}
- (BOOL)createCacheDirectory
{
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    
    BOOL exists = [fm fileExistsAtPath:self.cachePath isDirectory:&isDirectory];
    if (exists && !isDirectory) {
        return NO;
    }

    if (exists == NO) {
        NSError *error = nil;
        BOOL didCreateDirectory = [fm createDirectoryAtPath:self.cachePath
                                              withIntermediateDirectories:YES
                                                               attributes:nil
                                                                    error:&error];
        if (didCreateDirectory == NO) {
            return NO;
        }
    }
    
    return YES;
}

@end
