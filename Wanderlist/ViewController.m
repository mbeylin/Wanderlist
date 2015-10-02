//
//  ViewController.m
//  Wanderlist
//
//  Created by Mark Beylin on 2015-09-19.
//  Copyright © 2015 Mark Beylin. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.events = [[NSMutableArray alloc] init];
    self.ref = [[Firebase alloc] initWithUrl:@"https://sweltering-fire-6769.firebaseio.com/"];
    location.latitude = 43.452266;
    location.longitude = -80.496338;
    self.peerCount.text = @"0";
    [self.ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSLog(@"%@", snapshot.value);
        NSDictionary *snapshotDict = (NSDictionary *) snapshot.value;
        
        NSArray *snapshotKeys = [snapshotDict allKeys];
        
        
        for (int i = 0; i < snapshotKeys.count; i++) {
            if (! [(NSString *)[snapshotKeys objectAtIndex:i] isEqualToString:@"Safe"]) {
                Event *newEvent = [[Event alloc] init];
                NSDictionary *eventDict = [snapshotDict objectForKey: [snapshotKeys objectAtIndex:i]];
            
                
                newEvent.name = [eventDict objectForKey:@"Name"];
                newEvent.descriptionText = [eventDict objectForKey:@"Description"];
                newEvent.address = [eventDict objectForKey:@"Location"];
                newEvent.time = [eventDict objectForKey:@"Time"];
                NSArray* coord = [[eventDict objectForKey:@"Coordinates"] componentsSeparatedByString: @", "];
                [newEvent setLat: [(NSString *)[coord objectAtIndex:0] doubleValue]];
                [newEvent setLon: [(NSString *)[coord objectAtIndex:1] doubleValue]];
                if (![self.events containsObject:newEvent]) {
                    CLLocation *me = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
                    CLLocation *new = [[CLLocation alloc] initWithLatitude:[newEvent getLat] longitude:[newEvent getLon]];
                    CLLocationDistance distance = [me distanceFromLocation:new];
                    NSLog(@"ME Lat: %f, Lon: %f", location.latitude,location.longitude);
                    NSLog(@"NEW Lat: %f, Lon: %f", [newEvent getLat],[newEvent getLon]);
                    distance = distance/1000;
                    newEvent.distance = [NSString stringWithFormat:@"%.1f Kilometers away", distance];
                    [self.events addObject:newEvent];
                    NSDictionary *dictionary = @{@"sentData": @[newEvent]};
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dictionary];
                    [self.partyTime sendData:data
                                    withMode:MCSessionSendDataReliable
                                       error:nil];
                }
            }
            
        }
        [self.eventsTable reloadData];
    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
    
   
   
    
    self.partyTime = [[PLPartyTime alloc] initWithServiceType: @"Wanderlist-Peer"];
    self.partyTime.delegate = self;
    [self.partyTime joinParty];
    //[self.eventsTable reloadData];
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
    [locationManager stopUpdatingLocation];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)refresh:(id)sender {
    /*
     NSDictionary *dictionary = @{@"requireData": self.partyTime.peerID};
     NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dictionary];
     [self.partyTime sendData:data
     withMode:MCSessionSendDataReliable
     error:nil];
     */
    NSLog(@"refreshing");
    [self.partyTime leaveParty];
    [self.partyTime joinParty];
}





#pragma mark - Party Time Delegate

- (void)partyTime:(PLPartyTime *)partyTime
   didReceiveData:(NSData *)data
         fromPeer:(MCPeerID *)peerID
{
    NSLog(@"Received some data!");
    NSDictionary *newData = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSArray *keys= [newData allKeys];
    if (keys.count != 0) {
        for (int i = 0; i < keys.count; i++){
            if ([[keys objectAtIndex:i] isEqualToString:@"requireData"] && ([self.events count] != 0)) {
                MCPeerID *seeder = (MCPeerID *)[newData objectForKey:[keys objectAtIndex:i]];
                
                NSDictionary *dictionary = @{@"sentData": self.events};
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dictionary];
                [self.partyTime sendData:data
                                 toPeers:@[ seeder ]
                                withMode:MCSessionSendDataReliable
                                   error:nil];
                
            } else if ([[keys objectAtIndex:i] isEqualToString:@"sentData"]) {
                NSArray *newEvents = (NSArray *)[newData objectForKey:[keys objectAtIndex:i]];
                for (int j = 0; j < newEvents.count; j++) {
                    
                    if (![self.events containsObject:[newEvents objectAtIndex:j]]) {
                        
                        Event *newEvent = [newEvents objectAtIndex:j];
                        CLLocation *me = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
                        CLLocation *new = [[CLLocation alloc] initWithLatitude:[newEvent getLat] longitude:[newEvent getLon]];
                        CLLocationDistance distance = [me distanceFromLocation:new];
                        NSLog(@"ME Lat: %f, Lon: %f", location.latitude,location.longitude);
                        NSLog(@"NEW Lat: %f, Lon: %f", [newEvent getLat],[newEvent getLon]);
                        distance = distance/1000;
                        newEvent.distance = [NSString stringWithFormat:@"%.1f Kilometers away", distance];
                        [self.events addObject:newEvent];
                        
                        NSMutableArray *newPeers = [[NSMutableArray alloc] initWithArray:self.events];
                        [newPeers removeObject: peerID];
                        NSDictionary *dictionary = @{@"sentData": @[newEvent]};
                        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dictionary];
                        [self.partyTime sendData:data
                                         toPeers:newPeers
                                        withMode:MCSessionSendDataReliable
                                           error:nil];
                        
                    }
                    
                }
                [self.eventsTable reloadData];
                
            }else if ([[keys objectAtIndex:i] isEqualToString:@"sentSafeData"]) {
                /*
                NSArray *newEvents = (NSArray *)[newData objectForKey:[keys objectAtIndex:i]];
                for (int j = 0; j < newEvents.count; j++) {
                    
                    if (![self.events containsObject:[newEvents objectAtIndex:j]]) {
                        if (self.ref.)
                        
                        Safe *newEvent = [newEvents objectAtIndex:j];
                        CLLocation *me = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
                        CLLocation *new = [[CLLocation alloc] initWithLatitude:[newEvent getLat] longitude:[newEvent getLon]];
                        CLLocationDistance distance = [me distanceFromLocation:new];
                        NSLog(@"ME Lat: %f, Lon: %f", location.latitude,location.longitude);
                        NSLog(@"NEW Lat: %f, Lon: %f", [newEvent getLat],[newEvent getLon]);
                        distance = distance/1000;
                        newEvent.distance = [NSString stringWithFormat:@"%.1f Kilometers away", distance];
                        [self.events addObject:newEvent];
                        
                        NSMutableArray *newPeers = [[NSMutableArray alloc] initWithArray:self.events];
                        [newPeers removeObject: peerID];
                        NSDictionary *dictionary = @{@"sentData": @[newEvent]};
                        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dictionary];
                        [self.partyTime sendData:data
                                         toPeers:newPeers
                                        withMode:MCSessionSendDataReliable
                                           error:nil];
                        
                    }
                    
                }
                [self.eventsTable reloadData];
                */
            }
            
            
        }
    }
}

