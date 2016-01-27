//
//  KIFUITestActor+Utils.h
//  CucumberishExampleTests
//
//  Created by Ahmed Ali on 29/12/15.
//

#import <KIF/KIF.h>

@interface KIFUITestActor (Utils)
- (BOOL)isViewExistForAccessibilityLabel:(NSString *)label;
- (BOOL)isViewExistForAccessibilityLabel:(NSString *)label tappable:(BOOL)tappable;
- (BOOL)isViewExistForAccessibilityLabel:(NSString *)label tappable:(BOOL)tappable traits:(UIAccessibilityTraits)traits;
- (UIView *)viewWithAccessibilityLabel:(NSString *)label;

- (void)setPickerDate:(NSDate *)date forPickerWithAccessibilityLabel:(NSString *)label;
- (void)tapMiddlePoinInViewWithAccessibilityLabel:(NSString *)label;
@end
