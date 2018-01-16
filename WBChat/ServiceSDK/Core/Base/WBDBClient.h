//
//  OPDBClient.h

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "WBSynthesizeSingleton.h"
#import "WBCoreConfiguration.h"


NS_ASSUME_NONNULL_BEGIN
@interface WBDBClient : NSObject

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;


@property (nonatomic, strong) NSMutableArray *dbCreaters;           // OPDBCreater
@property (nonatomic, strong) NSMutableArray *terminateHandlers;    // OPTerminateHandler

// 创建单利
WB_SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(WBDBClient);


#pragma mark - About DB

- (void)openDB:(NSString *)userId;

- (void)closeDB;


#pragma mark - Start
- (void)createTable;
- (void)extendTable:(int)version;

- (void)registerDBCreater:(id<WBDBCreater>)creater;
- (void)registerTerminateHandler:(id)handler;

-(void)doTerminateHandlerTask;
@end

NS_ASSUME_NONNULL_END
