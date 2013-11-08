//
//  NSException.m
//  FishLampFrameworks
//
//  Created by Mike Fullerton on 8/26/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLErrorException.h"
#import "FLErrorCodes.h"
#import "NSError+FLExtras.h"

NSString* const FLErrorExceptionName = @"error";

@interface FLUnknownExceptionError : NSError {
@private
}
@end

@implementation FLUnknownExceptionError

- (id) initWithException:(NSException*) exception {
	return [super initWithDomain:FLErrorDomain code:FLUnknownExceptionErrorCode
                        userInfo:[NSDictionary dictionaryWithObject:exception forKey:FLErrorExceptionName]];
}

+ (id) unknownExceptionError:(NSException*) exception {
    return FLAutorelease([[[self class] alloc] initWithException:exception]);
}

@end

@implementation NSException (NSError)

- (NSError*) error {
    NSError* error = [self.userInfo objectForKey:NSUnderlyingErrorKey];
    if(error) {
        return error;
    }

    return [FLUnknownExceptionError unknownExceptionError:self];
}

- (id)initWithName:(NSString *)aName
            reason:(NSString *)aReason
          userInfo:(NSDictionary *)aUserInfo
             error:(NSError*) error {

    if(error) {
        if(aUserInfo) {
            NSMutableDictionary* newUserInfo = FLMutableCopyWithAutorelease(aUserInfo);
            [newUserInfo setObject:error forKey:NSUnderlyingErrorKey];
            return [self initWithName:aName reason:aReason userInfo:newUserInfo];
        }

        return [self initWithName:aName reason:aReason userInfo:[NSDictionary dictionaryWithObject:error forKey:NSUnderlyingErrorKey]];
    }

    return [self initWithName:aName reason:aReason userInfo:aUserInfo];
}

+ (NSException *)exceptionWithName:(NSString *)name
                            reason:(NSString *)reason
                          userInfo:(NSDictionary *)userInfo
                             error:(NSError*) error {
    return FLAutorelease([[[self class] alloc] initWithName:name reason:reason userInfo:userInfo error:error]);
}

- (id) initWithError:(NSError*) error {
    return [self initWithName:[error nameForException]
                       reason:[error reasonForException]
                     userInfo:nil
                        error:error];
}

+ (id) exceptionWithError:(NSError*) error {
    return FLAutorelease([[[self class] alloc] initWithError:error]);
}

@end

//@implementation FLErrorException
//
//+ (id) errorException:(NSError*) error {
//    return FLAutorelease([[[self class] alloc] initWithError:error]);
//}
//
//@end
//