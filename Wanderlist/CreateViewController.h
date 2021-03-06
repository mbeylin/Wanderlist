//
//  CreateViewController.h
//  Wanderlist
//
//  Created by Mark Beylin on 2015-09-19.
//  Copyright © 2015 Mark Beylin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ViewController.h"
#import "Event.h"

@interface CreateViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, CLLocationManagerDelegate> {
    CLLocationCoordinate2D location;
    CLLocationManager *locationManager;

}


@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UITextField *time;
@property (strong, nonatomic) IBOutlet UITextField *address;
@property (strong, nonatomic) IBOutlet UITextView *descriptionText;
@property (strong, nonatomic) IBOutlet UITextField *lat;
@property (strong, nonatomic) IBOutlet UITextField *lon;


@end
