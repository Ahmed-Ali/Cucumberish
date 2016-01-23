//
//  CCIStepDefinition.h

//
//  Created by Ahmed Ali on 02/01/16.
//  Copyright © 2016 Ahmed Ali. All rights reserved.
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>

@class CCIStep;
/**
 You pass this block when ever you define an implementation for a step.
 
 @param args strings array which corresponds to your regular express capturing groups.
 @param userInfo is a dictionary that currently can only have one of two keys "DataTable" and "DocString". If your step definition is expected to match a data table or a doc string, then you can expect this user info to contain DataTable or DocString key respectively.
 */
typedef void(^CCIStepBody)(NSArray <NSString *>* args, NSDictionary * userInfo);

@interface CCIStepDefinition : NSObject<NSCopying>

@property NSString * regexString;
@property NSString * type;
@property NSArray * matchedValues;
@property NSDictionary * additionalContent;
@property (nonatomic, copy) CCIStepBody body;

+ (instancetype)definitionWithType:(NSString *)type regexString:(NSString *)regexString implementationBody:(CCIStepBody)body;
@end
