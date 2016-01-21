//
//	CCIScenarioDefinition.m
//
//	Create by Ahmed Ali on 17/1/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "CCIScenarioDefinition.h"

@interface CCIScenarioDefinition ()
@end
@implementation CCIScenarioDefinition




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
    
    if(dictionary[@"examples"] != nil && [dictionary[@"examples"] isKindOfClass:[NSArray class]]){
        NSArray * examplesDictionaries = dictionary[@"examples"];
        NSMutableArray * examplesItems = [NSMutableArray array];
        for(NSDictionary * examplesDictionary in examplesDictionaries){
            CCIExample * examplesItem = [[CCIExample alloc] initWithDictionary:examplesDictionary];
            [examplesItems addObject:examplesItem];
        }
        self.examples = examplesItems;
    }
	if(dictionary[@"keyword"] != nil && ![dictionary[@"keyword"] isKindOfClass:[NSNull class]]){
		self.keyword = dictionary[@"keyword"];
	}

	if(dictionary[@"location"] != nil && ![dictionary[@"location"] isKindOfClass:[NSNull class]]){
		self.location = [[CCILocation alloc] initWithDictionary:dictionary[@"location"]];
	}

	if(dictionary[@"name"] != nil && ![dictionary[@"name"] isKindOfClass:[NSNull class]]){
		self.name = dictionary[@"name"];
	}
    if(dictionary[@"filePath"] != nil && ![dictionary[@"filePath"] isKindOfClass:[NSNull class]]){
        self.filePath = dictionary[@"filePath"];
    }

	if(dictionary[@"steps"] != nil && [dictionary[@"steps"] isKindOfClass:[NSArray class]]){
		NSArray * stepDictionaries = dictionary[@"steps"];
		NSMutableArray * stepsItems = [NSMutableArray array];
		for(NSDictionary * stepDictionary in stepDictionaries){
            NSMutableDictionary * stepData = [stepDictionary mutableCopy];
            if(self.filePath.length > 0){
                stepData[@"filePath"] = self.filePath;
            }
			CCIStep * stepsItem = [[CCIStep alloc] initWithDictionary:stepData];
			[stepsItems addObject:stepsItem];
		}
		self.steps = stepsItems;
	}
	if(dictionary[@"tags"] != nil && ![dictionary[@"tags"] isKindOfClass:[NSNull class]]){
        NSArray * tagDictionaries = dictionary[@"tags"];
        NSMutableArray * tagsItems = [NSMutableArray array];
        for(NSDictionary * tagDictionary in tagDictionaries){
            NSMutableDictionary * tagData = [tagDictionary mutableCopy];
            
            CCITag * tagsItem = [[CCITag alloc] initWithDictionary:tagData];
            [tagsItems addObject:tagsItem];
        }
        self.tags = tagsItems;
	}

	if(dictionary[@"type"] != nil && ![dictionary[@"type"] isKindOfClass:[NSNull class]]){
		self.type = dictionary[@"type"];
	}
    
    if (![dictionary[@"filePath"] isKindOfClass:[NSNull class]]) {
        self.filePath = dictionary[@"filePath"];
    }
    
    if(dictionary[@"success"] != nil && ![dictionary[@"success"] isKindOfClass:[NSNull class]]){
        self.success = [dictionary[@"success"] boolValue];
    }else{
        //By default scenario considered as success
        self.success = YES;
    }
    if(dictionary[@"failureReason"] != nil && ![dictionary[@"failureReason"] isKindOfClass:[NSNull class]]){
        self.failureReason = dictionary[@"failureReason"];
    }
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    if(self.examples != nil){
        NSMutableArray * dictionaryElements = [NSMutableArray array];
        for(CCIExample * examplesElement in self.examples){
            [dictionaryElements addObject:[examplesElement toDictionary]];
        }
        dictionary[@"examples"] = dictionaryElements;
    }
    if(self.keyword != nil){
        dictionary[@"keyword"] = self.keyword;
    }
    if(self.location != nil){
        dictionary[@"location"] = [self.location toDictionary];
    }
    if(self.name != nil){
        dictionary[@"name"] = self.name;
    }
    if(self.steps != nil){
        NSMutableArray * dictionaryElements = [NSMutableArray array];
        for(CCIStep * stepsElement in self.steps){
            [dictionaryElements addObject:[stepsElement toDictionary]];
        }
        dictionary[@"steps"] = dictionaryElements;
    }
    if(self.tags != nil){
        NSMutableArray * dictionaryElements = [NSMutableArray array];
        for(CCITag * tagsElement in self.tags){
            [dictionaryElements addObject:[tagsElement toDictionary]];
        }
        dictionary[@"tags"] = dictionaryElements;
    }
    if(self.type != nil){
        dictionary[@"type"] = self.type;
    }
    if(self.filePath != nil){
        dictionary[@"filePath"] = self.filePath;
    }
    
    
    
    dictionary[@"success"] = @(self.success);
    if(self.failureReason.length > 0){
        dictionary[@"failureReason"] = self.failureReason;
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
    if(self.examples != nil){
        [aCoder encodeObject:self.examples forKey:@"examples"];
    }
    if(self.keyword != nil){
        [aCoder encodeObject:self.keyword forKey:@"keyword"];
    }
    if(self.location != nil){
        [aCoder encodeObject:self.location forKey:@"location"];
    }
    if(self.name != nil){
        [aCoder encodeObject:self.name forKey:@"name"];
    }
    if(self.steps != nil){
        [aCoder encodeObject:self.steps forKey:@"steps"];
    }
    if(self.tags != nil){
        [aCoder encodeObject:self.tags forKey:@"tags"];
    }
    if(self.type != nil){
        [aCoder encodeObject:self.type forKey:@"type"];
    }
    if(self.filePath != nil){
        [aCoder encodeObject:self.filePath forKey:@"filePath"];
    }
    [aCoder encodeObject:@(self.success) forKey:@"success"];
    if(self.failureReason.length > 0){
        [aCoder encodeObject:self.failureReason forKey:@"failureReason"];
    }
    
}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    self.examples = [aDecoder decodeObjectForKey:@"examples"];
    self.keyword = [aDecoder decodeObjectForKey:@"keyword"];
    self.location = [aDecoder decodeObjectForKey:@"location"];
    self.name = [aDecoder decodeObjectForKey:@"name"];
    self.steps = [aDecoder decodeObjectForKey:@"steps"];
    self.tags = [aDecoder decodeObjectForKey:@"tags"];
    self.type = [aDecoder decodeObjectForKey:@"type"];
    self.filePath = [aDecoder decodeObjectForKey:@"filePath"];
    self.success = [aDecoder decodeObjectForKey:@"success"];
    self.failureReason = [aDecoder decodeObjectForKey:@"failureReason"];
    
    return self;
}

#pragma mark - NSCopying
- (instancetype)copyWithZone:(NSZone *)zone
{
    CCIScenarioDefinition * copy = [[CCIScenarioDefinition alloc] initWithDictionary:[self toDictionary]];
    return copy;
}
@end