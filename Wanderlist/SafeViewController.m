//
//  SafeViewController.m
//  Wanderlist
//
//  Created by Mark Beylin on 2015-09-20.
//  Copyright © 2015 Mark Beylin. All rights reserved.
//

#import "SafeViewController.h"
#import "Safe.h"

@interface SafeViewController ()

@end

@implementation SafeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"Avenir-Next-Medium" size:21],
      NSFontAttributeName, nil]];
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
        [self.address becomeFirstResponder];
        
    } else if (textField == self.address) {
        [textField resignFirstResponder];
        
    }else if (textField == self.lat) {
        [textField resignFirstResponder];
        [self.lon becomeFirstResponder];
        
    }else if (textField == self.lon) {
        [textField resignFirstResponder];
        return NO;
        
    }
    return YES;
}
-(IBAction)safeSend:(id)sender {
    Safe *new = [[Safe alloc] init];
    new.name = self.name.text;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm:ssZZZ";
    new.time = [formatter stringFromDate:[NSDate date]];
    new.location = self.address.text;
    
    new.coordinates = [NSString stringWithFormat:@"%@, %@", self.lat.text, self.lon.text];

    ViewController *root = (ViewController *)[self.navigationController.viewControllers objectAtIndex:0];
    [root sendSafe: new];
    
    
    [self.navigationController popViewControllerAnimated:YES];
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
