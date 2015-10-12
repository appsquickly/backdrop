//
//  ThrowsChecker.m
//  source
//
//  Created by Jasper Blues on 8/30/15.
//  Copyright (c) 2015 AppsQuickly. All rights reserved.
//

#import "ThrowsChecker.h"



BOOL throws(VoidBlock block)
{
    @try {
        block();
    }
    @catch (NSException *e) {
        return YES;
    }
    return NO;
}
