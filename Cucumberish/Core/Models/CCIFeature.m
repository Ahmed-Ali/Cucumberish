//
//	CCIFeature.m
//
//	Created by Ahmed Ali on 2/1/2016
//  Copyright © 2016 Ahmed Ali. All rights reserved.
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "CCIFeature.h"

@interface CCIFeature ()
@end
@implementation CCIFeature




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(dictionary[@"background"] != nil && ![dictionary[@"background"] isKindOfClass:[NSNull class]]){
		self.background = [[CCIBackground alloc] initWithDictionary:dictionary[@"background"]];
	}

	if(dictionary[@"comments"] != nil && [dictionary[@"comments"] isKindOfClass:[NSArray class]]){
		NSArray * commentsDictionaries = dictionary[@"comments"];
		NSMutableArray * commentsItems = [NSMutableArray array];
		for(NSDictionary * commentsDictionary in commentsDictionaries){
			CCIComment * commentsItem = [[CCIComment alloc] initWithDictionary:commentsDictionary];
			[commentsItems addObject:commentsItem];
		}
		self.comments = commentsItems;
	}
	if(dictionary[@"description"] != nil && ![dictionary[@"description"] isKindOfClass:[NSNull class]]){
		self.descriptionField = dictionary[@"description"];
	}

	if(dictionary[@"keyword"] != nil && ![dictionary[@"keyword"] isKindOfClass:[NSNull class]]){
		self.keyword = dictionary[@"keyword"];
	}

	if(dictionary[@"language"] != nil && ![dictionary[@"language"] isKindOfClass:[NSNull class]]){
		self.language = dictionary[@"language"];
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
	if(dictionary[@"scenarioDefinitions"] != nil && [dictionary[@"scenarioDefinitions"] isKindOfClass:[NSArray class]]){
		NSArray * scenarioDefinitionsDictionaries = dictionary[@"scenarioDefinitions"];
		NSMutableArray * scenarioDefinitionsItems = [NSMutableArray array];
		for(NSDictionary * scenarioDefinitionsDictionary in scenarioDefinitionsDictionaries){
            NSMutableDictionary * scenarioData = [scenarioDefinitionsDictionary mutableCopy];
            if(self.filePath.length > 0){
                scenarioData[@"filePath"] = self.filePath;
            }
			CCIScenarioDefinition * scenarioDefinitionsItem = [[CCIScenarioDefinition alloc] initWithDictionary:scenarioData];
			[scenarioDefinitionsItems addObject:scenarioDefinitionsItem];
		}
		self.scenarioDefinitions = scenarioDefinitionsItems;
	}
	if(dictionary[@"tags"] != nil && [dictionary[@"tags"] isKindOfClass:[NSArray class]]){
		NSArray * tagsDictionaries = dictionary[@"tags"];
		NSMutableArray * tagsItems = [NSMutableArray array];
		for(NSDictionary * tagsDictionary in tagsDictionaries){
			CCITag * tagsItem = [[CCITag alloc] initWithDictionary:tagsDictionary];
			[tagsItems addObject:tagsItem];
		}
		self.tags = tagsItems;
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
	if(self.background != nil){
		dictionary[@"background"] = [self.background toDictionary];
	}
	if(self.comments != nil){
		NSMutableArray * dictionaryElements = [NSMutableArray array];
		for(CCIComment * commentsElement in self.comments){
			[dictionaryElements addObject:[commentsElement toDictionary]];
		}
		dictionary[@"comments"] = dictionaryElements;
	}
	if(self.descriptionField != nil){
		dictionary[@"description"] = self.descriptionField;
	}
	if(self.keyword != nil){
		dictionary[@"keyword"] = self.keyword;
	}
	if(self.language != nil){
		dictionary[@"language"] = self.language;
	}
	if(self.location != nil){
		dictionary[@"location"] = [self.location toDictionary];
	}
	if(self.name != nil){
		dictionary[@"name"] = self.name;
	}
	if(self.scenarioDefinitions != nil){
		NSMutableArray * dictionaryElements = [NSMutableArray array];
		for(CCIScenarioDefinition * scenarioDefinitionsElement in self.scenarioDefinitions){
			[dictionaryElements addObject:[scenarioDefinitionsElement toDictionary]];
		}
		dictionary[@"scenarioDefinitions"] = dictionaryElements;
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
	if(self.background != nil){
		[aCoder encodeObject:self.background forKey:@"background"];
	}
	if(self.comments != nil){
		[aCoder encodeObject:self.comments forKey:@"comments"];
	}
	if(self.descriptionField != nil){
		[aCoder encodeObject:self.descriptionField forKey:@"description"];
	}
	if(self.keyword != nil){
		[aCoder encodeObject:self.keyword forKey:@"keyword"];
	}
	if(self.language != nil){
		[aCoder encodeObject:self.language forKey:@"language"];
	}
	if(self.location != nil){
		[aCoder encodeObject:self.location forKey:@"location"];
	}
	if(self.name != nil){
		[aCoder encodeObject:self.name forKey:@"name"];
	}
	if(self.scenarioDefinitions != nil){
		[aCoder encodeObject:self.scenarioDefinitions forKey:@"scenarioDefinitions"];
	}
	if(self.tags != nil){
		[aCoder encodeObject:self.tags forKey:@"tags"];
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
	self.background = [aDecoder decodeObjectForKey:@"background"];
	self.comments = [aDecoder decodeObjectForKey:@"comments"];
	self.descriptionField = [aDecoder decodeObjectForKey:@"description"];
	self.keyword = [aDecoder decodeObjectForKey:@"keyword"];
	self.language = [aDecoder decodeObjectForKey:@"language"];
	self.location = [aDecoder decodeObjectForKey:@"location"];
	self.name = [aDecoder decodeObjectForKey:@"name"];
	self.scenarioDefinitions = [aDecoder decodeObjectForKey:@"scenarioDefinitions"];
	self.tags = [aDecoder decodeObjectForKey:@"tags"];
	self.type = [aDecoder decodeObjectForKey:@"type"];
	return self;

}

- (void)setBackground:(CCIBackground *)background {
    _background = background;
}
@end