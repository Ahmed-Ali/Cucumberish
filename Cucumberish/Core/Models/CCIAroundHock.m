//
//  CCIAroundHock.m
//  Pods
//
//  Created by Ahmed Ali on 19/01/16.
//
//

#import "CCIAroundHock.h"

@implementation CCIAroundHock
+ (instancetype)hockWithTags:(NSArray *)tags block:(CCIScenarioExecutionHockBlock)block
{
    CCIAroundHock * hock = [CCIAroundHock new];
    hock.block = block;
    hock.tags = tags;
    return hock;
}
@end
