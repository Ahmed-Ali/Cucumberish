//
//  HistoryDAO.h
//  CucumberishExample
//
//  Created by Ahmed Ali on 19/01/16.
//  Copyright © 2016 Ahmed Ali. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoryDAO : NSObject

@property (nonatomic, strong) NSArray * historyRecords;

+ (instancetype)instance;

- (void)addHistoryRecordWithDescription:(NSString *)recordDescription;


- (void)clearHistory;
@end
