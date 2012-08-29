//
//  MainViewController.h
//  Alarm Clock Universal
//
//  Created by Rob Miller on 12-08-29.
//  Copyright (c) 2012 XEA. All rights reserved.
//

#import "FlipsideViewController.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, UIPopoverControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;

@end
