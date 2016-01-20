#import "GHFeature.h"

#import "GHTag.h"
#import "GHLocation.h"
#import "GHBackground.h"
#import "GHScenarioDefinition.h"
#import "GHComment.h"

@interface GHFeature ()

@property (nonatomic, strong) NSArray<GHTag *>                  * tags;
@property (nonatomic, strong) GHLocation                        * location;
@property (nonatomic, strong) NSString                          * language;
@property (nonatomic, strong) NSString                          * keyword;
@property (nonatomic, strong) NSString                          * name;
@property (nonatomic, strong) NSString                          * desc;
@property (nonatomic, strong) GHBackground                      * background;
@property (nonatomic, strong) NSArray<GHScenarioDefinition *>   * scenarioDefinitions;
@property (nonatomic, strong) NSArray<GHComment *>              * comments;

@end

@implementation GHFeature

@synthesize tags;
@synthesize location;
@synthesize language;
@synthesize keyword;
@synthesize name;
@synthesize desc;
@synthesize background;
@synthesize scenarioDefinitions;
@synthesize comments;

- (id)initWithTags:(NSArray<GHTag *> *)theTags location:(GHLocation *)theLocation language:(NSString *)theLanguage keyword:(NSString *)theKeyword name:(NSString *)theName description:(NSString *)theDescription background:(GHBackground *)theBackground scenarioDefinitions:(NSArray<GHScenarioDefinition *> *)theScenarioDefinitions comments:(NSArray<GHComment *> *)theComments
{
    if (self = [super init])
    {
        tags = theTags;
        location = theLocation;
        language = theLanguage;
        keyword = theKeyword;
        name = theName;
        desc = theDescription;
        background = theBackground;
        scenarioDefinitions = theScenarioDefinitions;
        comments = theComments;
    }
    
    return self;
}

@end