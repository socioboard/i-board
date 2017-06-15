//
//  LocationSearchViewControllerIboard.m
//  i-boardpro
//
//  Created by GBS-ios on 9/18/15.
//  Copyright (c) 2015 Sumit Ghosh. All rights reserved.
//

#import "LocationSearchViewControllerIboard.h"
#import "TableCustomCell.h"
#import "LocationFeedsViewControllerIboard.h"

@interface LocationSearchViewControllerIboard ()
{
    UITableView * searchTable;
    CGSize windowSize;
    NSMutableArray * resultArr;
    UIActivityIndicatorView * activityIndicator;
    UITextField * searchBox;
    NSString *pagination;
    LocationFeedsViewControllerIboard  * locationFeeds;
    NSString *lat,* longi;
    NSMutableDictionary * dict;
}
@end

@implementation LocationSearchViewControllerIboard

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isClickedLocation = NO;
    
    dict =[[NSMutableDictionary alloc]init];
    windowSize = [UIScreen mainScreen].bounds.size;
    resultArr =[[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
    
    activityIndicator =[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(windowSize.width/2-20, windowSize.height/2-50, 40, 40)];
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    activityIndicator.alpha = 1.0;
    activityIndicator.color = [UIColor blackColor];
    [self.view addSubview:activityIndicator];
    
    self.view.backgroundColor = [UIColor colorWithRed:(CGFloat)227/255 green:(CGFloat)227/255 blue:(CGFloat)227/255 alpha:1.0];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(createUI) name:@"Location" object:nil];
    
//    self.bannerView =[[GADBannerView alloc]initWithAdSize:kGADAdSizeBanner];
//    self.bannerView.frame = CGRectMake(0, windowSize.height-105, windowSize.width, 50);
//    self.bannerView.adUnitID = adMobId_iboard;
//    self.bannerView.delegate = self;
//    self.bannerView.rootViewController = self;
//    GADRequest * request =[GADRequest request];
//    //request.testDevices = @[ kGADSimulatorID ];
//    [self.bannerView loadRequest:request];
//    [self.view addSubview:self.bannerView];

       // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
}


#pragma mark- create UI

-(void)createUI{
    
    [resultArr removeAllObjects];
    //searchTable =[[UITableView alloc]initWithFrame:CGRectMake(0, 0,windowSize.width ,windowSize.height-105)];
    searchTable =[[UITableView alloc]initWithFrame:CGRectMake(0, 0,windowSize.width ,windowSize.height-55)];
    searchTable.delegate = self;
    searchTable.dataSource = self;
    searchTable.showsVerticalScrollIndicator = NO;
    [self.view addSubview:searchTable];
    self.bannerView =[[GADBannerView alloc]initWithAdSize:kGADAdSizeBanner];
   self.bannerView.frame =  CGRectMake((windowSize.width - self.bannerView.frame.size.width)/2, windowSize.height-105, self.bannerView.frame.size.width, 50);
    self.bannerView.adUnitID = adMobId_iboard;
    self.bannerView.delegate = self;
    self.bannerView.rootViewController = self;
    GADRequest * request =[GADRequest request];
    //request.testDevices = @[ kGADSimulatorID ];
    [self.bannerView loadRequest:request];
    [self.view addSubview:self.bannerView];
    
    UIView * headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, windowSize.width, 80)];
    headerView.backgroundColor=[UIColor colorWithRed:(CGFloat)50/255 green:(CGFloat)50/255 blue:(CGFloat)50/255 alpha:(CGFloat)1];
    searchTable.tableHeaderView=headerView;
    
    searchBox=[[UITextField alloc]initWithFrame:CGRectMake(10, 20, windowSize.width/2+50, 30)];
    searchBox.delegate=self;
    searchBox.layer.borderColor=[UIColor blackColor].CGColor;
    searchBox.layer.borderWidth=0.5f;
    searchBox.layer.cornerRadius=5;
    searchBox.clipsToBounds=YES;
    searchBox.placeholder=@" Search location";
    searchBox.font=[UIFont systemFontOfSize:12];
    searchBox.textColor=[UIColor blackColor];
    searchBox.backgroundColor=[UIColor whiteColor];
    searchBox.textAlignment=NSTextAlignmentCenter;
    [headerView addSubview:searchBox];
    
    UIButton * searchBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame=CGRectMake(windowSize.width/2+70, 20, (windowSize.width-(windowSize.width/2+80)), 30);
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"iboard-search_btn.png"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchHashTags) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:searchBtn];
    
    searchTable.tableFooterView = [[UIView alloc]init];
}


