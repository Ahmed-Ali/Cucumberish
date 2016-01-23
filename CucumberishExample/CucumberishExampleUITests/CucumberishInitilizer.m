//
//  CucumberishInitilizer.m
//  CucumberishExample
//
//  Created by Ahmed Ali on 23/01/16.
//  Copyright © 2016 Ahmed Ali. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CucumberishExampleUITests-Swift.h"

__attribute__((constructor))
void CucumberishInit()
{
    [CucumberishInitializer CucumberishSwift];
  
}