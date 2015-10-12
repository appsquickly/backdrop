//
//  ThrowsChecker.h
//  source
//
//  Created by Jasper Blues on 8/30/15.
//  Copyright (c) 2015 AppsQuickly. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^VoidBlock)(void);

BOOL throws(VoidBlock block); 