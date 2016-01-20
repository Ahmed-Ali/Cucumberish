//
//	CCIStep.h
//
//	Create by Ahmed Ali on 2/1/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <Foundation/Foundation.h>
#import "CCILocation.h"
#import "CCIArgument.h"
extern const NSString * kCCIStepTypeStep;
extern const NSString * kCCIStepTypeFunction;

@interface CCIStep : NSObject<NSCopying>
@property (nonatomic, strong) CCIArgument * argument;
@property (nonatomic, copy) NSString * keyword;
@property (nonatomic, strong) CCILocation * location;
@property (nonatomic, copy) NSString * text;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * filePath;
-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end