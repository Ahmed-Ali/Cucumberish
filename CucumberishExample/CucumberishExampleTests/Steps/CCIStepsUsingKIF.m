//
//  CCIStepsUsingKIF.m
//  CucumberishExample
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


#import "KIFUITestActor+Utils.h"
#import "CCIStepsUsingKIF.h"
#import "Cucumberish.h"



@interface CCIStepsUsingKIF()<KIFTestActorDelegate>

@property (nonatomic, strong) NSDictionary * directions;

@end

@implementation CCIStepsUsingKIF
@synthesize actor;
+ (instancetype)instance {
    static CCIStepsUsingKIF * instance = nil;
    @synchronized(self) {
        if(instance == nil){
            instance = [[CCIStepsUsingKIF alloc] init];
        }
    }
   
    return instance;
}


- (instancetype)init
{
    self = [super init];
    
    self.directions = @{
                        @"up" : @(KIFSwipeDirectionUp),
                        @"down" : @(KIFSwipeDirectionDown),
                        @"left" : @(KIFSwipeDirectionLeft),
                        @"right" : @(KIFSwipeDirectionRight)
                        };
    
    
    return self;
}


+ (void)setup
{
    [[self instance] setup];
}



- (void)setup
{
    actor = tester;

    MatchAll(@"^I tap (?:the )?\"([^\\\"]*)\" (?:button|view)$" ,  ^void(NSArray *args, id userInfo) {
        [actor tapViewWithAccessibilityLabel:args[0]];
    });
    //And I tap "Increment" button 5 times
    MatchAll(@"^I tap (?:the )?\"([^\\\"]*)\" (?:button|view) ([1-9]{1}) time(?:s)?$" ,  ^void(NSArray *args, id userInfo) {
        NSUInteger times = [args[1] integerValue];
        NSUInteger n = 0;
        while (n < times) {
            [actor tapViewWithAccessibilityLabel:args[0]];
            ++n;
        }
    });
    //And I write "eng.ahmed.ali.awad@gmail.com" into the "Email" field
    MatchAll(@"^I write \"([^\\\"]*)\" (?:into|in) (?:the )?\"([^\\\"]*)\" field$" ,  ^void(NSArray *args, id userInfo) {
        [actor enterText:args[0] intoViewWithAccessibilityLabel:args[1]];
    });
    MatchAll(@"^I clear (?:the )?\"([^\\\"]*)\" field$" ,  ^void(NSArray *args, id userInfo) {
        [actor clearTextFromViewWithAccessibilityLabel:args[0]];
    });
    MatchAll(@"^I clear (?:the )?text and write \"([^\\\"]*)\" (?:into|in) (?:the )?\"([^\\\"]*)\" field$"  ,  ^void(NSArray *args, id userInfo) {
        
        step(userInfo[kXCTestCaseKey], @"I clear the \"%@\" field", args[1]);
        step(userInfo[kXCTestCaseKey], @"I write \"%@\" into the \"%@\" field", args[0], args[1]);
    });
    MatchAll(@"^I write \"([^\\\"]*)\" (?:into|in) (?:the )?active text field$" ,  ^void(NSArray *args, id userInfo) {
        [actor enterTextIntoCurrentFirstResponder:args[0]];
        
    });
    MatchAll(@"^I cleare (?:the )?text and write \"([^\\\"]*)\" (?:into|in) (?:the )?active text field$" ,  ^void(NSArray *args, id userInfo) {
        [actor clearTextFromAndThenEnterTextIntoCurrentFirstResponder:args[0]];
        
    });
    
    MatchAll(@"^I wait for (\\d*) seconds$" ,  ^void(NSArray *args, id userInfo) {
        [actor waitForTimeInterval:[args[0] doubleValue]];
        
    });
    MatchAll(@"^I should see \"(.*)\" in (?:the )?\"(.*)\" (?:view|field|label|button)$" ,  ^void(NSArray *args, id userInfo) {
        UILabel * label = (UILabel *)[actor waitForViewWithAccessibilityLabel:args[1]];
        CCIAssert(label != nil,@"Could not find any element with label :%@", args[1]);
        NSTimeInterval timeout = [KIFTestActor defaultTimeout];
        NSDate * startTime = [NSDate date];
        NSString * foundValue;
        while (![self compareValue:args[0] withValueOfTextualView:label foundValue:&foundValue] && [startTime timeIntervalSinceNow] > -timeout) {
            [actor waitForTimeInterval:0.5];
        }
        CCIAssert([foundValue isEqualToString:args[0]], @"Found an accessibility element with the label \"%@\", but with the text value \"%@\" instead of \"%@\"", args[0], foundValue, args[1]);
        
        
    });

    MatchAll(@"^I set the \"(.*)\" picker date to \"(.*)\"$", ^void(NSArray *args, id userInfo) {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"dd-MM-yyyy"];
        NSDate * date = [df dateFromString: args[1]];
        CCIAssert(date != nil, @"The date %@ should be in the format dd-MM-yyy", args[1]);
        [actor setPickerDate:date forPickerWithAccessibilityLabel:args[0]];
    });
    
    MatchAll(@"^I swipe to (left|right|up|down) in the \"(.*)\" view$" ,  ^void(NSArray *args, id userInfo) {
        KIFSwipeDirection direction = [self.directions[args[0]] integerValue];
        [actor swipeViewWithAccessibilityLabel:args[1] inDirection:direction];
        
    });
    
    MatchAll(@"^I touch the screen at ((\\d*),(\\d*)) coordinates" ,  ^void(NSArray *args, id userInfo) {
        CGFloat x = [args[0] floatValue];
        CGFloat y = [args[1] floatValue];
        [actor tapScreenAtPoint:CGPointMake(x, y)];
        
        
    });
    
    MatchAll(@"^I tap (?:the )?cell (\\d*) in section (\\d*) in the \"([^\\\"]*)\" table$" ,  ^void(NSArray *args, id userInfo) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:[args[0] intValue] inSection:[args[1] intValue]];
        [actor tapRowAtIndexPath:indexPath inTableViewWithAccessibilityIdentifier:args[2]];
        
 
    });
    MatchAll(@"^I tap (?:the )?item (\\d*) in section (\\d*) in the \"([^\\\"]*)\" collection$" ,  ^void(NSArray *args, id userInfo) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:[args[0] intValue] inSection:[args[1] intValue]];
        [actor tapItemAtIndexPath:indexPath inCollectionViewWithAccessibilityIdentifier:args[2]];
        
 
    });
    
    MatchAll(@"^I switch (on|off) the \"([^\\\"]*)\" switch$" ,  ^void(NSArray *args, id userInfo) {
        NSString * state = args[0];
        
        BOOL on = [state isEqualToString:@"on"] ? YES : NO;
        [actor setOn:on forSwitchWithAccessibilityLabel:args[1]];
        
    });
    
    MatchAll(@"^I should see (?:the )?\"([^\\\"]*)\" (?:view|field|label|button)$" ,  ^void(NSArray *args, id userInfo) {
        [actor waitForViewWithAccessibilityLabel:args[0] traits:UIAccessibilityTraitNone];
        
    });
    MatchAll(@"^I should not see (?:the )?\"([^\\\"]*)\" (?:view|field|label|button)$" ,  ^void(NSArray *args, id userInfo) {
        [actor waitForAbsenceOfViewWithAccessibilityLabel:args[0]];
        

    });
    
    MatchAll(@"^I press (?:the )?\"([^\\\"]*)\" (?:view|field|label|button) for (\\d*) seconds$" ,  ^void(NSArray *args, id userInfo) {
        [actor longPressViewWithAccessibilityLabel:args[0] duration:[args[1] doubleValue]];
        

    });
    
    MatchAll(@"^I press (?:the )?\"([^\\\"]*)\" (?:view|field|label|button) for (\\d*) seconds$" ,  ^void(NSArray *args, id userInfo) {
        [actor longPressViewWithAccessibilityLabel:args[0] duration:[args[1] doubleValue]];
        
        
    });
    MatchAll(@"I wait for keybaord to be dismissed" ,  ^void(NSArray *args, id userInfo) {
        [actor waitForAbsenceOfSoftwareKeyboard];
        
    });
    MatchAll(@"I wait for keybaord to be appear" ,  ^void(NSArray *args, id userInfo) {
        [actor waitForKeyInputReady];
        
    });
    
    MatchAll(@"I should see \"(.*)\" at row (\\d*) section (\\d*) in \"([^\\\"]*)\" table", ^void(NSArray *args, id userInfo) {
        UITableView * tableView = (UITableView *)[actor waitForViewWithAccessibilityLabel:args[3]];
        
        CCIAssert(tableView != nil, @"Could not find any element with label :%@", args[3]);
        CCIAssert([tableView isKindOfClass:[UITableView class]], @"Found view with label %@, but it is not a table", args[3]);
        NSUInteger section = [args[2] integerValue];
        NSUInteger row = [args[1] integerValue];
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        CCIAssert(cell != nil, @"Could not find any element at row %@ section %@ in table %@", args[1], args[2], args[3]);
        NSString * content = [cell.textLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString * value = [args[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];//[NSString stringWithCString:[args[0] UTF8String] encoding:NSUTF8StringEncoding];
        CCIAssert([content isEqualToString:value], @"The expected value is: %@ but found: %@", args[0], cell.textLabel.text);
        
    });
    
    MatchAll(@"I should see (\\d*) row(?:s)? at section (\\d*) in \"([^\\\"]*)\" table", ^void(NSArray *args, id userInfo) {
        UITableView * tableView = (UITableView *)[actor waitForViewWithAccessibilityLabel:args[2]];
        CCIAssert(tableView != nil, @"Could not find any element with label :%@", args[2]);
        CCIAssert([tableView isKindOfClass:[UITableView class]], @"Found view with label %@, but it is not a table", args[2]);
        NSUInteger section = [args[1] integerValue];
        NSUInteger expectedNumberOfRows = [args[0] integerValue];
        NSUInteger actualNumberOfRows = [tableView numberOfRowsInSection:section];
        CCIAssert(actualNumberOfRows == expectedNumberOfRows, @"The number of rows found at section %@ is: %i, while the expected number of rows is: %i", args[1], (int)actualNumberOfRows, (int)expectedNumberOfRows);
        
    });
    
    MatchAll(@"^I swipe (right|left) (?:the )?row (\\d*) in section (\\d*) in (?:the )?\"([^\\\"]*)\" table$" ,  ^void(NSArray *args, id userInfo) {
        UITableView * tableView = (UITableView *)[actor waitForViewWithAccessibilityLabel:args[3]];
        CCIAssert(tableView != nil, @"Could not find any element with label :%@", args[3]);
        CCIAssert([tableView isKindOfClass:[UITableView class]], @"Found view with label %@, but it is not a table", args[3]);
        NSUInteger section = [args[2] integerValue];
        NSUInteger row = [args[1] integerValue];
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        KIFSwipeDirection direction = [self.directions[args[0]] integerValue];
        [actor swipeRowAtIndexPath:indexPath inTableView:tableView inDirection:direction];
        
    });
    
    MatchAll(@"I wait for animation to finish" ,  ^void(NSArray *args, id userInfo) {
        [actor waitForAnimationsToFinishWithTimeout:[args[0] doubleValue]];
        
    });
    
    MatchAll(@"^I wait for animation to finish up to (\\d*) seconds$" ,  ^void(NSArray *args, id userInfo) {
        [actor waitForAnimationsToFinish];
        
    });
    MatchAll(@"^I scroll (up|down|left|right) the \"([^\\\"]*)\" view$" ,  ^void(NSArray *args, id userInfo) {
        KIFSwipeDirection direction = [self.directions[args[0]] integerValue];
        [actor swipeViewWithAccessibilityLabel:args[1] inDirection:direction];
        
    });
    
}



#pragma mark - Privae
- (BOOL)compareValue:(NSString *)value withValueOfTextualView:(UILabel *)label foundValue:(NSString **)foundValue
{
    if([label respondsToSelector:@selector(text)] && label.text.length > 0){
        *foundValue = label.text;
    }else if([label respondsToSelector:@selector(attributedText)] && label.attributedText.length > 0){
        *foundValue = [label.attributedText string];
    }else if([label respondsToSelector:@selector(titleLabel)] && ((UIButton *)label).titleLabel.text.length > 0){
        *foundValue = ((UIButton *)label).titleLabel.text;
    }else if([label respondsToSelector:@selector(titleLabel)] && ((UIButton *)label).titleLabel.attributedText.length > 0){
        *foundValue = ((UIButton *)label).titleLabel.attributedText.string;
    }
    return [value isEqualToString:*foundValue];
}

#pragma mark - KIFTestActorDelegate

- (void)failWithException:(NSException *)exception stopTest:(BOOL)stop
{
    throwCucumberishException(exception.reason);
    
}
- (void)failWithExceptions:(NSArray *)exceptions stopTest:(BOOL)stop
{
    [exceptions makeObjectsPerformSelector:@selector(raise)];
}
@end


