//
//  StockQuoteViewController.h
//  StockQuote
//
//  Created by Justin Chan on 2012-08-21.
//  Copyright (c) 2012 PufferStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StockQuoteViewController : UIViewController

+ (double)fetchQuotesFor:(NSString *)tickers onDate:(NSString *)date;
@property (weak, nonatomic) IBOutlet UITextField *PriceDisplay;
@property (weak, nonatomic) IBOutlet UITextField *StockTicker;
@property (weak, nonatomic) IBOutlet UITextField *dateString;
@end
