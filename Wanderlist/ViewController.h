//
//  ViewController.h
//  Wanderlist
//
//  Created by Mark Beylin on 2015-09-19.
//  Copyright © 2015 Mark Beylin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PLPartyTime.h"
#import "Event.h"
#import <QuartzCore/QuartzCore.h>
#import "EventTableViewCell.h"
#import <CoreLocation/CoreLocation.h>
#import <Firebase/Firebase.h>
#import "Safe.h"

@interface ViewController : UIViewController <PLPartyTimeDelegate, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
    CLLocationCoordinate2D location;
}


@property (strong, nonatomic) PLPartyTime *partyTime;
@property (strong, nonatomic) IBOutlet UILabel *errorMessage;
@property (strong, nonatomic) IBOutlet UILabel *peerCount;
@property (strong, nonatomic) NSMutableArray *events;
@property (strong, nonatomic) IBOutlet UITableView *eventsTable;
@property (strong, nonatomic) Firebase *ref;
@property (strong, nonatomic) IBOutlet UILabel *peerGrammar;


- (void)partyTime:(PLPartyTime *)partyTime peer:(MCPeerID *)peer changedState:(MCSessionState)state currentPeers:(NSArray *)currentPeers;
- (void)shareEvent: (Event *)event;
- (void)sendSafe: (Safe *) newSafe ;
@end
