//
//  DetailViewController.m
//  RSSFeedReaderAssessment
//
//  Created by Ramakrishna Makkena on 4/21/16.
//  Copyright © 2016 Ramakrishna Makkena. All rights reserved.
//

#import "DetailViewController.h"
#import "ViewController.h"


@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.rssNewsFeedData = [defaults objectForKey:@"myData"];
    
    self.feddTitleLabel.text = [self.rssNewsFeedData valueForKey:kTitle];
    self.feedDescription.text = [self.rssNewsFeedData valueForKey:kDescription];
    // Do any additional setup after loading the view.
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
