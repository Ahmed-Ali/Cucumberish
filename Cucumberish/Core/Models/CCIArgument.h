//
//	CCIArgument.h
//
//	Create by Ahmed Ali on 2/1/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <Foundation/Foundation.h>
#import "CCILocation.h"
#import "CCIRow.h"

@interface CCIArgument : NSObject

@property (nonatomic, strong) CCILocation * location;
@property (nonatomic, strong) NSArray * rows;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * content;
-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end