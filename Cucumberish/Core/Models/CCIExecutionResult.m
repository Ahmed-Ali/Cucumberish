//
//  CCIExecutionResult.m
//  CucumberishExample
//
//  Created by Ahmed Ali on 07/01/16.
//  Copyright © 2016 Ahmed Ali. All rights reserved.
//

#import "CCIExecutionResult.h"

@implementation CCIExecutionResult
-(instancetype)initWithResult:(CCIExecutionStatus)status reason:(NSString  * _Nullable)reason
{
    self = [super init];
    self.status = status;
    
    self.reason = reason;
    return self;
}

+ (instancetype)status:(CCIExecutionStatus)status reason:(NSString *)reason
{
    return [[self alloc] initWithResult:status reason:reason];
}
@end
