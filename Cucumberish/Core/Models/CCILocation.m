//
//	CCILocation.m
//
//	Create by Ahmed Ali on 2/1/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "CCILocation.h"

@interface CCILocation ()
@end
@implementation CCILocation




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(dictionary[@"column"] != nil && ![dictionary[@"column"] isKindOfClass:[NSNull class]]){
		self.column = [dictionary[@"column"] integerValue];
	}

	if(dictionary[@"line"] != nil && ![dictionary[@"line"] isKindOfClass:[NSNull class]]){
		self.line = [dictionary[@"line"] integerValue];
	}

	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	dictionary[@"column"] = @(self.column);
	dictionary[@"line"] = @(self.line);
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
	[aCoder encodeObject:@(self.column) forKey:@"column"];	[aCoder encodeObject:@(self.line) forKey:@"line"];
}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.column = [[aDecoder decodeObjectForKey:@"column"] integerValue];
	self.line = [[aDecoder decodeObjectForKey:@"line"] integerValue];
	return self;

}
@end