//
//	CCIRow.h
//
//	Create by Ahmed Ali on 2/1/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <Foundation/Foundation.h>
#import "CCICell.h"
#import "CCILocation.h"

@interface CCIRow : NSObject

@property (nonatomic, strong) NSArray * cells;
@property (nonatomic, strong) CCILocation * location;
@property (nonatomic, copy) NSString * type;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end