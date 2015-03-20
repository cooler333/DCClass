//
//  CheckDevice.h
//  compare
//
//  Created by Дмитрий Утьманов on 24/02/15.
//  Copyright (c) 2015 lmrk. All rights reserved.
//


#define IS_IPAD               (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE             (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define SCREEN_WIDTH          ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT         ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH     (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH     (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4           (IS_IPHONE && (SCREEN_MAX_LENGTH == 480.0f))
#define IS_IPHONE_5           (IS_IPHONE && (SCREEN_MAX_LENGTH == 568.0f))
#define IS_IPHONE_6           (IS_IPHONE && (SCREEN_MAX_LENGTH == 667.0f))
#define IS_IPHONE_6P          (IS_IPHONE && (SCREEN_MAX_LENGTH == 736.0f))

#define IS_OS_7               ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
#define IS_OS_8_OR_LATER      ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
