//
//  CCIExecutionResult.h
//  CucumberishExample
//
//  Created by Ahmed Ali on 07/01/16.
//  Copyright © 2016 Ahmed Ali. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, CCIExecutionStatus) {
    CCIExecutionStatusPass,
    CCIExecutionStatusFail,
    
};
@interface CCIExecutionResult : NSObject
@property (nonatomic) CCIExecutionStatus status;
@property (nonatomic, copy) NSString * reason;



+ (instancetype)status:(CCIExecutionStatus)status reason:(NSString *)reason;
@end
