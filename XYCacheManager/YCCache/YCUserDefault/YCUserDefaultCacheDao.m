//
//  YCUserDefaultCacheDao.m
//  iWeidao
//
//  Created by billyye on 15/9/21.
//  Copyright (c) 2015年 yongche. All rights reserved.
//

#import "YCUserDefaultCacheDao.h"

#define UD_KEY_DATA_CACHE_KEYS @"UD_KEY_DATA_CACHE_KEYS"

#define Lock() dispatch_semaphore_wait(self->_lock, DISPATCH_TIME_FOREVER)
#define Unlock() dispatch_semaphore_signal(self->_lock)

@implementation YCUserDefaultCacheDao {
    
    NSMutableArray      *_memoryCacheKeys;      // keys for objects only cached in memory
    NSMutableArray      *_keys;                 // keys for keys not managed by queue
    NSMutableDictionary *_memoryCachedObjects;  // objects only cached in memory
    NSOperationQueue    *_cacheInQueue;         // manager cache operation
    dispatch_semaphore_t _lock;
    dispatch_queue_t _queue;
}

+ (instancetype)shareManager
{
    static id cacheDao;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cacheDao = [[YCCacheDao alloc] init];
    });
    return cacheDao;
}

#pragma mark - lifecycle
- (id)init
{
    self = [super init];
    if (self) {
        [self restore];
    }
    return self;
}

#pragma mark - public methods
- (void)restore
{
    //init operation queue
    
    _lock = dispatch_semaphore_create(1);
    _queue = dispatch_queue_create("com.userdefault.queue",DISPATCH_QUEUE_CONCURRENT);
    _memoryCacheKeys = [[NSMutableArray alloc] init];
    _memoryCachedObjects = [[NSMutableDictionary alloc] init];

    //restore all cached keys, otherwise create an empty nsmutablearray
    if ([USER_DEFAULT objectForKey:UD_KEY_DATA_CACHE_KEYS]) {
        
        id objectData = [USER_DEFAULT objectForKey:UD_KEY_DATA_CACHE_KEYS];
        NSArray *keysArray = [self unarchivedObjectWithObject:objectData];
        _keys = [[NSMutableArray alloc] initWithArray:keysArray];
        
    }else{
        _keys = [[NSMutableArray alloc] init];
    }
    //restore all memory cached keys and objects
}

- (void)clearAllCache
{
    [self clearMemoryCache];
    [self clearAllDiskCache];
}

- (void)clearMemoryCache
{
    Lock();
    [_memoryCacheKeys removeAllObjects];
    [_memoryCachedObjects removeAllObjects];
    Unlock();
}

- (void)clearAllDiskCache
{
    dispatch_async(_queue, ^{
        
        Lock();
        NSArray *allKeys = [NSArray arrayWithArray:_keys];
        [_keys removeAllObjects];
        [self doSave];

        for (NSString *key in allKeys) {
            [USER_DEFAULT removeObjectForKey:key];
        }
        [USER_DEFAULT synchronize];
        Unlock();
    });
}

- (void)saveObject:(id)object toKey:(NSString *)key
{
    dispatch_async(_queue, ^{
        
        [USER_DEFAULT setObject:[self archivedObjectWithObject:_keys] forKey:UD_KEY_DATA_CACHE_KEYS];
        [USER_DEFAULT setObject:[self archivedObjectWithObject:object] forKey:key];
        [USER_DEFAULT synchronize];
    });
}

- (void)storeObject:(id<NSCoding>)object forKey:(NSString *)key;
{
    if (![self isValidKey:key]) {
        return;
    }
    if (!object || (NSNull*)object == [NSNull null]) {
        [self removeObjectInCacheByKey:key];
        return;
    }
    
    Lock();
    if (![_keys containsObject:key]) {
        [_keys addObject:key];
    }
    if (![_memoryCacheKeys containsObject:key]) {
        [_memoryCacheKeys addObject:key];
    }
    [_memoryCachedObjects setObject:object forKey:key];
    [self saveObject:object toKey:key];
    Unlock();
}

- (void)storeObjectToMemory:(id)object forKey:(NSString *)key;
{
    if (![self isValidKey:key]) {
        return;
    }
    if (!object || (NSNull*)object == [NSNull null]) {
        return;
    }
    
    Lock();
    if ([_memoryCacheKeys containsObject:key]) {
        [_memoryCacheKeys removeObject:key];
        [_memoryCachedObjects removeObjectForKey:key];
    }
    [_memoryCacheKeys addObject:key];
    Unlock();
    _memoryCachedObjects[key] = object;
}

- (void)removeObjectInCacheByKey:(NSString*)key
{
    if (![self isValidKey:key]) {
        return;
    }
    Lock();
    [_keys removeObject:key];
    [_memoryCachedObjects removeObjectForKey:key];
    [USER_DEFAULT removeObjectForKey:key];
    [self doSave];
    Unlock();
}

- (id)getCachedObjectByKey:(NSString*)key
{
    if (![self isValidKey:key]) {
        return nil;
    }
    
    if ([self hasObjectInMemoryByKey:key]) {
        return _memoryCachedObjects[key];
    }else {
        
        NSObject *obj = nil;
        id data = [USER_DEFAULT objectForKey:key];
        if ([data isKindOfClass:[NSData class]]) {
            obj = (NSObject *)[NSKeyedUnarchiver unarchiveObjectWithData:[USER_DEFAULT objectForKey:key]];
        }
        if (obj) {
            Lock();
            [_memoryCachedObjects setObject:obj forKey:key];
            Unlock();
        }
        return obj;
    }
}

- (BOOL)hasObjectInMemoryByKey:(NSString*)key
{
    if ([_memoryCacheKeys containsObject:key]) {
        return TRUE;
    }
    return FALSE;
}

- (BOOL)hasObjectInCacheByKey:(NSString*)key
{
    if ([self hasObjectInMemoryByKey:key]) {
        return TRUE;
    }
    if ([_keys containsObject:key]) {
        return TRUE;
    }
    return FALSE;
}

- (void)doSave
{
    [USER_DEFAULT setObject:[NSKeyedArchiver archivedDataWithRootObject:_keys] forKey:UD_KEY_DATA_CACHE_KEYS];
    [USER_DEFAULT synchronize];
}

@end
