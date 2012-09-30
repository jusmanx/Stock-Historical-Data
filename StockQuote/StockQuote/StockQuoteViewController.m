//
//  StockQuoteViewController.m
//  StockQuote
//
//  Created by Justin Chan on 2012-08-21.
//  Copyright (c) 2012 PufferStudio. All rights reserved.
//

#import "StockQuoteViewController.h"
#define QUOTE_QUERY_PREFIX @"http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.historicaldata%20where%20symbol%3D%22"
#define QUOTE_QUERY_SUFFIX1 @"%22%20and%20startDate%3D%22"
#define QUOTE_QUERY_SUFFIX2 @"%22%20and%20endDate%20%3D%22"
#define QUOTE_QUERY_SUFFIX3 @"%22&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="

@interface StockQuoteViewController ()

@end

@implementation StockQuoteViewController
@synthesize PriceDisplay;
@synthesize StockTicker;
@synthesize dateString;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setPriceDisplay:nil];
    [self setStockTicker:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (IBAction)UpdateTicker
{
    //NSString *date =@"2012-09-14";
    double stockPrice = [StockQuoteViewController fetchQuotesFor:StockTicker.text onDate:dateString.text];
    PriceDisplay.text = [NSString stringWithFormat:@"%f", stockPrice];
}

+ (double) fetchQuotesFor:(NSString *)ticker onDate:(NSString *)date
{
    double stockPrice;
    if (ticker)
    {
        NSMutableString *query = [[NSMutableString alloc] init];
        
        [query appendString:QUOTE_QUERY_PREFIX];
        [query appendString:ticker];
        [query appendString:QUOTE_QUERY_SUFFIX1];
        [query appendString:date];
        [query appendString:QUOTE_QUERY_SUFFIX2];
        [query appendString:date];
        [query appendString:QUOTE_QUERY_SUFFIX3];
        
        NSError      *error    = nil;
        NSData       *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:query]
                                            encoding:NSUTF8StringEncoding error:nil]
                                            dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *results  = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error] : nil;
        
        if (error)
            NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
        
        NSArray        *rawQueryString   = [results allValues];
        NSString       *rawResultsString = [rawQueryString description];
        NSScanner      *scanner          = [NSScanner scannerWithString:rawResultsString];
        NSMutableArray *target           = [NSMutableArray array];
        
        while ([scanner isAtEnd] == NO)
        {
            NSString *temp;
            
            [scanner scanUpToString:@"Close" intoString:NULL];
            [scanner scanUpToString:@"=" intoString:NULL];
            [scanner scanString:@"=" intoString:NULL];
            [scanner scanString:@"\"" intoString:NULL];
            [scanner scanUpToString:@"\"" intoString:&temp];
            
            if ([scanner isAtEnd] == NO)
                [target addObject:temp];
            [scanner scanString:@"\"" intoString:NULL];

        }
        
        NSString *priceString = [target lastObject];
        stockPrice = [priceString doubleValue];
    }
    return stockPrice;
}

@end
