//
//  HistoryDAO.m
//  CucumberishExample
//
//  Created by Ahmed Ali on 19/01/16.
//  Copyright © 2016 Ahmed Ali. All rights reserved.
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

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
