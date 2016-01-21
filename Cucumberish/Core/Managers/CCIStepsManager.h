//
//  CCIStepsManager.h

//
//  Created by Ahmed Ali on 03/01/16.
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
#import "CCIStepDefinition.h"

@class CCIStep;
@class CCIStepDefinition;


OBJC_EXTERN void Given(NSString * definitionString, CCIStepBody body);
OBJC_EXTERN void When(NSString * definitionString, CCIStepBody body);
OBJC_EXTERN void Then(NSString * definitionString, CCIStepBody body);
OBJC_EXTERN void And(NSString * definitionString, CCIStepBody body);
OBJC_EXTERN void But(NSString * definitionString, CCIStepBody body);
OBJC_EXTERN void MatchAll(NSString * definitionString, CCIStepBody body);

OBJC_EXPORT void step(NSString * stepLine);
OBJC_EXPORT void steps(NSArray * steps);
@interface CCIStepsManager : NSObject


+ (instancetype)instance;

- (void)executeStep:(CCIStep *)step;
@end
