//
//  ViewController.m
//  RSSFeedReaderAssessment
//
//  Created by Ramakrishna Makkena on 4/20/16.
//  Copyright © 2016 Ramakrishna Makkena. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"


NSString *const RSS_FEED_URL = @"http://news.google.com/?output=rss";
NSString *const kRSSFeedProperties = @"rfprops";
NSString *const  kTitle = @"title";
NSString *const  kDescription = @"description";
NSString *const  kCellIdentifier = @"RSSFeedCell";

@interface ViewController ()

@property (nonatomic, strong) NSMutableDictionary *dictData;
@property (nonatomic,strong) NSMutableString *XMLString;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    flag = 0;
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self deletePlist];
    [self retrieveFromProperties];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TableViewDelegate and DataSource Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.XMLDataArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    }
    cell.textLabel.text = [[[self.XMLDataArray objectAtIndex:indexPath.row] valueForKey:kTitle] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    cell.detailTextLabel.text = [[[self.XMLDataArray objectAtIndex:indexPath.row] valueForKey:kDescription] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    detailVC.rssNewsFeedData = [[self XMLDataArray] objectAtIndex:indexPath.row];
    [defaults setObject:detailVC.rssNewsFeedData forKey:@"myData"];
    [defaults synchronize];
}

#pragma mark HelperMethods
-(void)startParsing
{
    NSURL *rssFeedURL = [NSURL URLWithString:RSS_FEED_URL];
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:rssFeedURL];
    [xmlParser setDelegate:self];
    [xmlParser parse];
    if (self.XMLDataArray.count != 0) {
        [self.tableView reloadData];
    }
}

#pragma mark Data Persistence Methods.
-(NSURL *)newsFeedPath
{
    NSURL * docDirectory = [[[NSFileManager defaultManager]
                             URLsForDirectory:NSDocumentDirectory
                             inDomains:NSUserDomainMask] lastObject];
    NSURL * newsFeedPath = [docDirectory URLByAppendingPathComponent:(NSString *)kRSSFeedProperties];
    return  newsFeedPath;
}


-(void)saveFeed
{
    [[self XMLDataArray] writeToURL:[self newsFeedPath] atomically:YES];
    
}

//To retrive the Data from Prperties
-(void)retrieveFromProperties
{
    NSData * newsFeedData = [NSData dataWithContentsOfURL:[self newsFeedPath]];
    
    if(newsFeedData != nil)
    {
        NSLog(@"Retrives data from properties");
        NSMutableArray * newsFeeds = [NSPropertyListSerialization propertyListWithData:newsFeedData options:NSPropertyListMutableContainers format:nil error:nil];
        [self setXMLDataArray:(NSMutableArray *)[NSArray arrayWithArray:newsFeeds]];
    }
    else{
        NSLog(@"Retrieving from internet because no persisted stories were found");
        [self startParsing];
        [self saveFeed];
    }
    
}

//To delete the list
-(void)deletePlist
{
    [[NSFileManager defaultManager]removeItemAtURL:[self newsFeedPath] error:nil];
}


#pragma mark NSXMLParserDelegate Methods
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict;
{
    if ([elementName isEqualToString:@"rss"]) {
        self.XMLDataArray = [[NSMutableArray alloc] init];
        self.XMLPartDict = [[NSMutableDictionary alloc] init];
    }

}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string;
{
    if (!self.XMLString) {
        self.XMLString = [[NSMutableString alloc] initWithString:string];
    }
    else {
        [self.XMLString appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName;
{
    if ([elementName isEqualToString:kTitle]
        || [elementName isEqualToString:kDescription]) {
        [self.XMLPartDict setObject:self.XMLString forKey:elementName];
    }
    if ([elementName isEqualToString:kDescription]) {
        [self.XMLDataArray addObject:self.XMLPartDict];
    }
    self.XMLString = nil;
}


@end
