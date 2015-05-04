//
//  CommentsViewController.m
//  Board
//
//  Created by Sumit Ghosh on 30/04/15.
//  Copyright (c) 2015 Sumit Ghosh. All rights reserved.
//

#import "CommentsViewController.h"
#import "TableCustomCell.h"
#import "UIImageView+WebCache.h"
#import "SingletonClass.h"

@interface CommentsViewController ()

@end

@implementation CommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    windowSize=[UIScreen mainScreen].bounds.size;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(firedNotification) name:@"firedNotification" object:nil];
    // Create header View and title and back button here.
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, windowSize.width, 55)];
    
    self.headerView.backgroundColor = [UIColor colorWithRed:55.0f/255.0f green:105.0f/255.0f blue:147.0f/255.0f alpha:1.0f];
    
    [self.view addSubview:self.headerView];
    self.headerView.layer.shadowRadius = 5.0;
    self.headerView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.headerView.layer.shadowOpacity = 0.6;
    self.headerView.layer.shadowOffset = CGSizeMake(0.0f,5.0f);
    self.headerView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.headerView.bounds].CGPath;
    
    UILabel *titltLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, 25, windowSize.width-120, 25)];
    titltLabel.text=@"Comments";
    titltLabel.textColor=[UIColor whiteColor];
    titltLabel.font=[UIFont boldSystemFontOfSize:15];
    titltLabel.textAlignment = NSTextAlignmentCenter;
    [self.headerView addSubview:titltLabel];
    
    UIButton * cancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame=CGRectMake(15, 25, 50, 25);
    cancelButton.layer.cornerRadius=5;
    cancelButton.clipsToBounds=YES;
    [cancelButton setTitle:@"Back" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:cancelButton];
    
   
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    dispatch_async(dispatch_get_global_queue(0, 0),^{
        [self fetchComments:self.capId];
        dispatch_async(dispatch_get_main_queue(),^{
           
            [self createTable];
        });
    });
    // Do any additional setup after loading the view from its nib.
}

-(void)cancelButtonAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// create comments Table here
-(void)createTable{
    if (commentsTbl) {
            commentsTbl=nil;
        }
        commentsTbl=[[UITableView alloc]initWithFrame:CGRectMake(0, 55, windowSize.width, windowSize.height-50)];
        commentsTbl.delegate=self;
        commentsTbl.dataSource=self;
        commentsTbl.separatorStyle=UITableViewCellSeparatorStyleNone;
    if (cmtTextArr.count>3) {
        commentsTbl.scrollEnabled=YES;
    }

    [self.view addSubview:commentsTbl];

}


#pragma mark- Tableview delegate methods


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Follow";
    
    TableCustomCell *cell =(TableCustomCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[TableCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
   
        
        CGFloat   height = [self labelHeightWithText:[cmtTextArr objectAtIndex:indexPath.row]];
        if (height<75) {
            height=75;
        }
        cell.jokeTxtView.frame=CGRectMake(80, 20, windowSize.width-120, height);
        cell.jokeTxtView.text=[cmtTextArr objectAtIndex:indexPath.row];
        cell.jokeTxtView.backgroundColor=[UIColor clearColor];
        
        cell.commentBtn.hidden=YES;
        
        NSURL * url=[NSURL URLWithString:[cmtUserImgArr objectAtIndex:indexPath.row]];
        [cell.cmtUserImage sd_setImageWithURL:url];
        cell.add_minusButton.hidden=YES;
        cell.cmtUserName.text=[cmtUserName objectAtIndex:indexPath.row];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}



-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
        if (cmtTextArr.count<1) {
            return 0;
        }
        return cmtTextArr.count;
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
       // set dynamic height of row
       CGFloat height = [self labelHeightWithText:[cmtTextArr objectAtIndex:indexPath.row]];
        if (height<100) {
            height=100;
        }
   
    
    return height;
}


//Find dynamic heght of row

-(CGFloat)labelHeightWithText:(NSString *)text{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    label.numberOfLines = 0;
    label.textAlignment=NSTextAlignmentCenter;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.frame = CGRectMake(0, 0, 280, 100);
    [label sizeToFit];
    // CGSize size  = [label sizeThatFits:CGSizeMake(280, FLT_MAX)];
    return label.frame.size.height;
}




// api call for fetching all commenets of selected feed on the basis of feed Id 
-(void)fetchComments:(NSString *)capId{
    NSError * error;
    NSURLResponse * urlResponse;
    
    cmtTextArr=[[NSMutableArray alloc]init];
    cmtUserImgArr=[[NSMutableArray alloc]init];
    cmtUserName=[[NSMutableArray alloc]init];
    
    NSString * accessToken=[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"];
    
    
    NSURL * getUrl=[NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/media/%@/comments?access_token=%@",capId,accessToken]];
    
    NSMutableURLRequest * request=[[NSMutableURLRequest alloc]initWithURL:getUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:50];
    
    [request setHTTPMethod:@"GET"];
    [request addValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSData * data=[NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    if (!data) {
        return;
    }
    id json=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSLog(@"Data for comments %@",json);
    
    NSArray * cmtDataArr=[json objectForKey:@"data"];
    NSMutableDictionary * cmtTextDic=[NSMutableDictionary dictionary];
    NSMutableDictionary * cmtFromDic=[NSMutableDictionary dictionary];
    for (int i=0; i<cmtDataArr.count; i++) {
        cmtTextDic=[cmtDataArr objectAtIndex:i];
        [cmtTextArr addObject:[cmtTextDic objectForKey:@"text"]];
        
        cmtFromDic=[cmtTextDic objectForKey:@"from"];
        [cmtUserName addObject:[cmtFromDic objectForKey:@"username"]];
        [cmtUserImgArr addObject:[cmtFromDic objectForKey:@"profile_picture"]];
        
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
