//
//  UserProfileViewController.m
//  Board
//
//  Created by Sumit Ghosh on 24/04/15.
//  Copyright (c) 2015 Sumit Ghosh. All rights reserved.
//

#import "UserProfileViewController.h"
#import "CustomCell.h"
#import "CollectionReusableHeaderView.h"
#import "SingletonClass.h"
#import "UIImageView+WebCache.h"
#import "SingletonClass.h"

@interface UserProfileViewController ()
{
    CustomCell * customCellView;
    CollectionReusableHeaderView * reuseableView;
    UIActivityIndicatorView  * activityView;
}
@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(firedNotification) name:@"firedNotification" object:nil];
    windowSize=[UIScreen mainScreen].bounds.size;
    
    imageUrl=[[NSMutableArray alloc]init];
    
    
    
    self.view.backgroundColor=[UIColor colorWithRed:(CGFloat)150/255 green:(CGFloat)150/255 blue:(CGFloat)150/255 alpha:(CGFloat)1];

    activityView=[[UIActivityIndicatorView alloc]init];
    activityView.frame=CGRectMake(windowSize.width/2-20, 150, 40,40);
    activityView.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
    activityView.color=[UIColor whiteColor];
    activityView.alpha=1.0;
    [self.view addSubview:activityView];
    [self.view bringSubviewToFront:activityView];
    [activityView startAnimating];

    dispatch_async(dispatch_get_global_queue(0, 0),^{
        [self loadAllFollowers];
        [self fetchUserPhotos ];
        dispatch_async(dispatch_get_main_queue(),^{
            [activityView stopAnimating];
            [self createUIForProfile];
        });
    });
    // Do any additional setup after loading the view from its nib.
}

