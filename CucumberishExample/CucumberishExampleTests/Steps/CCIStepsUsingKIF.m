//
//  CCIStepsUsingKIF.m
//  CucumberishExample
//
//  Created by Ahmed Ali on 03/01/16.
//  Copyright © 2016 Ahmed Ali. All rights reserved.
//


#import "KIFUITestActor+Utils.h"
#import "CCIStepsUsingKIF.h"
#import "CCIStep.h"
#import "CCIExecutionResult.h"
#import "CCIStepDefinition.h"
#import "CCIStepsManager.h"



CCIStepsUsingKIF * instance = nil;
@interface CCIStepsUsingKIF()<KIFTestActorDelegate>

@property (nonatomic, copy) NSString * failureReason;
@property (nonatomic, strong) NSDictionary * directions;

@end

@implementation CCIStepsUsingKIF
@synthesize actor;
+ (instancetype)instance {
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


-(CCIExecutionResult *)result
{
    if(self.failureReason.length > 0){
        NSString * reason = self.failureReason;
        self.failureReason = nil;
        return [CCIExecutionResult status:CCIExecutionStatusFail reason:reason];
    }
    
   return [CCIExecutionResult status:CCIExecutionStatusPass reason:nil];
}


- (void)setup
{
    actor = tester;

    MatchAll(@"^I tap (?:the )?\"([^\\\"]*)\" (?:button|view)$" ,  ^CCIExecutionResult *(NSArray *args, id userInfo) {
        [actor tapViewWithAccessibilityLabel:args[0]];
        return [self result];
    });
    //And I tap "Increment" button 5 times
    MatchAll(@"^I tap (?:the )?\"([^\\\"]*)\" (?:button|view) ([1-9]{1}) time(?:s)?$" ,  ^CCIExecutionResult *(NSArray *args, id userInfo) {
        NSUInteger times = [args[1] integerValue];
        NSUInteger n = 0;
        while (self.failureReason.length == 0 && n < times) {
            [actor tapViewWithAccessibilityLabel:args[0]];
            ++n;
        }
        return [self result];
    });
    //And I write "eng.ahmed.ali.awad@gmail.com" into the "Email" field
    MatchAll(@"^I write \"([^\\\"]*)\" (?:into|in) (?:the )?\"([^\\\"]*)\" field$" ,  ^CCIExecutionResult *(NSArray *args, id userInfo) {
        [actor enterText:args[0] intoViewWithAccessibilityLabel:args[1]];
        return [self result];
    });
    MatchAll(@"^I clear (?:the )?\"([^\\\"]*)\" field$" ,  ^CCIExecutionResult *(NSArray *args, id userInfo) {
        [actor clearTextFromViewWithAccessibilityLabel:args[0]];
        return [self result];
    });
    MatchAll(@"^I clear (?:the )?text and write \"([^\\\"]*)\" (?:into|in) (?:the )?\"([^\\\"]*)\" field$"  ,  ^CCIExecutionResult *(NSArray *args, id userInfo) {
        return steps(@[
                       [NSString stringWithFormat:@"I clear the \"%@\" field", args[1]],
                       [NSString stringWithFormat:@"I write \"%@\" into the \"%@\" field", args[0], args[1]],
                       
                       ]);
    });
    MatchAll(@"^I write \"([^\\\"]*)\" (?:into|in) (?:the )?active text field$" ,  ^CCIExecutionResult *(NSArray *args, id userInfo) {
        [actor enterTextIntoCurrentFirstResponder:args[0]];
        return [self result];
    });
    MatchAll(@"^I cleare (?:the )?text and write \"([^\\\"]*)\" (?:into|in) (?:the )?active text field$" ,  ^CCIExecutionResult *(NSArray *args, id userInfo) {
        [actor clearTextFromAndThenEnterTextIntoCurrentFirstResponder:args[0]];
        return [self result];
    });
    
    MatchAll(@"^I wait for (\\d*) seconds$" ,  ^CCIExecutionResult *(NSArray *args, id userInfo) {
        [actor waitForTimeInterval:[args[0] doubleValue]];
        return [self result];
    });
    MatchAll(@"^I should see \"(.*)\" in (?:the )?\"(.*)\" (?:view|field|label|button)$" ,  ^CCIExecutionResult *(NSArray *args, id userInfo) {
        UILabel * label = (UILabel *)[actor waitForViewWithAccessibilityLabel:args[1]];
        if(label != nil && self.failureReason.length == 0){
            NSTimeInterval timeout = [KIFTestActor defaultTimeout];
            NSDate * startTime = [NSDate date];
            NSString * foundValue;
            while (![self compareValue:args[0] withValueOfTextualView:label foundValue:&foundValue] && [startTime timeIntervalSinceNow] > -timeout) {
                [actor waitForTimeInterval:0.5];
            }
            if(![foundValue isEqualToString:args[0]]){
                self.failureReason = [NSString stringWithFormat:@" Found an accessibility element with the label \"%@\", but with the text value \"%@\" instead of \"%@\"", args[0], foundValue, args[1]];
            }
            
        }
        return [self result];
    });

    MatchAll(@"^I set the \"(.*)\" picker date to \"(.*)\"$", ^CCIExecutionResult *(NSArray *args, id userInfo) {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"dd-MM-yyyy"];
        NSDate * date = [df dateFromString: args[1]];
        if(date == nil){
            self.failureReason = [NSString stringWithFormat:@"The date %@ should be in the format dd-MM-yyy", args[1]];
        }else{
            [actor setPickerDate:date forPickerWithAccessibilityLabel:args[0]];
        }
        
        return [self result];
    });
    
    MatchAll(@"^I swipe to (left|right|up|down) in the \"(.*)\" view$" ,  ^CCIExecutionResult *(NSArray *args, id userInfo) {
        KIFSwipeDirection direction = [self.directions[args[0]] integerValue];
        [actor swipeViewWithAccessibilityLabel:args[1] inDirection:direction];
        return [self result];
    });
    
    MatchAll(@"^I touch the screen at ((\\d*),(\\d*)) coordinates" ,  ^CCIExecutionResult *(NSArray *args, id userInfo) {
        CGFloat x = [args[0] floatValue];
        CGFloat y = [args[1] floatValue];
        [actor tapScreenAtPoint:CGPointMake(x, y)];
        return [self result];
        return [self result];
    });
    
    MatchAll(@"^I tap (?:the )?cell (\\d*) in section (\\d*) in the \"([^\\\"]*)\" table$" ,  ^CCIExecutionResult *(NSArray *args, id userInfo) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:[args[0] intValue] inSection:[args[1] intValue]];
        [actor tapRowAtIndexPath:indexPath inTableViewWithAccessibilityIdentifier:args[2]];
        return [self result];
 
    });
    MatchAll(@"^I tap (?:the )?item (\\d*) in section (\\d*) in the \"([^\\\"]*)\" collection$" ,  ^CCIExecutionResult *(NSArray *args, id userInfo) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:[args[0] intValue] inSection:[args[1] intValue]];
        [actor tapItemAtIndexPath:indexPath inCollectionViewWithAccessibilityIdentifier:args[2]];
        return [self result];
 
    });
    
    MatchAll(@"^I switch (on|off) the \"([^\\\"]*)\" switch$" ,  ^CCIExecutionResult *(NSArray *args, id userInfo) {
        NSString * state = args[0];
        
        BOOL on = [state isEqualToString:@"on"] ? YES : NO;
        [actor setOn:on forSwitchWithAccessibilityLabel:args[1]];
        return [self result];
    });
    
    MatchAll(@"^I should see (?:the )?\"([^\\\"]*)\" (?:view|field|label|button)$" ,  ^CCIExecutionResult *(NSArray *args, id userInfo) {
        [actor waitForViewWithAccessibilityLabel:args[0] traits:UIAccessibilityTraitNone];
        return [self result];
    });
    MatchAll(@"^I should not see (?:the )?\"([^\\\"]*)\" (?:view|field|label|button)$" ,  ^CCIExecutionResult *(NSArray *args, id userInfo) {
        [actor waitForAbsenceOfViewWithAccessibilityLabel:args[0]];
        return [self result];

    });
    
    MatchAll(@"^I press (?:the )?\"([^\\\"]*)\" (?:view|field|label|button) for (\\d*) seconds$" ,  ^CCIExecutionResult *(NSArray *args, id userInfo) {
        [actor longPressViewWithAccessibilityLabel:args[0] duration:[args[1] doubleValue]];
        return [self result];

    });
    
    MatchAll(@"^I press (?:the )?\"([^\\\"]*)\" (?:view|field|label|button) for (\\d*) seconds$" ,  ^CCIExecutionResult *(NSArray *args, id userInfo) {
        [actor longPressViewWithAccessibilityLabel:args[0] duration:[args[1] doubleValue]];
        return [self result];
        
    });
    MatchAll(@"I wait for keybaord to be dismissed" ,  ^CCIExecutionResult *(NSArray *args, id userInfo) {
        [actor waitForAbsenceOfSoftwareKeyboard];
        return [self result];
    });
    MatchAll(@"I wait for keybaord to be appear" ,  ^CCIExecutionResult *(NSArray *args, id userInfo) {
        [actor waitForKeyInputReady];
        return [self result];
    });
    
    MatchAll(@"I should see \"(.*)\" at row (\\d*) section (\\d*) in \"([^\\\"]*)\" table", ^CCIExecutionResult *(NSArray *args, id userInfo) {
        UITableView * tableView = (UITableView *)[actor waitForViewWithAccessibilityLabel:args[3]];
        if(self.failureReason.length > 0){
            return [self result];
        }else if(![tableView isKindOfClass:[UITableView class]]){
            self.failureReason = [NSString stringWithFormat:@"Found view with label %@, but it is not a table", args[3]];
            return [self result];
        }
        NSUInteger section = [args[2] integerValue];
        NSUInteger row = [args[1] integerValue];
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        if(cell == nil){
            self.failureReason = [NSString stringWithFormat:@"Could not find any element at row %@ section %@ in table %@", args[1], args[2], args[3]];
        }else{
            NSString * content = [cell.textLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString * value = [args[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];//[NSString stringWithCString:[args[0] UTF8String] encoding:NSUTF8StringEncoding];
            
            if (![content isEqualToString:value]) {
                self.failureReason = [NSString stringWithFormat:@"The expected value is: %@ but found: %@", args[0], cell.textLabel.text];
            }
        }
        return [self result];
    });
    
    MatchAll(@"I should see (\\d*) row(?:s)? at section (\\d*) in \"([^\\\"]*)\" table", ^CCIExecutionResult *(NSArray *args, id userInfo) {
        UITableView * tableView = (UITableView *)[actor waitForViewWithAccessibilityLabel:args[2]];
        if(self.failureReason.length > 0){
            return [self result];
        }else if(![tableView isKindOfClass:[UITableView class]]){
            self.failureReason = [NSString stringWithFormat:@"Found element with label %@, but it is not a table", args[3]];
            return [self result];
        }
        NSUInteger section = [args[1] integerValue];
        NSUInteger expectedNumberOfRows = [args[0] integerValue];
        NSUInteger actualNumberOfRows = [tableView numberOfRowsInSection:section];
        if(actualNumberOfRows != expectedNumberOfRows){
            self.failureReason = [NSString stringWithFormat:@"The number of rows found at section %@ is: %i, while the expected number of rows is: %i", args[1], (int)actualNumberOfRows, (int)expectedNumberOfRows];
        }
        
        return [self result];
    });
    
    MatchAll(@"^I swipe (right|left) (?:the )?row (\\d*) in section (\\d*) in (?:the )?\"([^\\\"]*)\" table$" ,  ^CCIExecutionResult *(NSArray *args, id userInfo) {
        UITableView * tableView = (UITableView *)[actor waitForViewWithAccessibilityLabel:args[3]];
        if(self.failureReason.length > 0){
            return [self result];
        }else if(tableView == nil){
            self.failureReason = [NSString stringWithFormat:@"Could not find any element with the label %@", args[3]];
            return [self result];
        } else if(![tableView isKindOfClass:[UITableView class]]){
            self.failureReason = [NSString stringWithFormat:@"Found view with label %@, but it is not a table", args[3]];
            return [self result];
        }
        NSUInteger section = [args[2] integerValue];
        NSUInteger row = [args[1] integerValue];
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        KIFSwipeDirection direction = [self.directions[args[0]] integerValue];
        [actor swipeRowAtIndexPath:indexPath inTableView:tableView inDirection:direction];
        return [self result];
    });
    
    MatchAll(@"I wait for animation to finish" ,  ^CCIExecutionResult *(NSArray *args, id userInfo) {
        [actor waitForAnimationsToFinishWithTimeout:[args[0] doubleValue]];
        return [self result];
    });
    
    MatchAll(@"^I wait for animation to finish up to (\\d*) seconds$" ,  ^CCIExecutionResult *(NSArray *args, id userInfo) {
        [actor waitForAnimationsToFinish];
        return [self result];
    });
    MatchAll(@"^I scroll (up|down|left|right) the \"([^\\\"]*)\" view$" ,  ^CCIExecutionResult *(NSArray *args, id userInfo) {
        KIFSwipeDirection direction = [self.directions[args[0]] integerValue];
        [actor swipeViewWithAccessibilityLabel:args[1] inDirection:direction];
        return [self result];
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
    //Do not receive anymore delegate calls, till the next function call
    if(self.failureReason.length == 0){
        self.failureReason = exception.reason;
    }
    
}
- (void)failWithExceptions:(NSArray *)exceptions stopTest:(BOOL)stop
{
    
}
@end


