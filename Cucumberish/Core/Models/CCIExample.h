//
//	CCIExample.h
//
//	Create by Ahmed Ali on 17/1/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import "CCILocation.h"
#import "CCITableBody.h"
#import "CCITableBody.h"

@interface CCIExample : NSObject

@property (nonatomic, strong) NSString * keyword;
@property (nonatomic, strong) CCILocation * location;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSArray<CCITableBody *> * tableBody;
@property (nonatomic, strong) CCITableBody * tableHeader;
@property (nonatomic, strong) NSArray * tags;
@property (nonatomic, strong) NSString * type;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end