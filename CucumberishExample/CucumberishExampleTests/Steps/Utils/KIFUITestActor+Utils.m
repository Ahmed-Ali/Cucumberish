//
//  KIFUITestActor+Utils.m
//  CucumberishExampleTests
//
//  Created by Ahmed Ali on 29/12/15.
//

#import "KIFUITestActor+Utils.h"
#import "UIApplication-KIFAdditions.h"
#import "UIAccessibilityElement-KIFAdditions.h"
#import "NSError-KIFAdditions.h"
@implementation KIFUITestActor (Utils)


- (void)setPickerDate:(NSDate *)date forPickerWithAccessibilityLabel:(NSString *)label {
    [tester runBlock:^KIFTestStepResult(NSError **error) {
        UIAccessibilityElement *element;
        
        [self waitForAccessibilityElement:&element view:nil withLabel:label value:nil traits:UIAccessibilityTraitNone tappable:NO];
        KIFTestCondition(element, error, @"Date picker with label %@ not found", label);
        KIFTestCondition([element isKindOfClass:[UIDatePicker class]], error, @"Specified view is not a picker");
        UIDatePicker *picker = (UIDatePicker *)element;
        [picker setDate:date animated:YES];
        
        [self waitForTimeInterval:1.f];
        return KIFTestStepResultSuccess;
    }];
}


- (BOOL)isViewExistForAccessibilityLabel:(NSString *)label {
    return [self isViewExistForAccessibilityLabel:label tappable:NO];
}

- (BOOL)isViewExistForAccessibilityLabel:(NSString *)label tappable:(BOOL)tappable
{
    return [self isViewExistForAccessibilityLabel:label tappable:tappable traits:UIAccessibilityTraitNone];
}

- (BOOL)isViewExistForAccessibilityLabel:(NSString *)label tappable:(BOOL)tappable traits:(UIAccessibilityTraits)traits
{
    UIView *view = nil;
    UIAccessibilityElement *element = nil;
    
    BOOL success = [self existsAccessibilityElement:&element view:&view withLabel:label value:nil traits:traits tappable:tappable];
    if(success){
        success = !view.hidden;
        
    }
    if(success && tappable){
        success = view.userInteractionEnabled;
    }
    return success;
}



- (BOOL)existsAccessibilityElement:(UIAccessibilityElement **)element view:(out UIView **)view withLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits tappable:(BOOL)mustBeTappable
{
    KIFTestStepResult (^executionBlock)(NSError **) = ^(NSError **error) {
        return [UIAccessibilityElement accessibilityElement:element view:view withLabel:label value:value traits:traits tappable:mustBeTappable error:error] ? KIFTestStepResultSuccess : KIFTestStepResultWait;
    };
    
    NSDate *startDate = [NSDate date];
    KIFTestStepResult result;
    NSError *error = nil;
    NSTimeInterval timeout = 1.0;
    
    while ((result = executionBlock(&error)) == KIFTestStepResultWait && -[startDate timeIntervalSinceNow] < timeout) {
        CFRunLoopRunInMode([[UIApplication sharedApplication] currentRunLoopMode] ?: kCFRunLoopDefaultMode, 0.1, false);
    }
    
    if (result == KIFTestStepResultWait) {
        error = [NSError KIFErrorWithUnderlyingError:error format:@"The step timed out after %.2f seconds: %@", timeout, error.localizedDescription];
        result = KIFTestStepResultFailure;
    }
    
    return (result == KIFTestStepResultSuccess) ? YES : NO;
}



- (UIView *)viewWithAccessibilityLabel:(NSString *)label
{
    UIView *view = [tester waitForViewWithAccessibilityLabel:label];
    return view;
}

- (void)tapMiddlePoinInViewWithAccessibilityLabel:(NSString *)label {
    UIView *view = [tester waitForViewWithAccessibilityLabel:label];
    CGPoint middlePointOnScreen = [view convertPoint:CGPointMake(view.bounds.size.width / 2.0, view.bounds.size.height / 2.0) toView:nil];
    [tester tapScreenAtPoint:middlePointOnScreen];
    
}
@end
