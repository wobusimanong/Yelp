//
//  MapTableViewCell.h
//  YelpStudy
//
//  Created by zhuo ru li on 7/9/17.
//  Copyright © 2017 zhuo ru li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YelpDataModel.h"
@interface MapTableViewCell : UITableViewCell

- (void)updateBasedOnDataModel:(YelpDataModel *)dataModel;


@end
