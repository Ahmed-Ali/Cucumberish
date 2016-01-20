#import "GHScenario.h"

#import "GHScenarioDefinition_Private.h"

#import "GHLocation.h"

@implementation GHScenario

- (id)initWithTags:(NSArray<GHTag *> *)theTags location:(GHLocation *)theLocation keyword:(NSString *)theKeyword name:(NSString *)theName description:(NSString *)theDescription steps:(NSArray<GHStep *> *)theSteps
{
    return [super initWithTags: theTags location: theLocation keyword: theKeyword name: theName description: theDescription steps: theSteps];
}

@end

