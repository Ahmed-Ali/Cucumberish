//
//  CCIHock.h
//  Pods
//
//  Created by Ahmed Ali on 19/01/16.
//
//

#import <Foundation/Foundation.h>
@class CCIScenarioDefinition;
typedef void (^CCIScenarioHockBlock)(CCIScenarioDefinition * scenario);

@interface CCIHock : NSObject

@property (nonatomic, copy) CCIScenarioHockBlock block;
@property (nonatomic, strong) NSArray * tags;

+ (instancetype)hockWithTags:(NSArray *)tags block:(CCIScenarioHockBlock)block;
@end
