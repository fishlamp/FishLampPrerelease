// 
// FLLastUpdateTime.h
// 
// DO NOT MODIFY!! Modifications will be overwritten.
// 
// Project: FishLamp
// Schema: FLSessionObjects
// 
// Generated by: Mike Fullerton @ 5/25/13 11:04 AM with PackMule (3.0.0.1)
// 
// Organization: GreenTongue Software LLC, Mike Fullerton
// 
// License: The FishLamp Framework is released under the MIT License: http://fishlamp.com/license
// 
// Copywrite (C) 2013 GreenTongue Software LLC, Mike Fullerton. All rights reserved.
// 
#import "FLModelObject.h"
@interface FLLastUpdateTime : FLModelObject {
@private
    NSString* _lastUpdateId;
    NSDate* _lastUpdate;
}

@property (readwrite, strong, nonatomic) NSString* lastUpdateId;
@property (readwrite, strong, nonatomic) NSDate* lastUpdate;
+(FLLastUpdateTime*) lastUpdateTime;
@end