//
//  YelpNetworking.h
//  YelpStudy
//
//  Created by zhuo ru li on 6/30/17.
//  Copyright © 2017 zhuo ru li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YelpDataModel.h"

@import CoreLocation;

typedef void (^RestaurantCompletionBlock)(NSArray <YelpDataModel *>* dataModelArray);

@interface YelpNetworking : NSObject

+ (YelpNetworking *)sharedInstance;

- (void)fetchRestaurantsBasedOnLocation:(CLLocation *)location term:(NSString *)term completionBlock:(RestaurantCompletionBlock)completionBlock;

@end

