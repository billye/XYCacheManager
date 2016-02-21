//
//  YCDataBaseModel.h
//  iWeidao
//
//  Created by billyye on 15/5/7.
//  Copyright (c) 2015年 yongche. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YCBaseModelObject : NSObject

/**
 *  初始化
 *
 *  @param dict json字典
 *
 *  @return 单个Model对象
 */
- (id)initWithDataDic:(NSDictionary*)data;

/**
 *
 *  @Note: 子类重写，属性名与json 键值相对
 *
 */
- (NSDictionary*)attributeMapDictionary;

/**
 *
 *  @Note: 子类重写，debug 自定义描述
 *
 */

- (NSString*)customDescription;

/**
 *
 *  @Note: 打印默认参数描述
 *
 */

- (NSString*)description;

/**
 *
 *  @return model 序列化 
 *
 */

- (NSData*)getArchivedData;

@end
