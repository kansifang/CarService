//
//  ChangePasswordController.m
//  iGuanZhong
//
//  Created by zhouochengyu on 13-8-24.
//  Copyright (c) 2013年 zhouochengyu. All rights reserved.
//

#import "ChangePasswordController.h"
#import "ASIFormDataRequest.h"
#import "CSAppDelegate.h"
#import "Util.h"
#import "NSString+SBJSON.h"
#import "URLConfig.h"

@interface ChangePasswordController ()

@property (nonatomic,retain) IBOutlet UIView *backView;
@property (nonatomic,retain) IBOutlet UIScrollView *contentScrollView;
@property (nonatomic,retain) IBOutlet UITextField *oldPassField;
@property (nonatomic,retain) IBOutlet UITextField *changePassField;
@property (nonatomic,retain) IBOutlet UITextField *confirmField;
@property (nonatomic,retain) ASIFormDataRequest *changeRequest;

@end

@implementation ChangePasswordController
@synthesize backView;
@synthesize contentScrollView;
@synthesize oldPassField;
@synthesize changePassField;
@synthesize confirmField;
@synthesize changeRequest;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [contentScrollView release];
    [backView release];
    [oldPassField release];
    [changePassField release];
    [confirmField release];
    [changeRequest clearDelegatesAndCancel];
    [changeRequest release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.leftBarButtonItem = [self getBackItem];
    self.navigationItem.title = @"修改密码";
    self.contentScrollView.contentSize = CGSizeMake(320, self.view.frame.size.height - 40 );
    if (Is_iPhone5)
    {
        // self.inputBackView.frame =
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //点击页面使键盘消失
    UITapGestureRecognizer* tapReconginzer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    tapReconginzer.numberOfTapsRequired = 1;
    tapReconginzer.numberOfTouchesRequired = 1;
    [self.backView addGestureRecognizer:tapReconginzer];
    [tapReconginzer release];

}

- (void)hideKeyBoard
{
    [self.oldPassField resignFirstResponder];
    [self.changePassField resignFirstResponder];
    [self.confirmField resignFirstResponder];
}

- (void)adjustSubView:(int)startY
{
    [UIView animateWithDuration:0.3 animations:^{
        if (Is_iPhone5)
        {
            
        }
        else
        {
            self.backView.frame = CGRectMake(0, startY, 320, self.backView.frame.size.height);
        }
    }];
    
}

#pragma mark KeyBoradNotification

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CustomLog(@"frame:%f,%f,%f,%f",keyboardRect.origin.x,keyboardRect.origin.y,keyboardRect.size.width,keyboardRect.size.height);
    
    if (Is_iPhone5)
    {
        
    }
    else
    {
        /*if ([self.oldPassField isFirstResponder])
        {
            CustomLog(@"Do Nothing");
            [self adjustSubView:0];
        }
        else if ([self.changePassField isFirstResponder])
        {
            [self adjustSubView:-20];
        }
        else if ([self.confirmField isFirstResponder])
        {
            [self adjustSubView:-40];
        }*/
        
    }
    
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    if (Is_iPhone5)
    {
        
    }
    else
    {
       // [self adjustSubView:0];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollView Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self hideKeyBoard];
}

#pragma mark -UITextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField       // became first responder
{
    [UIView animateWithDuration:0.3 animations:^{
        if (Is_iPhone5)
        {
            
        }
        else
        {
           /* if ([self.oldPassField isFirstResponder])
            {
                CustomLog(@"Do Nothing");
                [self adjustSubView:0];
            }
            else if ([self.changePassField isFirstResponder])
            {
                [self adjustSubView:-20];
            }
            else if ([self.confirmField isFirstResponder])
            {
                [self adjustSubView:-40];
            }*/
        }
    }];
    
}

#pragma mark - button click methods

- (IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)changeButtonPressed:(id)sender
{
    if ([self.oldPassField.text length] == 0)
    {
        [[Util sharedUtil] showAlertWithTitle:@"" message:@"请输入旧密码!"];
        return;
    }
    
    if ([self.changePassField.text length] == 0)
    {
        [[Util sharedUtil] showAlertWithTitle:@"" message:@"请输入新密码!"];
        return;
    }
    if (![self.confirmField.text isEqualToString:self.changePassField.text])
    {
        [[Util sharedUtil] showAlertWithTitle:@"" message:@"两次输入密码不一致!"];
        return;
    }
    
    [self.changeRequest clearDelegatesAndCancel];
    self.changeRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_changepassword]];
    [self.changeRequest setRequestMethod:@"POST"];
    [self.changeRequest setPostValue:@"edit" forKey:@"op"];
    [self.changeRequest setPostValue:@"1" forKey:@"type"];
    [self.changeRequest setPostValue:self.oldPassField.text forKey:@"oldPass"];
    [self.changeRequest setPostValue:self.changePassField.text forKey:@"content"];
    self.changeRequest.delegate = self;
    [self.changeRequest setDidFinishSelector:@selector(requestDidFinished:)];
    [self.changeRequest setDidFailSelector:@selector(requestDidFailed:)];
    [self.changeRequest startAsynchronous];
    [self showActView:UIActivityIndicatorViewStyleWhite];
}

- (void)requestDidFinished:(ASIHTTPRequest *)request
{
    [self hideActView];
    NSDictionary *requestDic = [[request responseString] JSONValue];
    CustomLog(@"login request request dic:%@",requestDic);
    if (nil == [requestDic objectForKey:@"code"])
    {
        CustomLog(@"parse error");
        [[Util sharedUtil] showAlertWithTitle:@"" message:@"修改失败，请稍后重试"];
        return;
    }
    else
    {
        int code = [[requestDic objectForKey:@"code"] intValue];
        switch (code) {
            case 0:
                CustomLog(@"修改成功");
                [[Util sharedUtil] showAlertWithTitle:@"提示" message:@"恭喜您，修改成功!"];
                [self.navigationController popToRootViewControllerAnimated:NO];
                break;
            case -4:
                [[Util sharedUtil] showAlertWithTitle:@"" message:@"旧密码不正确,请重新输入!"];
                break;
            case -100:
                /*[[(AppDelegate *)[UIApplication sharedApplication].delegate viewController] logout];
                [[Util sharedUtil] showAlertWithTitle:@"" message:[requestDic objectForKey:@"errorMsg"]];*/

                break;
            default:
                if (nil != [requestDic objectForKey:@"errorMsg"])
                {
                    [[Util sharedUtil] showAlertWithTitle:@"" message:[requestDic objectForKey:@"errorMsg"]];
                }
                else
                {
                    [[Util sharedUtil] showAlertWithTitle:@"" message:@"修改失败,请稍后重试!"];
                }
                break;
        }
    }
}

- (void)requestDidFailed:(ASIHTTPRequest *)request
{
    [self hideActView];
    [[Util sharedUtil] showAlertWithTitle:@"" message:@"修改失败，请检查网络连接"];
}

@end