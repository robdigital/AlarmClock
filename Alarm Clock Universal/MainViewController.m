//
//  MainViewController.m
//  Alarm Clock Universal
//
//  Created by Rob Miller on 12-08-29.
//  Copyright (c) 2012 XEA. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize flipsidePopoverController = _flipsidePopoverController;
@synthesize tableView = _tableView;
@synthesize dateTimePicker = _dateTimePicker;
@synthesize eventText = _eventText;



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.dateTimePicker.date = [NSDate date];
    //Add self as an observer that will respond to 'reloadData'
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadEvents:) name:@"reloadData" object:nil];
    
}

- (void)viewDidUnload
{
    self.dateTimePicker = nil;
    self.tableView = nil;
    self.eventText = nil;
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

#pragma mark - Flipside View Controller

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissModalViewControllerAnimated:YES];
    } else {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.flipsidePopoverController = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
            self.flipsidePopoverController = popoverController;
            popoverController.delegate = self;
        }
    }
}

- (IBAction)togglePopover:(id)sender
{
    if (self.flipsidePopoverController) {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    } else {
        [self performSegueWithIdentifier:@"showAlternate" sender:sender];
    }
}

// Reload Menu Data/View if Notification received
- (void)reloadEvents:(NSNotification *)note
{
    [self.tableView reloadData];
}


#pragma mark - Alarm Functions

- (void) scheduleLocalNotificationWithDate:(NSDate *)fireDate :(NSString *)message
{
    UILocalNotification *notificaiton = [[UILocalNotification alloc] init];
    if (notificaiton == nil)
        return;
    notificaiton.fireDate = fireDate;
    notificaiton.alertBody = message;
    notificaiton.timeZone = [NSTimeZone defaultTimeZone];
   notificaiton.alertAction = @"View";
    notificaiton.soundName = @"alarm-clock-1.mp3";
    notificaiton.applicationIconBadgeNumber = 1;
    notificaiton.repeatInterval = kCFCalendarUnitWeekday;
    NSLog(@"repeat interval is %@",notificaiton.description);
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notificaiton];
    
   // [self.tableView reloadData];
}

- (IBAction)alarmSetButtonTapped:(id)sender 
{
   [self.eventText resignFirstResponder];
    
    //NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    
   
    //SEL mySelector = @selector(presentMessage:alertMSG);
    NSDateFormatter  *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone defaultTimeZone];
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    
    NSString *dateTimeString = [dateFormatter stringFromDate:self.dateTimePicker.date];
    NSLog(@"alarm Set Button was Tapped : %@", dateTimeString);
    NSString *alertMSG = [NSString stringWithFormat:@"%@\n %@",self.eventText.text, dateTimeString];
    [self presentMessage:alertMSG];
    
    
}

- (IBAction)alarmCancelButtonTapped:(id)sender 
{
    NSLog(@"alarm Cancel Button was Tapped");
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [self.tableView reloadData];
    //[self presentMessage:@"All Alarms Cancelled!"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cancel all Alarms" message:@"All alarms have been canceled." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    //[alert addButtonWithTitle:@"Yes"];
    // [self.tableView reloadData];
    [alert show];
}

- (void) presentMessage:(NSString *)message 
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Set this Alarm?" message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
    [alert addButtonWithTitle:@"Yes"];
    // [self.tableView reloadData];
    [alert show];
    //[alert performSelector:@selector(show) withObject:nil afterDelay:0.1];
   
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==1)
    {
        NSDateFormatter  *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeZone = [NSTimeZone defaultTimeZone];
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
        dateFormatter.dateStyle = NSDateFormatterShortStyle;
        
        NSString *dateTimeString = [dateFormatter stringFromDate:self.dateTimePicker.date];
        NSLog(@"alarm Set Button was Tapped : %@", dateTimeString);
        //NSString *alertMSG = [NSString stringWithFormat:@"Alarm Set!\n %@",dateTimeString];
        
        [self scheduleLocalNotificationWithDate:self.dateTimePicker.date :[self.eventText text]];
        //[self.tableView reloadData];
        [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.0];
    }
}

#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // We only have one section
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of notifications
    NSLog(@"how many notifications? = %u", [[[UIApplication sharedApplication] scheduledLocalNotifications] count]);
    return [[[UIApplication sharedApplication] scheduledLocalNotifications] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Get list of local notifications
    NSArray *notificationArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
    UILocalNotification *notif = [notificationArray objectAtIndex:indexPath.row];
    
    // Display notification info
    [cell.textLabel setText:notif.alertBody];
    
    NSDateFormatter  *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone defaultTimeZone];
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    
    NSString *dateTimeString = [dateFormatter stringFromDate:notif.fireDate];
    [cell.detailTextLabel setText:dateTimeString];
    
    return cell;
}

@end