#pragma mark - tableView delgate methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return resultArr.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TableCustomCell * cell =(TableCustomCell *)[tableView  cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[TableCustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"#Tags"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
 
    if ([[resultArr objectAtIndex:indexPath.row]objectForKey:@"formatted_address"]) {
        cell.hashName.text =[NSString stringWithFormat:@"%@",[[resultArr objectAtIndex:indexPath.row]objectForKey:@"formatted_address"]];
    }
    else{
        cell.hashName.text =[NSString stringWithFormat:@"%@",[[resultArr objectAtIndex:indexPath.row]objectForKey:@"name"]];
    }
    
//    cell.mediaCount.text =[NSString stringWithFormat:@"mediacount : %@",[[resultArr objectAtIndex:indexPath.row]objectForKey:@"media_count"]];
    
    return  cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  60;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([dict  objectForKey:@"lat"] == nil || [dict objectForKey:@"lat"] == [NSNull null] ) {
        
        //isClickedLocation = YES;
        [self getLocationBaseFeedsList:[[[resultArr objectAtIndex:indexPath.row]objectForKey:@"geometry"]objectForKey:@"location"]];

    }
    else{
        if (locationFeeds) {
            locationFeeds = nil;
        }
        locationFeeds =[[LocationFeedsViewControllerIboard alloc]initWithDictionary:[resultArr objectAtIndex:indexPath.row]];
        [self presentViewController:locationFeeds animated:YES completion:nil];
    }
}

#pragma mark- textField delgate methods

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [resultArr removeAllObjects];
    return  YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return  YES;
}


#pragma  mark - serach functionality  basis on tags.

-(void)searchHashTags{
    
    [resultArr removeAllObjects];
    if ([dict objectForKey:@"lat"] !=nil) {
        [dict setObject:[NSNull null] forKey:@"lat"];
        [dict setObject:[NSNull null] forKey:@"lng"];
    }
    
    NSError * error;
    NSURLResponse * urlResponse;
    
    NSString *urlStr =   [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@",searchBox.text];
    urlStr = [urlStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * getUrl =[NSURL URLWithString: urlStr];
    NSMutableURLRequest * getRequest =[[NSMutableURLRequest alloc]initWithURL:getUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:50];
    //on 2.5.2017 added
    
    [getRequest setHTTPMethod:@"GET"];
    [getRequest addValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //
    NSData * data =[NSURLConnection sendSynchronousRequest:getRequest returningResponse:&urlResponse error:&error];
    if (!data) {
        return;
    }
    
    id jsonResponse =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
       if ([[jsonResponse objectForKey:@"status"] isEqualToString:@"OK"]) {
        NSArray * dataArr = [jsonResponse objectForKey:@"results"];
        for (int i =0; i< dataArr.count; i++) {
            [resultArr addObject:[dataArr objectAtIndex:i]];
      }
        [searchTable reloadData];
    }
    
}



#pragma mark- get all Location Base id's

-(void)getLocationBaseFeedsList:(NSDictionary*)dictionary{
    
    if (dictionary) {
        [dict setObject:[dictionary objectForKey:@"lat"] forKey:@"lat"];
        [dict setObject:[dictionary objectForKey:@"lng"] forKey:@"lng"];
    }
    
    NSError * error;
    NSURLResponse * urlResponse;
    
    NSString * access_token=[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"];
    NSURL * getUrl;

    getUrl =[NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/locations/search?lat=%@&lng=%@&access_token=%@",[dict objectForKey:@"lat"],[dict objectForKey:@"lng"],access_token]];
        

    NSMutableURLRequest * getRequest =[[NSMutableURLRequest alloc]initWithURL:getUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:50];
    
    [getRequest setHTTPMethod:@"GET"];
    [getRequest addValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSData * data =[NSURLConnection sendSynchronousRequest:getRequest returningResponse:&urlResponse error:&error];
    if (!data) {
        return;
    }
    
    id jsonResponse =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
   
    if ([[[jsonResponse objectForKey:@"meta"]objectForKey:@"code"] isEqualToNumber:[NSNumber numberWithInt:200]]) {
        [resultArr removeAllObjects];
        NSArray  * arr =[jsonResponse objectForKey:@"data"];
        for (int i=0; i<arr.count; i++) {
            [resultArr addObject:[arr objectAtIndex:i]];
        }
         [searchTable reloadData];
    }
   
    
}

#pragma mark- delegate methods of bannerview

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView{
    
    NSLog(@"Ad received");
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error{
    
    NSLog(@"Failed to receive");
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
