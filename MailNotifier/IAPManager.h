//
//  IAPManager.h
//  MailNotifier
//
//  Created by Yang Zhang on 1/20/15.
//  Copyright (c) 2015 Yang Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IAPManager : NSObject

@property (nonatomic, assign) BOOL hasPurchasedPro;

+ (IAPManager *)sharedManager;

@end
