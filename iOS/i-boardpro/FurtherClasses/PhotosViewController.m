//
//  PhotosViewController.m
//  Board
//
//  Created by Sumit Ghosh on 23/04/15.
//  Copyright (c) 2015 Sumit Ghosh. All rights reserved.
//

#import "PhotosViewController.h"
#import "CustomCell.h"
#import "CollectionReusableHeaderView.h"
#import "UIImageView+WebCache.h"
#import "SingletonClass.h"

@interface PhotosViewController ()
{
    CustomCell * customCellView;
    CollectionReusableHeaderView * reuseableView;
    UIActivityIndicatorView * activityIndicator;
}
@end

@implementation PhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(firedNotification) name:@"firedNotification" object:nil];
    windowSize=[UIScreen mainScreen].bounds.size;
    
    self.imageUrl=[[NSMutableArray alloc]init];
    
    activityIndicator=[[UIActivityIndicatorView alloc]init];
    activityIndicator.frame=CGRectMake(windowSize.width/2-20, 150, 40, 40);
    activityIndicator.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
    activityIndicator.color=[UIColor blackColor];
    activityIndicator.alpha=1.0;
    [self.view addSubview:activityIndicator];
    [self.view bringSubviewToFront:activityIndicator];
         [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(createUI) name:@"getUserPhotos" object:nil];
    
    
    
    // Do any additional setup after loading the view from its nib.
}

-(void)createUI{
    [self.mainCollectionView removeFromSuperview];

    [activityIndicator startAnimating];
    dispatch_async(dispatch_get_global_queue(0, 0),^{
       
        [self fetchUserPhotos];
        dispatch_async(dispatch_get_main_queue(),^{
            [activityIndicator stopAnimating];
            [self createCollectionView];
        });
    });
}

-(void)createCollectionView{
    
   
    //---------
    UICollectionViewFlowLayout *flowLayOut= [[UICollectionViewFlowLayout alloc] init];
    flowLayOut.minimumInteritemSpacing = (CGFloat)2.0;
    flowLayOut.minimumLineSpacing = (CGFloat)2.0;
    flowLayOut.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
  
    self.mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, windowSize.width, windowSize.height-55) collectionViewLayout:flowLayOut];
   
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.mainCollectionView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    self.mainCollectionView.dataSource = self;
    self.mainCollectionView.delegate = self;
    self.mainCollectionView.backgroundColor = [UIColor clearColor];
    [self.mainCollectionView registerClass:[CustomCell class] forCellWithReuseIdentifier:@"CustomCollectionCell"];
    
    [self.view addSubview:self.mainCollectionView];
    //self.mainCollectionView.scrollEnabled = NO;
    [self.mainCollectionView registerClass:[CollectionReusableHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    
}

#pragma mark- collection delegate methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageUrl.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
     customCellView=[collectionView dequeueReusableCellWithReuseIdentifier:@"CustomCollectionCell" forIndexPath:indexPath];
    
    NSURL * url=[NSURL URLWithString:[self.imageUrl objectAtIndex:indexPath.row]];
    
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



- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if (kind == UICollectionElementKindSectionHeader){
        
        reuseableView = nil;
        
       
            reuseableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
            reuseableView.backgroundColor = [UIColor whiteColor];
       
        
        reuseableView.headerTitleLabel.text = @"   Photos";
       
       
        
        return reuseableView;
        
    }//End Header Kind Check
    return nil;
}

#pragma mark- fetch user photos

-(void)fetchUserPhotos{
    
    [self.imageUrl removeAllObjects];
    
    NSError * error;
    NSURLResponse * urlResponse;
    
    NSString * accesToken=[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"];
    
    NSURL * getUrl=[NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/users/self/media/recent/?access_token=%@",accesToken]];
    
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
        
        [self.imageUrl addObject:[lowResDict objectForKey:@"url"]];
        
    }
                    
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
