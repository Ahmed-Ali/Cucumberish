//
//  CCIStepsManager.m

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

#import "CCIStepsManager.h"

#import "CCIStep.h"
#import "Cucumberish.h"

static CCIStepsManager * instance = nil;


@interface CCIStepsManager()
@property NSMutableDictionary * definitions;
@end

@implementation CCIStepsManager



+ (instancetype)instance {
    
    @synchronized(self) {
        if(instance == nil){
            instance = [[CCIStepsManager alloc] init];
        }
    }
    return instance;
}

- (instancetype)init
{
    self = [super init];
   
    self.definitions = [NSMutableDictionary dictionary];
    
    return self;
}


- (NSMutableArray *)definitionsCluster:(NSString *)type
{
    NSMutableArray * cluster = self.definitions[type];
    if(cluster == nil){
        cluster = [NSMutableArray array];
        self.definitions[type] = cluster;
    }
    
    return cluster;
}


- (CCIStepDefinition *)findMatchDefinitionForStep:(CCIStep *)step
{
    if(step.keyword == nil){
        //We should try to match it using all available definitions
        NSMutableArray * allDefinitions = [NSMutableArray array];
        for(NSArray * definitions in self.definitions.allValues){
            [allDefinitions addObjectsFromArray:definitions];
        }
        return [self definitionForStep:step definitions:allDefinitions];
    }
    NSArray * definitionGroup = self.definitions[step.keyword];
    return [self definitionForStep:step definitions:definitionGroup];

}

- (CCIStepDefinition *)definitionForStep:(CCIStep *)step definitions:(NSArray *)definitions
{
    NSError * error;
    
    for(CCIStepDefinition * d in definitions){
        NSString * pattern = d.regexString;
        
        if ([d.regexString isEqualToString:step.text]) {
            //It has no params, it is just plain perfect match
            return [d copy];
        }
        NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionAnchorsMatchLines error:&error];
        if(error && d == definitions.lastObject){
            //Only return nil if we reached the last definition without finding a match
            return nil;
        }
        NSRange searchRange = NSMakeRange(0, [step.text lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
        NSTextCheckingResult * match = [[regex matchesInString:step.text options:NSMatchingReportCompletion range:searchRange] firstObject];
        
        if (match != nil) {
            //Looks like a perfect match!
            CCIStepDefinition * definition = [d copy];
            NSMutableArray * values = [NSMutableArray arrayWithCapacity:match.numberOfRanges - 1];
            for(int i = 1; i < match.numberOfRanges; i++){
                NSRange range = [match rangeAtIndex:i];
                NSString * value = [step.text substringWithRange:range];
                [values addObject:value];
            }
            if([step.argument.type isEqualToString:@"DataTable"]){
                NSMutableArray * rows = [NSMutableArray array];
                for(CCIRow * row in step.argument.rows){
                    NSMutableArray * cells = [NSMutableArray array];
                    for(CCICell * cell in row.cells){
                        if(cell.value.length > 0){
                            [cells addObject:cell.value];
                        }
                    }
                    [rows addObject:cells];
                }
                [values addObject:rows];
            }else if([step.argument.type isEqualToString:@"DocString"]){
                NSString * content = step.argument.content;
                if(content == nil){
                    content = @"";
                }
                [values addObject:content];
            }
            definition.matchedValues = values;
            return definition;
        }
    }
    
    
    return nil;
}

- (void)executeStep:(CCIStep *)step
{
    CCIStepDefinition * implementation = [self findMatchDefinitionForStep:step];
    CCIAssert(implementation != nil, @"The step \"%@ %@\" is not implemented", step.keyword, [step.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]);
    implementation.body(implementation.matchedValues, nil);
}



@end


void addDefinition(NSString * definitionString, CCIStepBody body, NSString * type);

#pragma mark - C Routines

void Given(NSString * definitionString, CCIStepBody body)
{
    addDefinition(definitionString, body, @"Given");
}
void When(NSString * definitionString, CCIStepBody body)
{
    addDefinition(definitionString, body, @"When");
}
void Then(NSString * definitionString, CCIStepBody body)
{
    addDefinition(definitionString, body, @"Then");
}
void And(NSString * definitionString, CCIStepBody body)
{
    addDefinition(definitionString, body, @"And");
}
void But(NSString * definitionString, CCIStepBody body)
{
    addDefinition(definitionString, body, @"But");
}

void MatchAll(NSString * definitionString, CCIStepBody body)
{
    When(definitionString, body);
    Then(definitionString, body);
    And(definitionString, body);
    But(definitionString, body);
}


void addDefinition(NSString * definitionString, CCIStepBody body, NSString * type)
{
    CCIStepDefinition * definition = [CCIStepDefinition definitionWithType:type regexString:definitionString implementationBody:body];
    NSMutableArray * cluster = [[CCIStepsManager instance] definitionsCluster:type];
    [cluster insertObject:definition atIndex:0];
}

void step(NSString * stepLine)
{
    steps(@[stepLine]);
}
void steps(NSArray * steps)
{
    for (NSString *stepLine in steps) {
        CCIStep * step = [CCIStep new];
        step.text = stepLine;
        [[CCIStepsManager instance] executeStep:step];
    }
   
}







