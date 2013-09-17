//
//  CSCommentViewController.m
//  CarService
//
//  Created by baidu on 13-9-17.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import "CSCommentViewController.h"
#import "ASIHTTPRequest.h"

@interface CSCommentViewController ()

@property (nonatomic,retain) IBOutlet UILabel *textPlaceHolderLabel;
@property (nonatomic,retain) IBOutlet UITextView *textView;
@property (nonatomic,retain) IBOutlet UIButton *firstStarView;
@property (nonatomic,retain) IBOutlet UIButton *secondStarView;
@property (nonatomic,retain) IBOutlet UIButton *thirdStarView;
@property (nonatomic,retain) IBOutlet UIButton *forthStarView;
@property (nonatomic,retain) IBOutlet UIButton *fifthStarView;
@property (nonatomic,assign) int currentRateStar;
@property (nonatomic,retain) NSArray *rateButtonArray;
@property (nonatomic,retain) ASIHTTPRequest *commentRequest;

@end

@implementation CSCommentViewController
@synthesize textPlaceHolderLabel;
@synthesize textView;
@synthesize firstStarView;
@synthesize secondStarView;
@synthesize thirdStarView;
@synthesize forthStarView;
@synthesize fifthStarView;
@synthesize currentRateStar;
@synthesize rateButtonArray;
@synthesize commentRequest;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.currentRateStar = 4;
    }
    return self;
}

- (void)dealloc
{
    [textPlaceHolderLabel release];
    [textView release];
    [firstStarView release];
    [secondStarView release];
    [thirdStarView release];
    [forthStarView release];
    [fifthStarView release];
    [rateButtonArray release];
    [commentRequest clearDelegatesAndCancel];
    [commentRequest release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.leftBarButtonItem = [self getBackItem];
    self.navigationItem.title = @"我要点评";
    
    self.rateButtonArray = [NSArray arrayWithObjects:self.firstStarView,self.secondStarView,self.thirdStarView,self.forthStarView,self.fifthStarView, nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)commentButtonPressed:(id)sender
{
    [self.commentRequest clearDelegatesAndCancel];
    self.commentRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:URL_comment]];
    [commentRequest setShouldAttemptPersistentConnection:NO];
    [commentRequest setValidatesSecureCertificate:NO];
    
    [commentRequest setDelegate:self];
    [commentRequest setDidFinishSelector:@selector(editingRequestDidFinished:)];
    [commentRequest setDidFailSelector:@selector(editingRequestDidFailed:)];
    [commentRequest startAsynchronous];
    [self showActView:UIActivityIndicatorViewStyleWhite];
}

- (void)editingRequestDidFinished:(ASIHTTPRequest *)request
{
    CustomLog(@"%@",[request responseString]);
    [self hideActView];
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *responseString = [[[[[[NSString alloc] initWithData:[request responseData] encoding:encoding]autorelease] stringByReplacingOccurrencesOfString:@"\r" withString:@""] stringByReplacingOccurrencesOfString:@"\t" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSDictionary *requestDic = [responseString JSONValue];
    CustomLog(@"login request request dic:%@",requestDic);
    if (nil == [requestDic objectForKey:@"code"] || ![[requestDic objectForKey:@"code"] isEqualToString:@"0"])
    {
        [[Util sharedUtil] showAlertWithTitle:@"" message:@"修改失败，请稍后重试!"];
        return;
    }
    else
    {
        
    }
    
}

- (void)editingRequestDidFailed:(ASIHTTPRequest *)request
{
    [[Util sharedUtil] showAlertWithTitle:@"" message:@"修改失败，请检查网络连接!"];
    return;
    CustomLog(@"%@",[request responseString]);
}

- (IBAction)starButtonPressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    self.currentRateStar = button.tag + 1;
    for (int i = 0; i < 5; i ++)
    {
        UIButton *tempButton = (UIButton *)[self.rateButtonArray objectAtIndexWithCheck:i];
        if (i <= button.tag)
        {
            [tempButton setBackgroundImage:[UIImage imageNamed:@"comment_highlight_star.png"] forState:UIControlStateNormal];
        }
        else
        {
            [tempButton setBackgroundImage:[UIImage imageNamed:@"comment_normal_star.png"] forState:UIControlStateNormal];
        }
    }
}

#pragma mark - UITextViewDelegate Methods

- (void)textViewDidChange:(UITextView *)textView
{
    int length = [self.textView.text length];
    if (length == 0)
    {
        self.textPlaceHolderLabel.hidden = NO;
    }
    else
    {
        self.textPlaceHolderLabel.hidden = YES;
    }
}

@end