// create UI for showing selected user data there images
-(void)createUIForProfile{
    
    profileImage=[[UIImageView alloc]init];
    profileImage.frame=CGRectMake(15, 60, 50, 50);
    profileImage.layer.cornerRadius=profileImage.frame.size.width/2;
    profileImage.clipsToBounds=YES;
    profileImage.backgroundColor=[UIColor colorWithRed:(CGFloat)235/255 green:(CGFloat)235/255 blue:(CGFloat)235/255 alpha:(CGFloat)1];
    profileImage.layer.borderColor=[UIColor whiteColor].CGColor;
    profileImage.layer.borderWidth=1.5;
    
    NSURL * url=[NSURL URLWithString:profilePicStr];
    NSData * imageData=[NSData dataWithContentsOfURL:url];
   
   
    
    profileImage.image=[UIImage imageWithData:imageData];
    [self.view addSubview:profileImage];
    
   
    if (full_name) {
        full_name=nil;
    }
    full_name =[[UILabel alloc]init];
    full_name.frame=CGRectMake(windowSize.width/2-80, 20, 150,20);
    full_name.text=userFullName;
    full_name.font=[UIFont boldSystemFontOfSize:14];
    full_name.textColor=[UIColor whiteColor];
    full_name.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:full_name];
    
   
    if (username) {
        username=nil;
    }
    username=[[UILabel alloc]init];
    username.frame=CGRectMake(80, 60, 150, 10);
    username.text=userNameStr;
    username.font=[UIFont boldSystemFontOfSize:12];
    [self.view addSubview:username];
    
    
    UITextView * bioTextView=[[UITextView alloc]initWithFrame:CGRectMake(80, 70, windowSize.width-100, 80)];
    bioTextView.textColor=[UIColor blackColor];
    bioTextView.text=bio;
    bioTextView.backgroundColor=[UIColor clearColor];
    bioTextView.font=[UIFont systemFontOfSize:10];
    bioTextView.userInteractionEnabled=NO;
    [self.view addSubview:bioTextView];
    
    UIButton * closeBtn=[[UIButton alloc]init];
    closeBtn.frame=CGRectMake(20, 20, 50, 25);
    [closeBtn setTitle:@"Close" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    closeBtn.titleLabel.font=[UIFont systemFontOfSize:11];
    [closeBtn setBackgroundColor:[UIColor colorWithRed:(CGFloat)54/255 green:(CGFloat)54/255 blue:(CGFloat)54/255 alpha:(CGFloat)1]];
    closeBtn.layer.cornerRadius=7;
    closeBtn.clipsToBounds=YES;
    [closeBtn addTarget:self action:@selector(closeAccount) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    
    loggedInImge=[[UIImageView alloc]init];
    loggedInImge.frame=CGRectMake(windowSize.width-70, 20, 30, 30);
    loggedInImge.layer.cornerRadius=loggedInImge.frame.size.width/2;
    loggedInImge.clipsToBounds=YES;
    loggedInImge.backgroundColor=[UIColor colorWithRed:(CGFloat)235/255 green:(CGFloat)235/255 blue:(CGFloat)235/255 alpha:(CGFloat)1];
    loggedInImge.layer.borderColor=[UIColor whiteColor].CGColor;
    loggedInImge.layer.borderWidth=1.5;
    
    
    NSURL * url1=[NSURL URLWithString:[SingletonClass shareSinglton].user_pic];
     NSData * imageData1=[NSData dataWithContentsOfURL:url1];
    
    loggedInImge.image=[UIImage imageWithData:imageData1];
    [self.view addSubview:loggedInImge];

    
    //-------------------
    
    mediaCountLbl=[[UILabel alloc]init];
    mediaCountLbl.frame=CGRectMake(30, 170, 40, 10);
    mediaCountLbl.text=mediaCountStr;
    mediaCountLbl.font=[UIFont boldSystemFontOfSize:10];
    mediaCountLbl.textAlignment=NSTextAlignmentCenter;
    mediaCountLbl.textColor=[UIColor colorWithRed:(CGFloat)235/255 green:(CGFloat)235/255 blue:(CGFloat)235/255 alpha:(CGFloat)1];
    [self.view addSubview:mediaCountLbl];
    
    followsCountLbl=[[UILabel alloc]init];
    followsCountLbl.frame=CGRectMake(windowSize.width/2-30, 170, 60, 10);
    followsCountLbl.text=followsCountStr;
    followsCountLbl.textAlignment=NSTextAlignmentCenter;
    followsCountLbl.font=[UIFont boldSystemFontOfSize:10];
    followsCountLbl.textColor=[UIColor colorWithRed:(CGFloat)235/255 green:(CGFloat)235/255 blue:(CGFloat)235/255 alpha:(CGFloat)1];
    [self.view addSubview:followsCountLbl];
    
    followingCountLbl=[[UILabel alloc]init];
    followingCountLbl.frame=CGRectMake(windowSize.width-90, 170, 40, 10);
    followingCountLbl.text=followingCountStr;
    followingCountLbl.textAlignment=NSTextAlignmentCenter;
    followingCountLbl.font=[UIFont boldSystemFontOfSize:10];
    followingCountLbl.textColor=[UIColor colorWithRed:(CGFloat)235/255 green:(CGFloat)235/255 blue:(CGFloat)235/255 alpha:(CGFloat)1];
    [self.view addSubview:followingCountLbl];

    
    
    UILabel * mediaCount=[[UILabel alloc]init];
    mediaCount.frame=CGRectMake(40, 180, 40, 10);
    mediaCount.text=@"Media";
    mediaCount.font=[UIFont boldSystemFontOfSize:10];
    mediaCount.textColor=[UIColor colorWithRed:(CGFloat)235/255 green:(CGFloat)235/255 blue:(CGFloat)235/255 alpha:(CGFloat)1];
    [self.view addSubview:mediaCount];
    
    UILabel * Follower=[[UILabel alloc]init];
    Follower.frame=CGRectMake(windowSize.width/2-20, 180, 80, 10);
    Follower.text=@"Followers";
    Follower.font=[UIFont boldSystemFontOfSize:10];
    Follower.textColor=[UIColor colorWithRed:(CGFloat)235/255 green:(CGFloat)235/255 blue:(CGFloat)235/255 alpha:(CGFloat)1];
    [self.view addSubview:Follower];
    
    UILabel * following=[[UILabel alloc]init];
    following.frame=CGRectMake(windowSize.width-80, 180, 80, 10);
    following.text=@"Following";
    following.font=[UIFont boldSystemFontOfSize:10];
    following.textColor=[UIColor colorWithRed:(CGFloat)235/255 green:(CGFloat)235/255 blue:(CGFloat)235/255 alpha:(CGFloat)1];
    [self.view addSubview:following];
    
    [self createCollectionView];
    
    
}
// creat CollectionView to show images
-(void)createCollectionView{
    
    UICollectionViewFlowLayout *flowLayOut= [[UICollectionViewFlowLayout alloc] init];
    flowLayOut.minimumInteritemSpacing = (CGFloat)2.0;
    flowLayOut.minimumLineSpacing = (CGFloat)2.0;
    flowLayOut.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    
    self.mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, windowSize.height/2, windowSize.width, windowSize.height/2) collectionViewLayout:flowLayOut];
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.mainCollectionView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    self.mainCollectionView.dataSource = self;
    self.mainCollectionView.delegate = self;
    self.mainCollectionView.backgroundColor = [UIColor clearColor];
    [self.mainCollectionView registerClass:[CustomCell class] forCellWithReuseIdentifier:@"CustomCollectionCell"];
    self.mainCollectionView.showsVerticalScrollIndicator=NO;
    
    [self.view addSubview:self.mainCollectionView];

}


