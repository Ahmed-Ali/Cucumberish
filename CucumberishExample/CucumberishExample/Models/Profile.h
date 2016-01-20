//
//	Profile.h
//
//	Create by Ahmed Ali on 19/1/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface Profile : NSObject

@property (nonatomic, strong) NSDate * birthdate;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSString * name;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end