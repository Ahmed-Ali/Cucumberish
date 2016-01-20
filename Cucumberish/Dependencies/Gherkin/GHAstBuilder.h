#import <Foundation/Foundation.h>
#import "GHAstNode.h"
#import "GHParser.h"

@class GHToken;

@interface GHAstBuilder : NSObject<GHAstBuilderProtocol>

- (id)init;
- (void)reset;
- (void)buildWithToken:(GHToken *)theToken;
- (void)startRuleWithType:(GHRuleType)theRuleType;
- (void)endRuleWithType:(GHRuleType)theRuleType;

@end