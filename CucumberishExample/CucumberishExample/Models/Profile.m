//
//	Profile.m
//
//	Create by Ahmed Ali on 19/1/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "Profile.h"

@interface Profile ()
@end
@implementation Profile




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"birthdate"] isKindOfClass:[NSNull class]]){
		self.birthdate = dictionary[@"birthdate"];
	}	
	if(![dictionary[@"email"] isKindOfClass:[NSNull class]]){
		self.email = dictionary[@"email"];
	}	
	if(![dictionary[@"name"] isKindOfClass:[NSNull class]]){
		self.name = dictionary[@"name"];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.birthdate != nil){
		dictionary[@"birthdate"] = self.birthdate;
	}
	if(self.email != nil){
		dictionary[@"email"] = self.email;
	}
	if(self.name != nil){
		dictionary[@"name"] = self.name;
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
	if(self.birthdate != nil){
		[aCoder encodeObject:self.birthdate forKey:@"birthdate"];
	}
	if(self.email != nil){
		[aCoder encodeObject:self.email forKey:@"email"];
	}
	if(self.name != nil){
		[aCoder encodeObject:self.name forKey:@"name"];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.birthdate = [aDecoder decodeObjectForKey:@"birthdate"];
	self.email = [aDecoder decodeObjectForKey:@"email"];
	self.name = [aDecoder decodeObjectForKey:@"name"];
	return self;

}
@end