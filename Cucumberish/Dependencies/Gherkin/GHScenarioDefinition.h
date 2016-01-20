#import <Foundation/Foundation.h>
#import "GHHasLocationProtocol.h"
#import "GHHasDescriptionProtocol.h"
#import "GHHasStepsProtocol.h"
#import "GHHasTagsProtocol.h"

@class GHTag;
@class GHLocation;
@class GHStep;

@interface GHScenarioDefinition : NSObject <GHHasLocationProtocol, GHHasDescriptionProtocol, GHHasStepsProtocol, GHHasTagsProtocol>

@property (nonatomic, readonly) NSArray<GHTag *>    * tags;
@property (nonatomic, readonly) GHLocation          * location;
@property (nonatomic, readonly) NSString            * keyword;
@property (nonatomic, readonly) NSString            * name;
@property (nonatomic, readonly) NSString            * desc;
@property (nonatomic, readonly) NSArray<GHStep *>   * steps;

@end