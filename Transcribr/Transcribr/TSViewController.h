//
//  TSViewController.h
//  Transcribr
//
//  Created by Herbert Yeung on 10/12/12.
//  Copyright (c) 2012 becontactable. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MAX_TIME 1800 //30 minutes = 1800 seconds

@interface TSViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *TimeLeftLabel;

- (IBAction)recordAction:(id)sender;

@end
