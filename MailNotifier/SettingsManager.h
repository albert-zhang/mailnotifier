//
//  SettingsManager.h
//  MailNotifier
//
//  Created by Albert Zhang on 1/17/15.
//  Copyright (c) 2015 Yang Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "types.h"

@interface SettingsManager : NSObject

@property (nonatomic, readonly) NSArray *accounts;

@property (nonatomic, assign) CheckingInterval checkingInterval;
@property (nonatomic, readonly) NSTimeInterval checkingIntervalValue;
@property (nonatomic, assign) BOOL showFullSubject;
@property (nonatomic, assign) BOOL showInNotificationCenter;

+ (SettingsManager *)sharedManager;

@end
