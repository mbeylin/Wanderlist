//
//  Safe.m
//  Wanderlist
//
//  Created by Mark Beylin on 2015-09-20.
//  Copyright © 2015 Mark Beylin. All rights reserved.
//

#import "Safe.h"

@implementation Safe

- (BOOL)isEqual:(Safe *) safe {
    if ((self.name == safe.name) && (self.time == safe.time) && (self.location == safe.location) && (self.coordinates == safe.coordinates)) {
        return YES;
    }
    return NO;
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.time forKey:@"time"];
    [aCoder encodeObject:self.location forKey:@"location"];
    [aCoder encodeObject:self.coordinates forKey:@"coordinates"];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.time = [aDecoder decodeObjectForKey:@"time"];
        self.location = [aDecoder decodeObjectForKey:@"location"];
        self.coordinates = [aDecoder decodeObjectForKey:@"coordinates"];
    }
    return self;
}
@end
