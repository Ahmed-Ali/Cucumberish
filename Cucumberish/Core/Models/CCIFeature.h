//
//	CCIFeature.h
//
//	Create by Ahmed Ali on 2/1/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <Foundation/Foundation.h>
#import "CCIBackground.h"
#import "CCIComment.h"
#import "CCILocation.h"
#import "CCIScenarioDefinition.h"
#import "CCITag.h"

@interface CCIFeature : NSObject

@property (nonatomic, strong) CCIBackground * background;
@property (nonatomic, strong) NSArray * comments;
@property (nonatomic, copy) NSString * descriptionField;
@property (nonatomic, copy) NSString * keyword;
@property (nonatomic, copy) NSString * language;
@property (nonatomic, strong) CCILocation * location;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, strong) NSArray<CCIScenarioDefinition *> * scenarioDefinitions;
@property (nonatomic, strong) NSArray * tags;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * filePath;
-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end