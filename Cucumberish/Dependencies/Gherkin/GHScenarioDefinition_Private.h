#import <Foundation/Foundation.h>
@interface GHScenarioDefinition (Private)

- (id)initWithTags:(NSArray<GHTag *> *)theTags location:(GHLocation *)theLocation keyword:(NSString *)theKeyword name:(NSString *)theName description:(NSString *)theDescription steps:(NSArray<GHStep *> *)theSteps;

@end
