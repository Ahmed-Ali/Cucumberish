#import <Foundation/Foundation.h>
#import "GHHasLocationProtocol.h"

@class GHLocation;

@interface GHTag : NSObject <GHHasLocationProtocol>

@property (nonatomic, readonly) GHLocation  * location;
@property (nonatomic, readonly) NSString    * name;

- (id)initWithLocation:(GHLocation *)theLocation name:(NSString *)theName;

@end