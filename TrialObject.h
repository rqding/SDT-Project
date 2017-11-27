//
//  TrialObject.h
//  SMaLL
//
//  This trial object contains test trial information. Including trialid, picture id, readable or unreadable.
//
//  Created by Richard Ding on 2016-10-27.
//  Copyright © 2016 MathLab Carleton University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrialObject : NSObject {
    
    NSNumber *trialid;
    NSString *trialstring;
    NSString *trialresult;
}

@property(nonatomic, retain)NSNumber *trialid;
@property(nonatomic, retain)NSString *trialstring;
@property(nonatomic, retain)NSString *trialresult;

@end
