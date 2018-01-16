//
//  OPDBCreater.h
//  AccountingLife
//
//  Created by RedRain on 16/11/19.
//  Copyright © 2016年 haixue. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WBDBCreater <NSObject>

@required
// 初次创建数据库表
- (BOOL)createTable;

@optional
- (BOOL)expandTable:(int)oldVersion;

@end
