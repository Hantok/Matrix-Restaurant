//
//  SocialViewController.m
//  Restaurant
//
//  Created by Matrix Soft on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SocialViewController.h"

@interface SocialViewController ()

@end

@implementation SocialViewController
@synthesize SocialWebView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //NSLog(@"URL is %@", [[NSUserDefaults standardUserDefaults] valueForKey:@"social"]);
    self.SocialWebView.scalesPageToFit = YES;
    [self.SocialWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:@"social"]]]];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setSocialWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main vie
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
