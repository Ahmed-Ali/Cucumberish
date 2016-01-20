//
//  NSString+Formatter.m
//  TestedAppNoUITest
//
//  Created by Ahmed Ali on 11/01/16.
//  Copyright © 2016 Ahmed Ali. All rights reserved.
//

#import "NSString+Formatter.h"

@implementation NSString (Formatter)
- (NSString *)camleCaseStringWithFirstUppercaseCharacter:(BOOL)firstUppercaseCharacter
{
    static NSString * sep = @"AASSAAAKKKAALLLAL";
    NSString * str = [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] stringByReplacingOccurrencesOfString:@" " withString:sep];
    str = [str stringByReplacingCharactersInSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet] withString:@""];
    str = [str stringByReplacingOccurrencesOfString:sep withString:@"_"];
    NSMutableString * output = [NSMutableString string];
    BOOL makeNextCharacterInUpperCase = firstUppercaseCharacter;
    for (int i = 0; i < str.length; i++) {
        
        NSString * substr = [str substringWithRange:NSMakeRange(i, 1)];
        if(i == 0 && !makeNextCharacterInUpperCase){
            substr = [substr lowercaseString];
        }
        if([substr isEqualToString:@"_"]){
            makeNextCharacterInUpperCase = YES;
            continue;
        }else if(makeNextCharacterInUpperCase){
            substr = [substr uppercaseString];
            
        }
        [output appendString:substr];
        makeNextCharacterInUpperCase = NO;
    }
    
    return output;
}

- (NSString *)stringByReplacingCharactersInSet:(NSCharacterSet *)charSet withString:(NSString *)aString {
    NSMutableString *s = [NSMutableString stringWithCapacity:self.length];
    for (NSUInteger i = 0; i < self.length; ++i) {
        unichar c = [self characterAtIndex:i];
        if (![charSet characterIsMember:c]) {
            [s appendFormat:@"%C", c];
        } else {
            [s appendString:aString];
        }
    }
    return s;
}

@end
