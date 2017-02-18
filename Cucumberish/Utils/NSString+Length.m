//
//  NSString+Length.m
//  CucumberishLibrary
//
//  Created by Mateusz Szlosek on 17.02.2017.
//  Copyright © 2017 Ahmed Ali. All rights reserved.
//

#import "NSString+Length.h"

@implementation NSString(Length)

-(NSInteger)properLength {
    __block NSInteger count = 0;
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length)
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString * _Nullable substring,
                                       NSRange substringRange,
                                       NSRange enclosingRange,
                                       BOOL * _Nonnull stop) {
                              count += substringRange.length;
                          }];
    return count;
}

@end
