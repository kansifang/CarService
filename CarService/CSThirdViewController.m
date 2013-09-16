//
//  CSThirdViewController.m
//  CarService
//
//  Created by baidu on 13-9-14.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import "CSThirdViewController.h"
#import "CSInsuranceViewController.h"
#import "CSCarCareViewController.h"
#import "CSDelegateServiceViewController.h"
#import "CSReportCaseViewController.h"

@interface CSThirdViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    
}

@end

@implementation CSThirdViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)init_selfView
{
    float x, y, width, height;
    x=0; y=0; width=320;
    if (Is_iPhone5) {
        height=1136/2.0;
    }else{
        height=960/2.0;
    }
    //背景
    UIImageView* bgImageView=[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    if (Is_iPhone5) {
        [bgImageView setImage:[UIImage imageNamed:@"bg_iphone5.png"]];
    }else{
        [bgImageView setImage:[UIImage imageNamed:@"bg_iphone4.png"]];
    }
    [self.view addSubview:bgImageView];
    [self.view sendSubviewToBack:bgImageView];
    [bgImageView release];
}

//创建详情列表
-(void)initSetUpTableView:(CGRect)frame{
	UITableView *aTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    [aTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
	[aTableView setSeparatorColor:[UIColor clearColor]];
	[aTableView setBackgroundColor:[UIColor clearColor]];
	[aTableView setShowsVerticalScrollIndicator:YES];
	[aTableView setDelegate:self];
	[aTableView setDataSource:self];
	[self.view addSubview:aTableView];
    [aTableView release];
    
    UIView *foot = [[UIView alloc] initWithFrame:CGRectZero];
	aTableView.tableFooterView = foot;
	[foot release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor scrollViewTexturedBackgroundColor];
    [ApplicationPublic selfDefineNaviBar:self.navigationController.navigationBar];
    self.navigationItem.title=@"服务中心";
    [self init_selfView];
    [self initSetUpTableView:self.view.bounds];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

//创建详细信息的Label
-(void)createViewForcell:(UITableViewCell*)cell atRow:(NSIndexPath *)indexPath{
    
    float x, y, width, height;
    
    x=50; y=20; width=320-50*2; height=89/2.0;
    UIButton* bgBtn=[[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [bgBtn setTag:100+indexPath.row];
    [bgBtn setBackgroundColor:[UIColor clearColor]];
    [bgBtn setShowsTouchWhenHighlighted:YES];
    [bgBtn addTarget:self action:@selector(bgBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:bgBtn];
    [bgBtn release];
    
    x=50; y=20; width=110/2.0; height=89/2.0;
    UIImageView* imageView=[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [imageView setTag:1001];
    [cell.contentView addSubview:imageView];
    [imageView release];
    
    x=x+width+20; width=110;
    UILabel* textLabel=[[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [textLabel setTag:1002];
    [textLabel setBackgroundColor:[UIColor clearColor]];
    [textLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
    [textLabel setTextAlignment:UITextAlignmentLeft];
    [textLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
    [textLabel setTextColor:[UIColor whiteColor]];
    [cell.contentView addSubview:textLabel];
    [textLabel release];
    
    width=540/2.0; height=7/2.0; x=(CGRectGetWidth(cell.bounds)-width)/2.0; y=20+89/2.0+5-height;
    UIImageView* lineImageView=[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    lineImageView.image=[UIImage imageNamed:@"dianputuijian_line.png"];
    [cell.contentView addSubview:lineImageView];
    [lineImageView release];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        //添加视图
        [self createViewForcell:cell atRow:indexPath];
    }
    
    UIImageView* imageView=(UIImageView*)[cell.contentView viewWithTag:1001];
    UILabel* textLabel=(UILabel*)[cell.contentView viewWithTag:1002];
    if (imageView && textLabel) {
        switch (indexPath.row) {
            case 0:
            {
                imageView.image=[UIImage imageNamed:@"fuwuzhongxin_insurance.png"];
                textLabel.text=@"车辆保险";
            }
                break;
            case 1:
            {
                imageView.image=[UIImage imageNamed:@"fuwuzhongxin_care.png"];
                textLabel.text=@"车辆保养";
            }
                break;
            case 2:
            {
                imageView.image=[UIImage imageNamed:@"fuwuzhongxin_delegateservice.png"];
                textLabel.text=@"代维服务";
            }
                break;
            case 3:
            {
                imageView.image=[UIImage imageNamed:@"fuwuzhongxin_reportcase.png"];
                textLabel.text=@"事故报案";
            }
                break;

            default:
                break;
        }
    }
        
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 25+89/2.0;
}


-(void)bgBtnClicked:(UIButton*)sender
{
    [self pushViewController:sender.tag-100];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self pushViewController:indexPath.row];
}

-(void)pushViewController:(int)index
{
    switch (index) {
        case 0:
        {
            CSInsuranceViewController* ctrler=[[CSInsuranceViewController alloc] init];
            [self.navigationController pushViewController:ctrler animated:YES];
            [ctrler release];
        }
            break;
        case 1:
        {
            CSCarCareViewController* ctrler=[[CSCarCareViewController alloc] init];
            [self.navigationController pushViewController:ctrler animated:YES];
            [ctrler release];
        }
            break;
        case 2:
        {
            CSDelegateServiceViewController* ctrler=[[CSDelegateServiceViewController alloc] init];
            [self.navigationController pushViewController:ctrler animated:YES];
            [ctrler release];
        }
            break;
        case 3:
        {
            CSReportCaseViewController* ctrler=[[CSReportCaseViewController alloc] init];
            [self.navigationController pushViewController:ctrler animated:YES];
            [ctrler release];
        }
            break;
            
        default:
            break;
    }
}

@end