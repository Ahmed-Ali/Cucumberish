//
//  CCIStepsUsingKIF.h
//  CucumberishExample
//
//  Created by Ahmed Ali on 03/01/16.
//  Copyright © 2016 Ahmed Ali. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KIF/KIF.h>

@class CCIStep;

@interface CCIStepsUsingKIF : NSObject

@property (nonatomic, strong) KIFUITestActor * actor;

+ (instancetype)instance;
+ (void)setup;



@end
