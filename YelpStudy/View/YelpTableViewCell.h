//
//  YelpTableViewCell.h
//  YelpStudy
//
//  Created by zhuo ru li on 7/6/17.
//  Copyright © 2017 zhuo ru li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YelpDataModel.h"
@interface YelpTableViewCell : UITableViewCell

- (void)updateBasedOnDataModel:(YelpDataModel *)dataModel;

@end
