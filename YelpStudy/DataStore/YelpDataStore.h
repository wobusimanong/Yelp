//
//  YelpDataStore.h
//  YelpStudy
//
//  Created by zhuo ru li on 7/6/17.
//  Copyright © 2017 zhuo ru li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YelpDataModel.h"
@import CoreLocation;

@interface YelpDataStore : NSObject
@property (nonatomic, copy) NSArray <YelpDataModel *> *dataModels;
@property (nonatomic) CLLocation *userLocation;

+ (YelpDataStore *)sharedInstance;


@end