#pragma mark- collection delegate methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return imageUrl.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    customCellView=[collectionView dequeueReusableCellWithReuseIdentifier:@"CustomCollectionCell" forIndexPath:indexPath];
    
        NSURL * url=[NSURL URLWithString:[imageUrl objectAtIndex:indexPath.row]];
        [customCellView.profileImageView sd_setImageWithURL:url];
    
    return customCellView;
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(73, 73);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    
    CGSize size = CGSizeMake(self.view.frame.size.width, 25);
    return size;
    
}

#pragma  mark-  load Followers
-(void)loadAllFollowers{
    
  
   
    NSString * accessToken=[[ NSUserDefaults standardUserDefaults]                                                                                                                                               valueForKey:@"access_token"];
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/?access_token=%@",self.userId,accessToken]]];
        NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    
    NSMutableDictionary * metaDic=[NSMutableDictionary dictionary];
    
    metaDic=[dictResponse objectForKey:@"meta"];
    if ([[metaDic objectForKey:@"code"] isEqualToNumber:[NSNumber numberWithInt:200]]) {
        NSMutableDictionary * dict=[NSMutableDictionary dictionary];
        NSMutableDictionary * countsDict=[NSMutableDictionary dictionary];
        dict=[dictResponse objectForKey:@"data"];
        bio=[dict objectForKey:@"bio"];
        countsDict=[dict objectForKey:@"counts"];
        userFullName=[dict objectForKey:@"full_name"];
        profilePicStr=[dict objectForKey:@"profile_picture"];
        followsCountStr=[NSString stringWithFormat:@"%@",[countsDict objectForKey:@"follows"]];
        followingCountStr=[NSString stringWithFormat:@"%@",[countsDict objectForKey:@"followed_by"]];
        mediaCountStr=[NSString stringWithFormat:@"%@",[countsDict objectForKey:@"media"]];
    }
  
    
}


#pragma mark- fetch user photos

-(void)fetchUserPhotos{
    
    [imageUrl removeAllObjects];
    
    NSError * error;
    NSURLResponse * urlResponse;
    
    NSString * accesToken=[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"];
    
    NSURL * getUrl=[NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/media/recent/?access_token=%@",self.userId,accesToken]];
    
    NSMutableURLRequest * request=[[NSMutableURLRequest alloc]initWithURL:getUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:50];
    
    [request setHTTPMethod:@"GET"];
    
    [request addValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSData * data=[NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (data==nil) {
        return;
    }
    id response=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSArray * dataArr=[response objectForKey:@"data"];
    
    NSMutableDictionary * dict=[NSMutableDictionary dictionary];
    NSMutableDictionary * imagesDict=[NSMutableDictionary dictionary];
    NSMutableDictionary * lowResDict=[NSMutableDictionary dictionary];
    for (int i=0; i<dataArr.count; i++) {
        
        dict=[dataArr objectAtIndex:i];
        imagesDict=[dict objectForKey:@"images"];
        lowResDict=[imagesDict objectForKey:@"low_resolution"];
        
        [imageUrl addObject:[lowResDict objectForKey:@"url"]];
        
    }
    
}


-(void)closeAccount{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)firedNotification {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"firedNotification" object:nil];
    
    CGRect rect = CGRectMake(0 ,0 ,120, 60);
    NSURL *instagramURL = [NSURL URLWithString:[NSString stringWithFormat: @"instagram://media?id=%@",[SingletonClass shareSinglton].imageId]];
    
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        
        self.dic = [UIDocumentInteractionController interactionControllerWithURL:[NSURL URLWithString:[SingletonClass shareSinglton].imagePath]];
        self.dic.delegate = self;
        self.dic.UTI = @"com.instagram.photo";
        self.dic=[UIDocumentInteractionController interactionControllerWithURL:[NSURL URLWithString:[SingletonClass shareSinglton].imagePath]];
        [self.dic presentOpenInMenuFromRect: CGRectZero    inView:self.view animated: YES ];
        
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
