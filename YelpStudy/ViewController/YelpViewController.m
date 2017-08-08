//
//  ViewController.m
//  YelpStudy
//
//  Created by zhuo ru li on 6/30/17.
//  Copyright © 2017 zhuo ru li. All rights reserved.
//

#import "YelpViewController.h"
#import "YelpNetworking.h"
#import "YelpTableViewCell.h"
#import "YelpDataStore.h"
#import "YelpDetailViewController.h"


@interface YelpViewController () <UITableViewDelegate, UITableViewDataSource,CLLocationManagerDelegate>
@property (nonatomic) UITableView *tableView;
@property (nonatomic, copy) NSArray <YelpDataModel *> *dataModels;
@property (nonatomic) UISearchBar *searchBar;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *userLocation;

@end


@implementation YelpViewController

-(void)didTapSettings {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settings"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapSettings)];
    
    //     Setup search bar
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    self.searchBar.tintColor = [UIColor lightGrayColor];
    self.navigationItem.titleView = self.searchBar;
    
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
     [self.tableView registerNib:[UINib nibWithNibName:@"YelpTableViewCell" bundle:nil] forCellReuseIdentifier:@"YelpViewCell"];
    
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:37.331566 longitude:-122.032744];
    [[YelpNetworking sharedInstance] fetchRestaurantsBasedOnLocation:loc term:@"sushi" completionBlock:^(NSArray<YelpDataModel *> *dataModelArray) {
        self.dataModels = dataModelArray;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    
}



#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YelpDetailViewController *detailVC = [[YelpDetailViewController alloc] initWithDataModel:self.dataModels [indexPath.row]];
    [self.navigationController pushViewController:detailVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YelpTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"YelpViewCell"];
    
    [cell updateBasedOnDataModel:self.dataModels[indexPath.row]];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

/*- (NSInteger)numberOfRowsInTableView:(UITableView *)tableView
{
    return self.dataModels.count;
}*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataModels count];
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    [self.view endEditing:YES];
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:37.3263625 longitude:-122.027210];
    
    // the following code the key that we can finally make our table be able to search based on user’s input
    
    [[YelpNetworking sharedInstance] fetchRestaurantsBasedOnLocation:loc term:searchBar.text completionBlock:^(NSArray<YelpDataModel *> *dataModelArray) {
        self.dataModels = dataModelArray;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

// Reset search bar state after cancel button clicked
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    [self.view endEditing:YES];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (error) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Oops..."
                                                                       message:@"Failed to Get Location"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    self.userLocation = currentLocation;
    [[YelpDataStore sharedInstance] setUserLocation:currentLocation];
    
    //[manager stopUpdatingLocation];
    NSLog(@"current location %lf %lf", self.userLocation.coordinate.latitude, self.userLocation.coordinate.longitude);
    [[YelpNetworking sharedInstance] fetchRestaurantsBasedOnLocation:currentLocation term:@"restaurant" completionBlock:^(NSArray<YelpDataModel *> *dataModelArray) {
        self.dataModels = dataModelArray;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

@end
