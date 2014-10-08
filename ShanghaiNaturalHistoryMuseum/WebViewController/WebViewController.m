//
//  WebViewController.m
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Michael Lu on 14-9-25.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController () <UIWebViewDelegate>{
    IBOutlet UIWebView *myWebView;
    IBOutlet UIActivityIndicatorView *hud;
}

@end

@implementation WebViewController

@synthesize urlString;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configNavigationBar];
    
    myWebView.delegate=self;
    //去掉前后空格
    urlString = [urlString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [myWebView loadRequest:request];
}


#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {

}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [hud stopAnimating];
}



#pragma mark - Navigation Bar
- (void)configNavigationBar
{
    
    CustomNavigationController *nav = (CustomNavigationController *)self.navigationController;
    nav.subTopTitle = nil;
    nav.subBottomTitle = nil;
    
    FRDLivelyButton *menuBt = [[FRDLivelyButton alloc] initWithFrame:CGRectMake(0, 0, kNavButtonItemWidth, kNavButtonItemHeight)];
    [menuBt setStyle:kFRDLivelyButtonStyleArrowLeft animated:NO];
    [menuBt addTarget:self action:@selector(onMenuBt:) forControlEvents:UIControlEventTouchUpInside];
    [menuBt setOptions:@{kFRDLivelyButtonLineWidth:@3.0f, kFRDLivelyButtonColor: Color(206.f, 206.0f, 206.0f, 1.0f)}];
    nav.barButton = menuBt;
}
- (void)onMenuBt:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - StatusBar
//ios7 隐藏StatusBar
- (BOOL)prefersStatusBarHidden
{
    return YES;
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
