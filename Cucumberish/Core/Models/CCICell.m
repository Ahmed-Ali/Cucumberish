//
//	CCICell.m
//
//	Create by Ahmed Ali on 2/1/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "CCICell.h"

@interface CCICell ()
@end
@implementation CCICell




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(dictionary[@"location"] != nil && ![dictionary[@"location"] isKindOfClass:[NSNull class]]){
		self.location = [[CCILocation alloc] initWithDictionary:dictionary[@"location"]];
	}

	if(dictionary[@"type"] != nil && ![dictionary[@"type"] isKindOfClass:[NSNull class]]){
		self.type = dictionary[@"type"];
	}

	if(dictionary[@"value"] != nil && ![dictionary[@"value"] isKindOfClass:[NSNull class]]){
		self.value = dictionary[@"value"];
	}

	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.location != nil){
		dictionary[@"location"] = [self.location toDictionary];
	}
	if(self.type != nil){
		dictionary[@"type"] = self.type;
	}
	if(self.value != nil){
		dictionary[@"value"] = self.value;
	}
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
	if(self.location != nil){
		[aCoder encodeObject:self.location forKey:@"location"];
	}
	if(self.type != nil){
		[aCoder encodeObject:self.type forKey:@"type"];
	}
	if(self.value != nil){
		[aCoder encodeObject:self.value forKey:@"value"];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.location = [aDecoder decodeObjectForKey:@"location"];
	self.type = [aDecoder decodeObjectForKey:@"type"];
	self.value = [aDecoder decodeObjectForKey:@"value"];
	return self;

}
@end