//
//  SearchTagsViewControllerIboard.m
//  i-boardpro
//
//  Created by GBS-ios on 9/9/15.
//  Copyright (c) 2015 Sumit Ghosh. All rights reserved.
//

#import "SearchTagsViewControllerIboard.h"
#import "TableCustomCell.h"
#import "deatilsOfSearchInstaViewControllerIboard.h"

@interface SearchTagsViewControllerIboard ()
{
    UITableView * searchTable;
    CGSize windowSize;
    NSMutableArray * resultArr;
    UIActivityIndicatorView * activityIndicator;
    UITextField * searchBox;
    deatilsOfSearchInstaViewControllerIboard * detailVC;
}
@end

@implementation SearchTagsViewControllerIboard

- (void)viewDidLoad {
    [super viewDidLoad];
    
 
    windowSize = [UIScreen mainScreen].bounds.size;
    resultArr =[[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
    
    activityIndicator =[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(windowSize.width/2-20, windowSize.height/2-50, 40, 40)];
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    activityIndicator.alpha = 1.0;
    activityIndicator.color = [UIColor blackColor];
    [self.view addSubview:activityIndicator];
    
    self.view.backgroundColor = [UIColor colorWithRed:(CGFloat)227/255 green:(CGFloat)227/255 blue:(CGFloat)227/255 alpha:1.0];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadService) name:@"#Tags" object:nil];
    
    self.bannerView =[[GADBannerView alloc]initWithAdSize:kGADAdSizeBanner];
    self.bannerView.frame = CGRectMake(0, windowSize.height-105, windowSize.width, 50);
    self.bannerView.adUnitID = adMobId_iboard;
    self.bannerView.delegate = self;
    self.bannerView.rootViewController = self;
    GADRequest * request =[GADRequest request];
    //request.testDevices = @[ kGADSimulatorID ];
    [self.bannerView loadRequest:request];
    //[self.view addSubview:self.bannerView];
    
}

-(void)loadService{
    [resultArr removeAllObjects];
    [activityIndicator startAnimating];
    dispatch_async(dispatch_get_global_queue(0, 0),^{
       // [self searchHashTags];
        dispatch_async(dispatch_get_main_queue(),^{
            [activityIndicator stopAnimating];
            [self createUI];
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- create UI

-(void)createUI{
    
   // searchTable =[[UITableView alloc]initWithFrame:CGRectMake(0, 0,windowSize.width ,windowSize.height-105)];
    searchTable =[[UITableView alloc]initWithFrame:CGRectMake(0, 0,windowSize.width ,windowSize.height-55)];
    searchTable.delegate = self;
    searchTable.dataSource = self;
    searchTable.showsVerticalScrollIndicator = NO;
    [self.view addSubview:searchTable];
    
    
    UIView * headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, windowSize.width, 80)];
    headerView.backgroundColor=[UIColor colorWithRed:(CGFloat)50/255 green:(CGFloat)50/255 blue:(CGFloat)50/255 alpha:(CGFloat)1];
    searchTable.tableHeaderView=headerView;
    
    searchBox=[[UITextField alloc]initWithFrame:CGRectMake(10, 20, windowSize.width/2+50, 30)];
    searchBox.delegate=self;
    searchBox.layer.borderColor=[UIColor blackColor].CGColor;
    searchBox.layer.borderWidth=0.5f;
    searchBox.layer.cornerRadius=5;
    searchBox.clipsToBounds=YES;
    searchBox.placeholder=@" #Tags";
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
    
    cell.hashName.text =[NSString stringWithFormat:@"#%@",[[resultArr objectAtIndex:indexPath.row]objectForKey:@"name"]];
    cell.mediaCount.text =[NSString stringWithFormat:@"mediacount : %@",[[resultArr objectAtIndex:indexPath.row]objectForKey:@"media_count"]];
    
    return  cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (detailVC) {
        detailVC = nil;
    }
        detailVC =[[deatilsOfSearchInstaViewControllerIboard alloc]init];
        detailVC.titleName = [[resultArr objectAtIndex:indexPath.row]objectForKey:@"name"];
    [self presentViewController:detailVC animated:YES completion:nil];
    
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
    
    NSError * error;
    NSURLResponse * urlResponse;
    
     NSString * access_token=[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"];
    NSURL * getUrl =[NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/tags/search?q=%@&access_token=%@",searchBox.text,access_token]];
    NSMutableURLRequest * getRequest =[[NSMutableURLRequest alloc]initWithURL:getUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:50];
    
    [getRequest setHTTPMethod:@"GET"];
    [getRequest addValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSData * data =[NSURLConnection sendSynchronousRequest:getRequest returningResponse:&urlResponse error:&error];
    if (!data) {
        return;
    }
    
    id jsonResponse =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if ([[[jsonResponse objectForKey:@"meta"]objectForKey:@"code"] isEqualToNumber:[NSNumber numberWithInt:200]]) {
        NSArray * dataArr = [jsonResponse objectForKey:@"data"];
        for (int i =0; i< dataArr.count; i++) {
            [resultArr addObject:[dataArr objectAtIndex:i]];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
