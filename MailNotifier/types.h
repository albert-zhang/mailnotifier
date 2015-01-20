//
//  types.h
//  MailNotifier
//
//  Created by Yang Zhang on 1/20/15.
//  Copyright (c) 2015 Yang Zhang. All rights reserved.
//

#ifndef MailNotifier_types_h
#define MailNotifier_types_h


typedef enum : NSUInteger {
    CheckingInterval1 = 1,
    CheckingInterval2 = 2,
    CheckingInterval5 = 5,
    CheckingInterval10 = 10,
    CheckingInterval30 = 30,
    CheckingInterval60 = 60
} CheckingInterval;

#define kCheckingIntervalCount 6

#define CheckingIntervalCArray {1, 2, 5, 10, 30, 60}


#endif
