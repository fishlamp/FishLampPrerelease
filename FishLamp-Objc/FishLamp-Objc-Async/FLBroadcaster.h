//
//  FLBroadcaster.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 1/24/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"
#import "FLArrayProxy.h"

// these are here as a convenience
#import "FLAbstractObjectProxy.h"
#import "FLRetainedObject.h"
#import "FLNonretainedObjectProxy.h"
#import "FLMainThreadObject.h"

#define FLBroadcasterDefaultQueue nil

@protocol FLAsyncQueue;

@protocol FLBroadcaster <NSObject>

- (void) sendMessageToListeners:(SEL) messageSelector;

- (void) sendMessageToListeners:(SEL) messageSelector
              withObject:(id) object;

- (void) sendMessageToListeners:(SEL) messageSelector
              withObject:(id) object1
              withObject:(id) object2;

- (void) sendMessageToListeners:(SEL) messageSelector
              withObject:(id) object1
              withObject:(id) object2
              withObject:(id) object3;

- (void) sendMessageToListeners:(SEL) messageSelector
              withObject:(id) object1
              withObject:(id) object2
              withObject:(id) object3
              withObject:(id) object4;

//- (BOOL) hasListener:(id) listener;

- (void) addListener:(id) listener;

- (void) removeListener:(id) listener;
@end

@interface FLBroadcasterProxy : FLAbstractArrayProxy<NSFastEnumeration, FLBroadcaster> {
@private
    NSMutableArray* _listeners;
}

- (id) init;
@end


@interface FLBroadcaster : NSObject<FLBroadcaster> {
@private
    FLBroadcasterProxy* _broadcasterProxy;
    dispatch_once_t _predicate;
}
@end
