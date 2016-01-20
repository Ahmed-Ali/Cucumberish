//
//	CCIStep.m
//
//	Create by Ahmed Ali on 2/1/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "CCIStep.h"

const NSString * kCCIStepTypeStep = @"Step";
const NSString * kCCIStepTypeFunction = @"Func";

@interface CCIStep ()
@end
@implementation CCIStep




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(dictionary[@"keyword"] != nil && ![dictionary[@"keyword"] isKindOfClass:[NSNull class]]){
        self.keyword = [dictionary[@"keyword"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	}

	if(dictionary[@"location"] != nil && ![dictionary[@"location"] isKindOfClass:[NSNull class]]){
		self.location = [[CCILocation alloc] initWithDictionary:dictionary[@"location"]];
	}

	if(dictionary[@"text"] != nil && ![dictionary[@"text"] isKindOfClass:[NSNull class]]){
		self.text = dictionary[@"text"];
	}

	if(dictionary[@"type"] != nil && ![dictionary[@"type"] isKindOfClass:[NSNull class]]){
		self.type = dictionary[@"type"];
	}
    
    if(dictionary[@"filePath"] != nil && ![dictionary[@"filePath"] isKindOfClass:[NSNull class]]){
        self.filePath = dictionary[@"filePath"];
    }
    if(dictionary[@"argument"] != nil && ![dictionary[@"argument"] isKindOfClass:[NSNull class]]){
        self.argument = [[CCIArgument alloc] initWithDictionary:dictionary[@"argument"]];
    }
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.keyword != nil){
		dictionary[@"keyword"] = self.keyword;
	}
	if(self.location != nil){
		dictionary[@"location"] = [self.location toDictionary];
	}
	if(self.text != nil){
		dictionary[@"text"] = self.text;
	}
	if(self.type != nil){
		dictionary[@"type"] = self.type;
	}
    if(self.filePath != nil){
        dictionary[@"filePath"] = self.filePath;
    }
    if(self.argument != nil){
        dictionary[@"argument"] = [self.argument toDictionary];
    }
	return dictionary;

}


- (NSString *)description
{
    return [NSString stringWithFormat:@"Step text: %@", self.text];
}

- (id)copyWithZone:(NSZone *)zone
{
    return [[CCIStep alloc] initWithDictionary:[self toDictionary]];
}
@end