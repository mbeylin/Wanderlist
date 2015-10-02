//
//  Event.m
//  Rally
//
//  Created by Mark Beylin on 2015-09-19.
//  Copyright © 2015 Mark Beylin. All rights reserved.
//

#import "Event.h"

@implementation Event


- (BOOL)isEqual:(Event *) event {
    if ((self.name == event.name) && (self.time == event.time) && (self.address == event.address) && (self.descriptionText == event.descriptionText) && (self.distance == event.distance)) {
        return YES;
    }
    return NO;
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.time forKey:@"time"];
    [aCoder encodeObject:self.descriptionText forKey:@"descriptionText"];
    [aCoder encodeObject:self.address forKey:@"address"];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.time = [aDecoder decodeObjectForKey:@"time"];
        self.descriptionText = [aDecoder decodeObjectForKey:@"descriptionText"];
        self.address = [aDecoder decodeObjectForKey:@"address"];
    }
    return self;
}
-(double)getLat {
    return lat;
}
-(double)getLon {
    return lon;
}
-(void)setLon: (double) newlon {
    lon = newlon;
}
-(void)setLat: (double) newlat {
    lat = newlat;
}


@end
