//
//	Activity.h
//
//	Create by Ahmed Ali on 19/1/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface Activity : NSObject

@property (nonatomic, assign) BOOL current;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, assign) NSInteger rank;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end