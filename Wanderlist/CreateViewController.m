//
//  CreateViewController.m
//  Wanderlist
//
//  Created by Mark Beylin on 2015-09-19.
//  Copyright © 2015 Mark Beylin. All rights reserved.
//

#import "CreateViewController.h"

@interface CreateViewController ()

@end

@implementation CreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.descriptionText.delegate = self;
    self.lat.text = @"43.452266";
    self.lon.text = @"-80.496338";
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
    // Do any additional setup after loading the view.
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
 
    CLLocation *newLocation = [locations lastObject];
    location = newLocation.coordinate;
    NSLog(@"adding location...");
    NSLog([NSString stringWithFormat:@"%f", location.latitude]);
    NSLog([NSString stringWithFormat:@"%f", location.longitude]);
    self.lat.text = [NSString stringWithFormat:@"%f", location.latitude];
    self.lon.text = [NSString stringWithFormat:@"%f", location.longitude];
    [locationManager stopUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.name) {
        [textField resignFirstResponder];
        [self.time becomeFirstResponder];
    } else if (textField == self.time) {
        [textField resignFirstResponder];
        [self.address becomeFirstResponder];
        
    } else if (textField == self.address) {
        [textField resignFirstResponder];
        [self.descriptionText becomeFirstResponder];
        
    }else if (textField == self.lat) {
        [textField resignFirstResponder];
        [self.lon becomeFirstResponder];
        
    }else if (textField == self.lon) {
        [textField resignFirstResponder];
        return NO;
        
    }
    return YES;
}
-(IBAction)create:(id)sender {
    Event *new = [[Event alloc] init];
    new.name = self.name.text;
    new.time = self.time.text;
    new.address = self.address.text;
    new.descriptionText = self.descriptionText.text;
    [new setLat:[self.lat.text doubleValue]];
    [new setLon:[self.lon.text doubleValue]];
    CLLocation *me = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
    CLLocation *newEvent = [[CLLocation alloc] initWithLatitude:[self.lat.text doubleValue] longitude:[self.lon.text doubleValue]];
    CLLocationDistance distance = [me distanceFromLocation:newEvent];
    distance = distance/1000;
    new.distance = [NSString stringWithFormat:@"%.1f Kilometers away", distance];
    ViewController *root = (ViewController *)[self.navigationController.viewControllers objectAtIndex:0];
    
    [root.events addObject:new];
    [root shareEvent:new];
    [root.eventsTable reloadData];
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
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
