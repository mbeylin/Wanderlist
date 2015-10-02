//
//  Event.h
//  Rally
//
//  Created by Mark Beylin on 2015-09-19.
//  Copyright © 2015 Mark Beylin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Event : NSObject {
    NSInteger lat;
    NSInteger lon;
}


@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *descriptionText;
@property (strong, nonatomic) UIImage *icon;
@property (strong, nonatomic) NSString *distance;

-(double)getLat;
-(double)getLon;
-(void)setLat: (double) newlat;
-(void)setLon: (double) newlon;


@end
