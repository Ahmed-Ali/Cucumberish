//
//	CCITableBody.m
//
//	Create by Ahmed Ali on 17/1/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "CCITableBody.h"

@interface CCITableBody ()
@end
@implementation CCITableBody




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(dictionary[@"cells"] != nil && [dictionary[@"cells"] isKindOfClass:[NSArray class]]){
        NSArray * cellsDictionaries = dictionary[@"cells"];
        NSMutableArray * cellsItems = [NSMutableArray array];
        for(NSDictionary * cellsDictionary in cellsDictionaries){
            CCICell * cellsItem = [[CCICell alloc] initWithDictionary:cellsDictionary];
            [cellsItems addObject:cellsItem];
        }
        self.cells = cellsItems;
    }
    if(dictionary[@"location"] != nil && ![dictionary[@"location"] isKindOfClass:[NSNull class]]){
        self.location = [[CCILocation alloc] initWithDictionary:dictionary[@"location"]];
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
    if(self.cells != nil){
        NSMutableArray * dictionaryElements = [NSMutableArray array];
        for(CCICell * cellsElement in self.cells){
            [dictionaryElements addObject:[cellsElement toDictionary]];
        }
        dictionary[@"cells"] = dictionaryElements;
    }
    if(self.location != nil){
        dictionary[@"location"] = [self.location toDictionary];
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
    if(self.cells != nil){
        [aCoder encodeObject:self.cells forKey:@"cells"];
    }
    if(self.location != nil){
        [aCoder encodeObject:self.location forKey:@"location"];
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
    self.cells = [aDecoder decodeObjectForKey:@"cells"];
    self.location = [aDecoder decodeObjectForKey:@"location"];
    self.type = [aDecoder decodeObjectForKey:@"type"];
    return self;
    
}
@end