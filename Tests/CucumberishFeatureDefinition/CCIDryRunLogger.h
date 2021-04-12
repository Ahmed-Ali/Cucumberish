//
//  CCIDryRunLogger.h
//  CucumberishFeatureDefinition
//
//  Created by Titouan van Belle on 15.07.17.
//  Copyright © 2017 Ahmed Ali. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCILoggingManager.h"

@interface CCIDryRunLogger : NSObject<CCILogger>

+ (CCIDryRunLogger *)sharedInstance;

@property (nonatomic, copy) NSString *logs;

@end
