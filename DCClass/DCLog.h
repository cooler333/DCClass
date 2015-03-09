//
//  DCLog.h
//  
//
//  Created by Dmitriy Utmanov on 09/03/15.
//
//

#ifdef DEBUG
#define DCLog( s, ... ) NSLog( @"<%@ %s (%d)> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __FUNCTION__, __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DCLog( s, ... )
#endif
