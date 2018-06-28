//
//  WSPropertyModel.h
//  WSAutoProduceModel
//
//  Created by wenrisheng on 16/5/27.
//  Copyright © 2016年 wenrisheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSPropertyModel : NSObject

@property (strong, nonatomic) NSString *type;  // 属性类型名
@property (strong, nonatomic) NSString *name;  // 属性名
@property (strong, nonatomic) id value;         // 属性值

@end
