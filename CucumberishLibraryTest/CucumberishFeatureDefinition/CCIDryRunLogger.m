//
//  CCIDryRunLogger.m
//  CucumberishFeatureDefinition
//
//  Created by Titouan van Belle on 15.07.17.
//  Copyright © 2017 Ahmed Ali. All rights reserved.
//

#import "CCIDryRunLogger.h"

@implementation CCIDryRunLogger

+ (CCIDryRunLogger *)sharedInstance
{
    static CCIDryRunLogger *sharedInstance;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[CCIDryRunLogger alloc] init];
        sharedInstance.logs = @"";
    });

    return sharedInstance;
}

- (void)logFormat:(NSString *)format arguments:(va_list)arguments
{
    va_list args_copy;
    va_copy(args_copy, arguments);

    @synchronized(self) {
        NSString *logMessage = [[NSString alloc] initWithFormat:format arguments:arguments];
        self.logs = [NSString stringWithFormat:@"%@%@", self.logs, logMessage];
    }

    va_end(args_copy);
}

@end
