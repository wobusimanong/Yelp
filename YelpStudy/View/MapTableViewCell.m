//
//  MapTableViewCell.m
//  YelpStudy
//
//  Created by zhuo ru li on 7/9/17.
//  Copyright © 2017 zhuo ru li. All rights reserved.
//

#import "MapTableViewCell.h"
#import <UIKit/UIKit.h>
@import MapKit;
#import "YelpAnnotation.h"

@interface MapTableViewCell()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapTableViewCell

- (void)updateBasedOnDataModel:(YelpDataModel *)dataModel
{
    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(dataModel.latitude, dataModel.longitude);
    NSString *subtitle = [NSString stringWithFormat:@"%@ - %@",dataModel.categories,dataModel.displayAddress];
    YelpAnnotation *annotation = [[YelpAnnotation alloc] initWithCoordinate:loc title:dataModel.name subtitle:subtitle dataModel:dataModel];
    [self.mapView addAnnotation:annotation];
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(loc, 500, 500);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    
    [self.mapView setRegion:adjustedRegion animated:YES];
    self.mapView.showsUserLocation = YES;
    [self.mapView setCenterCoordinate:loc];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