- (void)partyTime:(PLPartyTime *)partyTime
             peer:(MCPeerID *)peer
     changedState:(MCSessionState)state
     currentPeers:(NSArray *)currentPeers
{
    if (state == MCSessionStateConnected)
    {
        NSLog(@"Connected to %@", peer.displayName);
        self.peerCount.text = [NSString stringWithFormat:@"%i", ([self.peerCount.text intValue]+1)];
        if ([self.peerCount.text intValue] == 1) {
            self.peerGrammar.text = @"peer in your area";
        } else {
            self.peerGrammar.text = @"peers in your area";
        }
        
    }
    else if (state == MCSessionStateConnecting) {
        NSLog(@"Connecting to: %@", peer.displayName);
    } else {
        NSLog(@"Peer disconnected: %@", peer.displayName);
        if ([self.peerCount.text intValue] != 0) {
        self.peerCount.text = [NSString stringWithFormat:@"%i", ([self.peerCount.text intValue]-1)];
            if ([self.peerCount.text intValue] == 1) {
                self.peerGrammar.text = @"peer in your area";
            } else {
            
                self.peerGrammar.text = @"peers in your area";
            }
        }
    }
    NSLog(@"Current peers: %@", currentPeers);
    
}

- (void)partyTime:(PLPartyTime *)partyTime failedToJoinParty:(NSError *)error
{
    self.errorMessage.hidden = NO;
}

- (IBAction)joinParty:(id)sender
{
    [self.partyTime joinParty];
    
    [self.eventsTable reloadData];
}

- (IBAction)leaveParty:(id)sender
{
    [self.partyTime leaveParty];
    
    [self.eventsTable reloadData];
}

#pragma mark - Table View Delegate/DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventCell"];
    
    cell.name.text = ((Event *)[self.events objectAtIndex:indexPath.row]).name;
    cell.time.text = ((Event *)[self.events objectAtIndex:indexPath.row]).time;
    cell.address.text = ((Event *)[self.events objectAtIndex:indexPath.row]).address;
    cell.distance.text = ((Event *)[self.events objectAtIndex:indexPath.row]).distance;
    cell.icon.layer.cornerRadius = 25.0;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.events count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    if (indexPath.section == 1)
    {
        if (indexPath.row < [self.partyTime.connectedPeers count])
        {
            MCPeerID *peerID = [self.partyTime.connectedPeers objectAtIndex:indexPath.row];
            
            NSDictionary *dictionary = @{
                                         @"hello": @"world"
                                         };
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dictionary];
            
            [self.partyTime sendData:data
                             toPeers:@[ peerID ]
                            withMode:MCSessionSendDataReliable
                               error:nil];
        }
    }
    [self.eventsTable deselectRowAtIndexPath:indexPath animated:YES];
     */
}
- (void)shareEvent: (Event *)event {
    
    NSDictionary *dictionary = @{
                                 @"sentData": @[event]
                                 };
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dictionary];
    
    [self.partyTime sendData:data
                    withMode:MCSessionSendDataReliable
                       error:nil];
    
    NSDictionary *newEvent = @{
                            @"Coordinates" : [NSString stringWithFormat:@"%f, %f", [event getLat], [event getLon]],
                            @"Description": event.descriptionText,
                            @"Location": event.address,
                            @"Name": event.name,
                            @"Time": event.time
                            };

    Firebase *usersRef = [self.ref childByAppendingPath: event.name];
    
    [usersRef setValue: newEvent];
}
- (void)sendSafe: (Safe *) newSafe {
    NSDictionary *dictionary = @{
                                 @"sentSafeData": @[newSafe]
                                 };
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dictionary];
    
    [self.partyTime sendData:data
                    withMode:MCSessionSendDataReliable
                       error:nil];
    
    NSDictionary *newSafeDict = @{
                               @"Coordinates" : newSafe.coordinates,
                               @"Location": newSafe.location,
                               @"Name": newSafe.name,
                               @"Time": newSafe.time
                               };

    Firebase *usersRef = [self.ref childByAppendingPath: @"Safe"];

    Firebase *post1Ref = [usersRef childByAutoId];
    
    [post1Ref setValue: newSafeDict];

}





@end
