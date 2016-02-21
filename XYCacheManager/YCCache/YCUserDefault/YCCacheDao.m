//
//  YCCacheDao.m
//  iWeidao
//
//  Created by billyye on 15/9/21.
//  Copyright (c) 2015年 yongche. All rights reserved.
//

#import "YCCacheDao.h"

#define SHOULD_OVERRIDE(basename, subclassname){ NSAssert([basename isEqualToString:subclassname], @"subclass should override the method!");}

@implementation YCCacheDao
+ (instancetype)shareManager
{
    return nil;
}

#pragma mark - Public Methods
- (NSString *)getCachePathForKey:(NSString *)key
{
    return nil;
}

- (void)registerMemoryWarningNotification
{
    // Subscribe to app events
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clearMemoryCache)
                                                 name:UIApplicationDidReceiveMemoryWarningNotification
                                               object:nil];
}

- (BOOL)isValidKey:(NSString*)key
{
    if (!key || (NSNull*)key == [NSNull null] || [key length] == 0 ) {
        return NO;
    }
    return YES;
}

- (BOOL)isValidObject:(id)object
{
    if (!object || (NSNull*)object == [NSNull null]) {
        return NO;
    }
    return YES;
}

- (id)archivedObjectWithObject:(id)object
{
    return [NSKeyedArchiver archivedDataWithRootObject:object];
}

- (id)unarchivedObjectWithObject:(id)object
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:object];
}

#pragma mark - Override Methods
- (BOOL)hasObjectInCacheByKey:(NSString*)key
{
    SHOULD_OVERRIDE(@"YCCacheDao", NSStringFromClass([self class]));
    return TRUE;
}

- (BOOL)hasObjectInMemoryByKey:(NSString*)key
{
    SHOULD_OVERRIDE(@"YCCacheDao", NSStringFromClass([self class]));
    return TRUE;
}

- (id)getCachedObjectByKey:(NSString*)key
{
    SHOULD_OVERRIDE(@"YCCacheDao", NSStringFromClass([self class]));
    return nil;
}

- (id)getCachedObject:(Class)objectClass forKey:(NSString *)key
{
    return nil;
}


- (void)removeObjectInCacheByKey:(NSString*)key
{
    SHOULD_OVERRIDE(@"YCCacheDao", NSStringFromClass([self class]));
}

- (void)storeObject:(id)object forKey:(NSString *)key
{
    SHOULD_OVERRIDE(@"YCCacheDao", NSStringFromClass([self class]));
}

- (void)storeObject:(id)object forKey:(NSString *)key completion:(YCFileCacheCompletionBlock)compeletionBlock
{
    
}

- (void)storeObjectToMemory:(id)object forKey:(NSString *)key
{
    SHOULD_OVERRIDE(@"YCCacheDao", NSStringFromClass([self class]));
}

- (void)clearAllCache
{
}

- (void)clearAllDiskCache
{
}

- (void)clearMemoryCache
{
    SHOULD_OVERRIDE(@"YCCacheDao", NSStringFromClass([self class]));
}

@end
