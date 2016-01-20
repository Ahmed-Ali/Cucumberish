//
//	Activity.m
//
//	Create by Ahmed Ali on 19/1/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "Activity.h"

@interface Activity ()
@end
@implementation Activity




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"current"] isKindOfClass:[NSNull class]]){
		self.current = [dictionary[@"current"] boolValue];
	}

	if(![dictionary[@"name"] isKindOfClass:[NSNull class]]){
		self.name = dictionary[@"name"];
	}	
	if(![dictionary[@"rank"] isKindOfClass:[NSNull class]]){
		self.rank = [dictionary[@"rank"] integerValue];
	}

	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	dictionary[@"current"] = @(self.current);
	if(self.name != nil){
		dictionary[@"name"] = self.name;
	}
	dictionary[@"rank"] = @(self.rank);
	return dictionary;

}

/**
 * Implementation of NSCoding encoding method
 */
/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:@(self.current) forKey:@"current"];	if(self.name != nil){
		[aCoder encodeObject:self.name forKey:@"name"];
	}
	[aCoder encodeObject:@(self.rank) forKey:@"rank"];
}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.current = [[aDecoder decodeObjectForKey:@"current"] boolValue];
	self.name = [aDecoder decodeObjectForKey:@"name"];
	self.rank = [[aDecoder decodeObjectForKey:@"rank"] integerValue];
	return self;

}
@end