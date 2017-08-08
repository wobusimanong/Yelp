//
//  YelpDataStore.m
//  YelpStudy
//
//  Created by zhuo ru li on 7/6/17.
//  Copyright © 2017 zhuo ru li. All rights reserved.
//

#import "YelpDataStore.h"

@implementation YelpDataStore

+ (YelpDataStore *)sharedInstance {
    static YelpDataStore *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[YelpDataStore alloc] init];
    });
    return _sharedInstance;
}

@end
