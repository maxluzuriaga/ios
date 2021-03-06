//
//  SNLoginViewController.m
//  STEAMnet
//
//  Created by Max Luzuriaga on 7/15/13.
//  Copyright (c) 2013 Max Luzuriaga. All rights reserved.
//

#import "SNLoginViewController.h"

@interface SNLoginViewController ()

@property(nonatomic, strong) UIWebView *webView;

@end

@implementation SNLoginViewController

@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Log in";
	_webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    NSURL *url = [[NSURL alloc] initWithString:@"http://steamnet.herokuapp.com/auth"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *url = [[[webView request] URL] absoluteString];
    
    if (([url hasPrefix:@"http://steamnet.herokuapp.com/auth"]) && ([url rangeOfString:@"callback"].location != NSNotFound)) {
        NSString *token = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('p')[0].innerHTML"];
        NSLog(@"TOKEN: %@", token);
        
        [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:token forKey:@"token"];
        
        [self.delegate didLogIn:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
