//
//  YCCacheManager.h
//  iYongche
//
//  Created by billyye on 16/2/19.
//  Copyright © 2016年 yongche. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YCCacheManager : NSObject
+ (instancetype)shareManager;

///========================== NSUserDefault =======================================
///
/// If the object's data size (in bytes) is smaller, recommended to use NSUseDefault
/// usually cahce some marks and needn't clean cache forever
///
///=================================================================================
/**
  1. 存取的object 必须遵循NSCoding 协议
  2. object 会同步加入memory cache中，写入本地在异步线程进行
 */
- (void)ud_setObject:(id<NSCoding>)object forKey:(NSString *)key;

/**
 1. 同步移除NSUserDefault 中key 所对应的value
 */
- (void)ud_removeObjectForKey:(NSString *)key;

/**
 1. 判断UserDefault 中是否有缓存传入key
 */
- (BOOL)ud_containsObjectForKey:(NSString *)key;

///========================= YYCache ================================================
///
/// It use `YYMemoryCache` to store objects in a small and fast memory cache,
/// and use `YYDiskCache` to persisting objects to a large and slow disk cache.
/// See `YYMemoryCache` and `YYDiskCache` for more information
///
///==================================================================================

/** 
   1.方法会阻塞住当前调用线程直到文件存完
   2.存的object 必须遵循NSCoding 协议
   3.如果object 是空值，将会调用`removeObjectForKey:`
 */
- (void)yc_setObject:(id<NSCoding>)object forKey:(NSString *)key;

/**
   1. block 将会在操作完成之后在异步线程进行回调通知
   2. 存的object 必须遵循NSCoding 协议
   3. 如果object 是空值，将会调用`removeObjectForKey:`
 */
- (void)yc_setObject:(id<NSCoding>)object forKey:(NSString *)key withBlock:(void(^)(void))block;

/**
 1.方法会阻塞住当前调用线程直到文件存完
 2.如果key 为空值，将返回空值
 */
- (id<NSCoding>)yc_objectForKey:(NSString *)key;

/**
 1.block 将会在操作完成之后在异步线程进行回调通知
 2.如果key 为空值，将返回空值
 */
- (void)yc_objectForKey:(NSString *)key withBlock:(void(^)(NSString *key, id<NSCoding> object))block;

- (void)yc_removeObjectForKey:(NSString *)key;

/**
  1.移除包括本地 和内存缓存中key 所对应的值
  2.block 将会在操作完成之后在异步线程进行回调通知
 */
- (void)yc_removeObjectForKey:(NSString *)key withBlock:(void(^)(NSString *key))block;

/**
 1.同步移除YYCache中所有的本地缓存和内存缓存
 */
- (void)yc_removeAllObjects;

/**
 1.异步移除YYCache中所有的本地缓存和内存缓存
 2.block 将会在操作完成之后在异步线程进行回调通知
 */
- (void)yc_removeAllObjectsWithBlock:(void(^)(void))block;
@end
