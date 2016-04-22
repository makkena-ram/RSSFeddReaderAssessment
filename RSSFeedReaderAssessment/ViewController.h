//
//  ViewController.h
//  RSSFeedReaderAssessment
//
//  Created by Ramakrishna Makkena on 4/20/16.
//  Copyright © 2016 Ramakrishna Makkena. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const RSS_FEED_URL;
extern NSString *const kRSSFeedProperties;
extern NSString *const kTitle;
extern NSString *const kDescription;
extern NSString *const kCellIdentifier;

@interface ViewController : UIViewController<NSXMLParserDelegate,UITableViewDataSource,UITableViewDelegate>
{
    int flag;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *XMLDataArray;
@property (nonatomic,strong) NSMutableDictionary *XMLPartDict;

@end

