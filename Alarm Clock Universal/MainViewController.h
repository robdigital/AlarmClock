//
//  MainViewController.h
//  Alarm Clock Universal
//
//  Created by Rob Miller on 12-08-29.
//  Copyright (c) 2012 XEA. All rights reserved.
//

#import "FlipsideViewController.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, UIPopoverControllerDelegate, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
{
    
    
}
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;

@property (nonatomic, strong) IBOutlet UIDatePicker *dateTimePicker;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITextField *eventText;

- (void) presentMessage: (NSString *) message;
- (void) scheduleLocalNotificationWithDate: (NSDate *) fireDate: (NSString *) message;
- (IBAction)alarmSetButtonTapped:(id)sender;
- (IBAction)alarmCancelButtonTapped:(id)sender;

@end
