//
//  SettingsManager.h
//  MailNotifier
//
//  Created by Albert Zhang on 1/17/15.
//  Copyright (c) 2015 Yang Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingsManager : NSObject

@property (nonatomic, readonly) NSArray *accounts;

+ (SettingsManager *)sharedManager;

@end
