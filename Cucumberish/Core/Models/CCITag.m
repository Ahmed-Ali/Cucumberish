//
//	CCITag.m
//
//	Create by Ahmed Ali on 2/1/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "CCITag.h"

@interface CCITag ()
@end
@implementation CCITag




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(dictionary[@"location"] != nil && ![dictionary[@"location"] isKindOfClass:[NSNull class]]){
		self.location = [[CCILocation alloc] initWithDictionary:dictionary[@"location"]];
	}

	if(dictionary[@"name"] != nil && ![dictionary[@"name"] isKindOfClass:[NSNull class]]){
		self.name = dictionary[@"name"];
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
	if(self.name != nil){
		dictionary[@"name"] = self.name;
	}
	if(self.type != nil){
		dictionary[@"type"] = self.type;
	}
	return dictionary;

}

- (void)setName:(NSString *)name
{
    if ([name hasPrefix:@"@"]) {
        name = [name stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
    }
    _name = name;
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
	if(self.name != nil){
		[aCoder encodeObject:self.name forKey:@"name"];
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
	self.name = [aDecoder decodeObjectForKey:@"name"];
	self.type = [aDecoder decodeObjectForKey:@"type"];
	return self;

}
@end