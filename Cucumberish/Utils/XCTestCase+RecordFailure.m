//
//  XCTest+RecordFailure.m
//  Cucumberish
//
//  Created by Derk Gommers on 02/03/2018.
//  Copyright © 2018 Ahmed Ali. All rights reserved.
//

#import "XCTestCase+RecordFailure.h"
#import "Cucumberish.h"

@implementation XCTestCase (RecordFailure)

-(void)recordFailureWithDescription:(NSString *)description atLocation:(CCILocation *)location expected:(BOOL)expected
{
    NSString * targetName = [[Cucumberish instance] testTargetFolderName] ? : [[[Cucumberish instance] containerBundle] infoDictionary][@"CFBundleName"];

    NSString * filePath = [NSString stringWithFormat:@"%@/%@%@",
                           [Cucumberish instance].testTargetSrcRoot,
                           targetName,
                           location.filePath];

    XCTSourceCodeLocation *sourceLocation = [[XCTSourceCodeLocation alloc] initWithFilePath:filePath lineNumber:location.line];
    XCTSourceCodeContext *context = [[XCTSourceCodeContext alloc] initWithLocation:sourceLocation];
    XCTIssue *issue = [[XCTIssue alloc] initWithType:XCTIssueTypeAssertionFailure compactDescription:description detailedDescription:description sourceCodeContext:context associatedError:nil attachments:@[] ];
    [self recordIssue:issue];
}

@end
