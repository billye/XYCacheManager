//
//  YCCacheDao.h
//  iWeidao
//
//  Created by billyye on 15/9/21.
//  Copyright (c) 2015年 yongche. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef void (^YCFileCacheCompletionBlock)(BOOL success, NSString *key);


@interface YCCacheDao : NSObject
@property (nonatomic, strong) NSCache *memoryCache;
@property (nonatomic, strong) dispatch_queue_t cacheQueue;


+ (instancetype)shareManager;

- (NSString *)getCachePathForKey:(NSString *)key;

/**
 *  register Memory Notification
 *
 *  @param action handel memory warning event
 */
- (void)registerMemoryWarningNotification;

/**
 *  valid cached key
 *
 *  @param key The unique object cache key
 *
 *  @return available key return YES, unavailable key return NO
 */
- (BOOL)isValidKey:(NSString*)key;

/**
 *  valid cached object
 *
 *  @param object The cached object
 *
 *  @return available object return YES, unavailable object return NO
 */
- (BOOL)isValidObject:(id)object;

/**
 *  archived object
 *
 *  @param object The object should be archived
 *
 *  @return  return the archived object
 */
- (id)archivedObjectWithObject:(id)object;

/**
 *  unarchive object
 *
 *  @param object The object should be unarchived
 *
 *  @return return the unarchived object
 */
- (id)unarchivedObjectWithObject:(id)object;

/**
 *  cached object exists at key
 *
 *  @param key The unique object cache key
 *
 *  @return  cached object  YES or NO
 */
- (BOOL)hasObjectInCacheByKey:(NSString*)key;

/**
 *  Get the cache object at the given key
 *
 *  @param key The unique object cache key
 *
 *  @return cached object, if can't find return nil
 */
- (id)getCachedObjectByKey:(NSString*)key;

/**
 *  Get The Cache with the given Object Class and key
 *
 *  @param objectClass cache object Class
 *  @param key         The unique object cache key
 *
 *  @return cache object
 */
- (id)getCachedObject:(Class)objectClass forKey:(NSString *)key;

/**
 *  Remove cached object by cached key
 *
 *  @param key The unique object cache key
 */
- (void)removeObjectInCacheByKey:(NSString*)key;

/**
 *  Store an object into memory and optionally disk cache at the given key.
 *
 *  @param object the object to store
 *  @param key    The unique object cache key
 */
- (void)storeObject:(id<NSCoding>)object forKey:(NSString *)key;

/**
 *  Store an object into memory and optionally disk cache at the given key, callback by compeletionBlock.
 *
 *  @param object           object the object to store
 *  @param key              The unique object cache key
 *  @param compeletionBlock compeletionBlock
 */
- (void)storeObject:(id<NSCoding>)object forKey:(NSString *)key completion:(YCFileCacheCompletionBlock)compeletionBlock;

/**
 *  Store an object only into memory cache at the given key.
 *
 *  @param object the object to store
 *  @param key    The unique object cache key
 */
- (void)storeObjectToMemory:(id)object forKey:(NSString *)key;

/*!
 * clear all cached objects in disk and memory
 */
- (void)clearAllCache;

/*!
 * clear all cached objects in disk
 */
- (void)clearAllDiskCache;

/*!
 * clear all memory cached objects
 */
- (void)clearMemoryCache;

@end
