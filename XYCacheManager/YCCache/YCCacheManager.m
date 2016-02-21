//
//  YCCacheManager.m
//  iYongche
//
//  Created by billyye on 16/2/19.
//  Copyright © 2016年 yongche. All rights reserved.
//

#import "YCCacheManager.h"
#import "YYCache.h"
#import "YCUserDefaultCacheDao.h"

@interface YCCacheManager()

//to persisting objects to a large and slow disk cache.
@property (nonatomic, strong) YYCache *fileCache;

@end

@implementation YCCacheManager

+ (instancetype)shareManager
{
    static id manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YCCacheManager alloc] init];
    });
    return manager;
}

- (NSString *)objectCachePath
{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                               NSUserDomainMask, YES) firstObject];
    cachePath = [cachePath stringByAppendingPathComponent:@"com.yongche.iYongche"];
    cachePath = [cachePath stringByAppendingPathComponent:@"objectCache"];
    return cachePath;
}

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    self.fileCache = [[YYCache alloc] initWithPath:[self objectCachePath]];
    return self;
}

#pragma mark - NSUserDefault

- (void)ud_setObject:(id<NSCoding>)object forKey:(NSString *)key
{
    [[YCUserDefaultCacheDao shareManager] storeObject:object forKey:key];
}

- (void)ud_removeObjectForKey:(NSString *)key
{
    [[YCUserDefaultCacheDao shareManager] removeObjectInCacheByKey:key];
}

- (BOOL)ud_containsObjectForKey:(NSString *)key
{
    return [[YCUserDefaultCacheDao shareManager] hasObjectInCacheByKey:key];
}

#pragma mark - YYCache
- (void)yc_setObject:(id<NSCoding>)object forKey:(NSString *)key
{
    [self.fileCache setObject:object forKey:key];
}

- (void)yc_setObject:(id<NSCoding>)object forKey:(NSString *)key withBlock:(void(^)(void))block
{
    [self.fileCache setObject:object forKey:key withBlock:block];
}

- (id<NSCoding>)yc_objectForKey:(NSString *)key
{
     return [self.fileCache objectForKey:key];
}

- (void)yc_objectForKey:(NSString *)key withBlock:(void(^)(NSString *key, id<NSCoding> object))block
{
    [self.fileCache objectForKey:key withBlock:block];
}

- (void)yc_removeObjectForKey:(NSString *)key
{
    [self.fileCache removeObjectForKey:key];
}

- (void)yc_removeObjectForKey:(NSString *)key withBlock:(void(^)(NSString *key))block
{
    [self.fileCache removeObjectForKey:key withBlock:block];
}

- (void)yc_removeAllObjects
{
    [self.fileCache removeAllObjects];
}

- (void)yc_removeAllObjectsWithBlock:(void(^)(void))block
{
    [self.fileCache removeAllObjectsWithBlock:block];
}

@end
