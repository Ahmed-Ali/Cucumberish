//
//  CCIAroundHock.h
//  Pods
//
//  Created by Ahmed Ali on 19/01/16.
//
//

#import <Foundation/Foundation.h>

@class CCIScenarioDefinition;
typedef void (^CCIScenarioExecutionHockBlock)(CCIScenarioDefinition * scenario, void (^)(void) );


@interface CCIAroundHock : NSObject

@property (nonatomic, strong) NSArray * tags;
@property (nonatomic, copy) CCIScenarioExecutionHockBlock block;

+ (instancetype)hockWithTags:(NSArray *)tags block:(CCIScenarioExecutionHockBlock)block;
@end
