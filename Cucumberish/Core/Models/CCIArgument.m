//
//	CCIArgument.m
//
//	Create by Ahmed Ali on 2/1/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "CCIArgument.h"

@interface CCIArgument ()
@end
@implementation CCIArgument




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(dictionary[@"location"] != nil && ![dictionary[@"location"] isKindOfClass:[NSNull class]]){
		self.location = [[CCILocation alloc] initWithDictionary:dictionary[@"location"]];
	}

	if(dictionary[@"rows"] != nil && [dictionary[@"rows"] isKindOfClass:[NSArray class]]){
		NSArray * rowsDictionaries = dictionary[@"rows"];
		NSMutableArray * rowsItems = [NSMutableArray array];
		for(NSDictionary * rowsDictionary in rowsDictionaries){
			CCIRow * rowsItem = [[CCIRow alloc] initWithDictionary:rowsDictionary];
			[rowsItems addObject:rowsItem];
		}
		self.rows = rowsItems;
	}
	if(dictionary[@"type"] != nil && ![dictionary[@"type"] isKindOfClass:[NSNull class]]){
		self.type = dictionary[@"type"];
	}
    if(dictionary[@"content"] != nil && ![dictionary[@"content"] isKindOfClass:[NSNull class]]){
        self.content = dictionary[@"content"];
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
	if(self.rows != nil){
		NSMutableArray * dictionaryElements = [NSMutableArray array];
		for(CCIRow * rowsElement in self.rows){
			[dictionaryElements addObject:[rowsElement toDictionary]];
		}
		dictionary[@"rows"] = dictionaryElements;
	}
	if(self.type != nil){
		dictionary[@"type"] = self.type;
	}
    if(self.content != nil){
        dictionary[@"content"] = self.content;
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
	if(self.rows != nil){
		[aCoder encodeObject:self.rows forKey:@"rows"];
	}
	if(self.type != nil){
		[aCoder encodeObject:self.type forKey:@"type"];
	}
    if(self.content != nil){
        [aCoder encodeObject:self.content forKey:@"content"];
    }

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.location = [aDecoder decodeObjectForKey:@"location"];
	self.rows = [aDecoder decodeObjectForKey:@"rows"];
	self.type = [aDecoder decodeObjectForKey:@"type"];
    self.content = [aDecoder decodeObjectForKey:@"content"];
	return self;

}
@end