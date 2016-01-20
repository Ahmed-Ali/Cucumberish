#import "GHScenarioOutline.h"

#import "GHScenarioDefinition_Private.h"

@interface GHScenarioOutline ()

@property (nonatomic, strong) NSArray<GHExamples *> * examples;

@end

@implementation GHScenarioOutline

@synthesize examples;

- (id)initWithTags:(NSArray<GHTag *> *)theTags location:(GHLocation *)theLocation keyword:(NSString *)theKeyword name:(NSString *)theName description:(NSString *)theDescription steps:(NSArray<GHStep *> *)theSteps examples:(NSArray<GHExamples *> *)theExamples
{
    if (self = [super initWithTags: theTags location: theLocation keyword: theKeyword name: theName description: theDescription steps: theSteps])
    {
        examples = theExamples;
    }
    return self;
}

@end