//
//  DetailViewController.h
//  RSSFeedReaderAssessment
//
//  Created by Ramakrishna Makkena on 4/21/16.
//  Copyright © 2016 Ramakrishna Makkena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface DetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *feddTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *feedDescription;
@property (nonatomic,copy) NSMutableDictionary *rssNewsFeedData;

@end
