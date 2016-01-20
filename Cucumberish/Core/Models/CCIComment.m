//
//	CCIComment.m
//
//	Create by Ahmed Ali on 2/1/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "CCIComment.h"

@interface CCIComment ()
@end
@implementation CCIComment




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(dictionary[@"location"] != nil && ![dictionary[@"location"] isKindOfClass:[NSNull class]]){
		self.location = [[CCILocation alloc] initWithDictionary:dictionary[@"location"]];
	}

	if(dictionary[@"text"] != nil && ![dictionary[@"text"] isKindOfClass:[NSNull class]]){
		self.text = dictionary[@"text"];
	}

	if(dictionary[@"type"] != nil && ![dictionary[@"type"] isKindOfClass:[NSNull class]]){
		self.type = dictionary[@"type"];
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
	if(self.text != nil){
		dictionary[@"text"] = self.text;
	}
	if(self.type != nil){
		dictionary[@"type"] = self.type;
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
	if(self.text != nil){
		[aCoder encodeObject:self.text forKey:@"text"];
	}
	if(self.type != nil){
		[aCoder encodeObject:self.type forKey:@"type"];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.location = [aDecoder decodeObjectForKey:@"location"];
	self.text = [aDecoder decodeObjectForKey:@"text"];
	self.type = [aDecoder decodeObjectForKey:@"type"];
	return self;

}
@end