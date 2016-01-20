//
//	CCIBackground.h
//
//	Create by Ahmed Ali on 2/1/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <Foundation/Foundation.h>
#import "CCILocation.h"
#import "CCIStep.h"

@interface CCIBackground : NSObject

@property (nonatomic, copy) NSString * keyword;
@property (nonatomic, strong) CCILocation * location;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, strong) NSArray * steps;
@property (nonatomic, copy) NSString * type;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end