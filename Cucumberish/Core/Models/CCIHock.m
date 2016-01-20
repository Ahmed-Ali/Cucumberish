//
//  CCIHock.m
//  Pods
//
//  Created by Ahmed Ali on 19/01/16.
//
//

#import "CCIHock.h"

@implementation CCIHock
+ (instancetype)hockWithTags:(NSArray *)tags block:(CCIScenarioHockBlock)block
{
    CCIHock * hock = [CCIHock new];
    hock.block = block;
    hock.tags = tags;
    return hock;
}
@end
