//
//  ProfileDAO.m
//  CucumberishExample
//
//  Created by Ahmed Ali on 19/01/16.
//  Copyright © 2016 Ahmed Ali. All rights reserved.
//

#import "ProfileDAO.h"

@implementation ProfileDAO

+ (instancetype)instance
{
    static ProfileDAO * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [ProfileDAO new];
    });
    
    
    return instance;
}

- (Profile *)profile
{
    if(_profile == nil){
        NSData * profileData = [[NSUserDefaults standardUserDefaults] objectForKey:@"ProfileData"];
        if(profileData == nil){
            _profile = [Profile new];
        }else{
            _profile = [NSKeyedUnarchiver unarchiveObjectWithData:profileData];
        }
    }
    
    
    return _profile;
}

- (void)saveProfile
{
    NSData * profileData = [NSKeyedArchiver archivedDataWithRootObject:self.profile];
    [[NSUserDefaults standardUserDefaults] setObject:profileData forKey:@"ProfileData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)deleteProfile
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ProfileData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _profile = [Profile new];
}
@end
