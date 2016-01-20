#import <Foundation/Foundation.h>
#import "GHHasDescriptionProtocol.h"
#import "GHHasLocationProtocol.h"
#import "GHHasStepsProtocol.h"

@class GHLocation;

@interface GHBackground : NSObject <GHHasDescriptionProtocol, GHHasLocationProtocol, GHHasStepsProtocol>

@property (nonatomic, readonly) GHLocation  * location;
@property (nonatomic, readonly) NSString    * keyword;
@property (nonatomic, readonly) NSString    * name;
@property (nonatomic, readonly) NSString    * desc;
@property (nonatomic, readonly) NSArray     * steps;

- (id)initWithLocation:(GHLocation *)theLocation keyword:(NSString *)theKeyword name:(NSString *)theName description:(NSString *)theDescription steps:(NSArray *)theSteps;

@end