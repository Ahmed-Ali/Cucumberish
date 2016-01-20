//
//  HistoryDAO.m
//  CucumberishExample
//
//  Created by Ahmed Ali on 19/01/16.
//  Copyright © 2016 Ahmed Ali. All rights reserved.
//

#import "HistoryDAO.h"

@implementation HistoryDAO
+ (instancetype)instance
{
    static HistoryDAO * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [HistoryDAO new];
    });
    
    return instance;
}

- (NSArray *)historyRecords
{
    if(_historyRecords == nil){
        _historyRecords = [[NSUserDefaults standardUserDefaults] objectForKey:@"HistoryRecords"] ? : @[];
    }
    
    return _historyRecords;
}

- (void)addHistoryRecordWithDescription:(NSString *)recordDescription
{
    NSMutableArray * records = [self.historyRecords mutableCopy];
    [records addObject:recordDescription];
    self.historyRecords = [NSArray arrayWithArray:records];
    [self saveRecords];
    
}

- (void)saveRecords
{
    [[NSUserDefaults standardUserDefaults] setObject:self.historyRecords forKey:@"HistoryRecords"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)clearHistory
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"HistoryRecords"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _historyRecords = @[];
}
@end
