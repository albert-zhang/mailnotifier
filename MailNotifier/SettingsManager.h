//
//  SettingsManager.h
//  MailNotifier
//
//  Created by Albert Zhang on 1/17/15.
//  Copyright (c) 2015 Yang Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, CheckingInterval) {
    CheckingInterval1 = 1 << 0,
    CheckingInterval2 = 1 << 1,
    CheckingInterval5 = 1 << 2,
    CheckingInterval10 = 1 << 3,
    CheckingInterval30 = 1 << 4,
    CheckingInterval60 = 1 << 5,
};

@interface SettingsManager : NSObject

@property (nonatomic, readonly) NSArray *accounts;

@property (nonatomic, assign) CheckingInterval checkingInterval;
@property (nonatomic, readonly) NSTimeInterval checkingIntervalValue;
@property (nonatomic, assign) BOOL showFullSubject;
@property (nonatomic, assign) BOOL showInNotificationCenter;

+ (SettingsManager *)sharedManager;

@end
