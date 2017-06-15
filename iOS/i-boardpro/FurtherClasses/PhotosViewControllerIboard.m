

#import "PhotosViewControllerIboard.h"
#import "CustomCell.h"
#import "CollectionReusableHeaderView.h"
#import "UIImageView+WebCache.h"
#import "SingletonClassIboard.h"
#import  <AssetsLibrary/AssetsLibrary.h>

@interface PhotosViewControllerIboard ()
{
    CustomCell * CustomCellView;
    CollectionReusableHeaderView * reuseableView;
    UIActivityIndicatorView * activityIndicator;
    UILabel * noPhotos,*noInternetConnnection;
    UIView * popUpview;
    NSURL * _url;
}
@end

@implementation PhotosViewControllerIboard
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"firedNotification" object:nil];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(firedNotification) name:@"firedNotification" object:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    windowSize=[UIScreen mainScreen].bounds.size;
    
    self.imageUrl=[[NSMutableArray alloc]init];
    
   self.view.backgroundColor = [UIColor colorWithRed:(CGFloat)227/255 green:(CGFloat)227/255 blue:(CGFloat)227/255 alpha:1.0];
     //self.view.backgroundColor=[UIColor whiteColor];
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
    [noPhotos removeFromSuperview];
    
    [activityIndicator startAnimating];
    [noInternetConnnection removeFromSuperview];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"reachability" object:nil];
    if ([SingletonClassIboard shareSinglton].isActivenetworkConnection==YES) {
        

    
    dispatch_async(dispatch_get_global_queue(0, 0),^{
       
        [self fetchUserPhotos];
        dispatch_async(dispatch_get_main_queue(),^{
            [activityIndicator stopAnimating];
            
            [self createCollectionView];
        });
    });
    }
    else{
        [activityIndicator stopAnimating];
        if (noInternetConnnection) {
            [noInternetConnnection removeFromSuperview];
            noInternetConnnection=nil;
        }
        noInternetConnnection=[[UILabel alloc]initWithFrame:CGRectMake(30, windowSize.height/2-50, windowSize.width-50, 50)];
        noInternetConnnection.text=@"Please check your InterNet connection.";
        noInternetConnnection.numberOfLines=0;
        noInternetConnnection.textAlignment=NSTextAlignmentCenter;
        noInternetConnnection.lineBreakMode=NSLineBreakByWordWrapping;
        [self.view addSubview:noInternetConnnection];
    }
}

-(void)createCollectionView{
    
    if (self.imageUrl.count<1) {
        noPhotos=[[UILabel alloc]initWithFrame:CGRectMake(30, windowSize.height/2-50, windowSize.width-50, 50)];
        noPhotos.text=@"Photos are not avilable.";
        noPhotos.textAlignment=NSTextAlignmentCenter;
        noPhotos.font=[UIFont boldSystemFontOfSize:14];
        noPhotos.numberOfLines=0;
        noPhotos.lineBreakMode=NSLineBreakByWordWrapping;
        [self.view addSubview:noPhotos];
        
    }
    else{
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
    self.mainCollectionView.backgroundColor = [UIColor whiteColor];
    [self.mainCollectionView registerClass:[CustomCell class] forCellWithReuseIdentifier:@"CustomCollectionCell"];
    
    [self.view addSubview:self.mainCollectionView];
    //self.mainCollectionView.scrollEnabled = NO;
    [self.mainCollectionView registerClass:[CollectionReusableHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    }
    
}

#pragma mark- collection delegate methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageUrl.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
     CustomCellView=[collectionView dequeueReusableCellWithReuseIdentifier:@"CustomCollectionCell" forIndexPath:indexPath];
    
    NSURL * url=[NSURL URLWithString:[self.imageUrl objectAtIndex:indexPath.row]];
    
    [CustomCellView.profileImageView sd_setImageWithURL:url];
    
    return CustomCellView;
    
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

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
     _url=[NSURL URLWithString:[self.imageUrl objectAtIndex:indexPath.row]];
    [self createPopUp:_url];
}


-(void)createPopUp:(NSURL*)url{
     popUpview =[[UIView alloc]initWithFrame:CGRectMake(0, 0, windowSize.width, windowSize.height-55)];
    popUpview.backgroundColor = [UIColor blackColor];
    [self.view insertSubview:popUpview   aboveSubview:self.mainCollectionView];
    
    UIImageView * imageView =[[UIImageView alloc]initWithFrame:CGRectMake(10, 40, popUpview.frame.size.width-20, popUpview.frame.size.height-100)];
    [imageView sd_setImageWithURL:url];
    [popUpview addSubview:imageView];
    imageView.userInteractionEnabled = YES;
    
    [UIView animateWithDuration:0.5 animations:^{
        popUpview.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    } completion:^(BOOL finished) {
                   popUpview.transform = CGAffineTransformIdentity;
       

    }];
    
    UITapGestureRecognizer * tpGesture =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(topGetsuteMthod:)];
    tpGesture.numberOfTapsRequired = 1 ;
    [imageView addGestureRecognizer:tpGesture];
    
    UISwipeGestureRecognizer * swipe =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGesture:)];
    swipe.direction = UISwipeGestureRecognizerDirectionDown;
    [imageView addGestureRecognizer:swipe];
}

-(void)topGetsuteMthod:(UITapGestureRecognizer *)tap {
   
    ALAsset * lib =[[ALAsset alloc]init];
    NSData * data =[NSData dataWithContentsOfURL:_url];
    [lib writeModifiedImageDataToSavedPhotosAlbum:data metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
        if (!error) {
            NSLog(@"Saved");
        }
        else{
            NSLog(@"%@",error);
        }
    }];
}

-(void)swipeGesture:(UISwipeGestureRecognizer*) swipe{
    [UIView animateWithDuration:0.5 animations:^{
        popUpview.frame = CGRectMake(0, windowSize.height+50, windowSize.width, windowSize.height);
    } completion:^(BOOL finished) {
        [popUpview removeFromSuperview];
        popUpview = nil;
    }];
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
    [[SingletonClassIboard shareSinglton]shareImageToInstagramFromController:self];
    
   // [[NSNotificationCenter defaultCenter]removeObserver:self name:@"firedNotification" object:nil];
    
//    CGRect rect = CGRectMake(0 ,0 ,120, 60);
//    NSURL *instagramURL = [NSURL URLWithString:[NSString stringWithFormat: @"instagram://media?id=%@",[SingletonClassIboard shareSinglton].imageId]];
//    
//    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
//        
//        self.dic = [UIDocumentInteractionController interactionControllerWithURL:[NSURL URLWithString:[SingletonClassIboard shareSinglton].imagePath]];
//        self.dic.delegate = self;
//        self.dic.UTI = @"com.instagram.photo";
//        self.dic=[UIDocumentInteractionController interactionControllerWithURL:[NSURL URLWithString:[SingletonClassIboard shareSinglton].imagePath]];
//         self.dic.annotation = [NSDictionary dictionaryWithObject:[SingletonClassIboard shareSinglton].captionStr forKey:@"InstagramCaption"];
//        [self.dic presentOpenInMenuFromRect: CGRectZero    inView:self.view animated: YES ];
//        
//    }
    
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
