//
//  YelpDetailViewController.m
//  YelpStudy
//
//  Created by zhuo ru li on 7/9/17.
//  Copyright © 2017 zhuo ru li. All rights reserved.
//

#import "YelpDetailViewController.h"
#import "DetailViewHeaderTableViewCell.h"
#import "MapTableViewCell.h"
#import <AFNetworking/AFNetworking.h>

typedef NS_ENUM(NSInteger, DetailVCTableViewRow) {
    DetailVCTableViewRowHeader,
    DetailVCTableViewRowMap,
    DetailVCTableViewRowDirection,
    DetailVCTableViewRowPhone,
    DetailVCTableViewRowMessage,
    DetailVCTableViewRowMore
};

@interface YelpDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) YelpDataModel *dataModel;
@property (nonatomic) UIImage *imageForShare;

@end

@implementation YelpDetailViewController

- (instancetype)initWithDataModel:(YelpDataModel *)dataModel
{
    if (self = [super init]) {
        self.dataModel = dataModel;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MapTableViewCell" bundle:nil]forCellReuseIdentifier:@"MapTableViewCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DetailViewHeaderTableViewCell" bundle:nil]forCellReuseIdentifier:@"DetailViewHeaderTableViewCell"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapShareButton)];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    
    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession]
                                          dataTaskWithURL:[NSURL URLWithString:self.dataModel.imageUrl] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                              
                                              self.imageForShare = [UIImage imageWithData:data];
                                          }];
    
    [downloadTask resume];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didTapShareButton
{
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:@[self.dataModel.name, self.dataModel.displayAddress, self.imageForShare] applicationActivities:nil];
    
    [self presentViewController:activityViewController
                       animated:YES
                     completion:nil];
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == DetailVCTableViewRowHeader) {
        return 125;
    } else if (indexPath.row == DetailVCTableViewRowMap) {
        return 200;
    }
    return 50;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==  DetailVCTableViewRowHeader){
        DetailViewHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailViewHeaderTableViewCell"];
        [cell updateBasedOnDataModel:self.dataModel];
        return cell;
    } else if (indexPath.row == DetailVCTableViewRowMap) {
        MapTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MapTableViewCell"];
        [cell updateBasedOnDataModel:self.dataModel];
        
        return cell;
    } else  {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
        }
        if (indexPath.row == DetailVCTableViewRowDirection) {
            cell.imageView.image = [UIImage imageNamed:@"direction"];
            cell.textLabel.text = @"Directions";
            CGFloat mintues = self.dataModel.distance / 15 * 60 ;   // 15 mile per hour && 1 hour == 60 mins
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.1f min drive", mintues];
            
        } else if (indexPath.row == DetailVCTableViewRowPhone) {
            cell.imageView.image = [UIImage imageNamed:@"phone"];
            cell.textLabel.text = self.dataModel.displayPhone;
            
        } else if (indexPath.row == DetailVCTableViewRowMessage) {
            cell.imageView.image = [UIImage imageNamed:@"message"];
            cell.textLabel.text = @"Message the Business";
            
        } else if (indexPath.row == DetailVCTableViewRowMore) {
            cell.imageView.image = [UIImage imageNamed:@"dotdotdot"];
            cell.textLabel.text = @"More Info";
            cell.detailTextLabel.text = @"Menu, Hours, Website, Attire, Noise Level";
            
        }
        [cell setSeparatorInset:UIEdgeInsetsZero];
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
        return cell;
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
