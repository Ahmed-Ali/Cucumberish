#import "GHBackground.h"

#import "GHLocation.h"

@interface GHBackground ()

@property (nonatomic, strong) GHLocation  * location;
@property (nonatomic, strong) NSString    * keyword;
@property (nonatomic, strong) NSString    * name;
@property (nonatomic, strong) NSString    * desc;
@property (nonatomic, strong) NSArray     * steps;

@end

@implementation GHBackground

@synthesize location;
@synthesize keyword;
@synthesize name;
@synthesize desc;
@synthesize steps;


- (id)initWithLocation:(GHLocation *)theLocation keyword:(NSString *)theKeyword name:(NSString *)theName description:(NSString *)theDescription steps:(NSArray *)theSteps
{
    if (self = [super init])
    {
        location = theLocation;
        keyword = theKeyword;
        name = theName;
        desc = theDescription;
        steps = theSteps;
    }
    
    return self;
}

@end