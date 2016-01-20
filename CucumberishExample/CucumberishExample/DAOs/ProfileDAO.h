//
//  ProfileDAO.h
//  CucumberishExample
//
//  Created by Ahmed Ali on 19/01/16.
//  Copyright © 2016 Ahmed Ali. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Profile.h"


@interface ProfileDAO : NSObject

@property (nonatomic, strong) Profile * profile;

+ (instancetype)instance;

- (void)saveProfile;

- (void)deleteProfile;
@end
