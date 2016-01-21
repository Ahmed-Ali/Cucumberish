//
//	CCIScenarioDefinition.h
//
//	Create by Ahmed Ali on 17/1/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <Foundation/Foundation.h>
#import "CCIExample.h"
#import "CCILocation.h"
#import "CCIStep.h"

#import "CCITag.h"
@interface CCIScenarioDefinition : NSObject <NSCopying>
@property (nonatomic, strong) NSArray<CCIExample *> * examples;
@property (nonatomic, copy) NSString * keyword;
@property (nonatomic, strong) CCILocation * location;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, strong) NSArray <CCIStep *> * steps;
@property (nonatomic, strong) NSArray <CCITag *> * tags;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * filePath;
@property (nonatomic, strong) NSString * failureReason;
@property (nonatomic, assign) BOOL success;
-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end