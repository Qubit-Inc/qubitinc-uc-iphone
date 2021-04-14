//
//  GetUserStatus.h
//  linphone
//
//  Created by Suhail on 27/12/20.
//

#import <Foundation/Foundation.h>
#import "linphoneapp-Swift.h"

NS_ASSUME_NONNULL_BEGIN

@interface GetUserStatus : NSObject {
    
}

NSMutableArray<UserStatusModel*> *userModelArray;

+ (id)sharedManager;

 @end

NS_ASSUME_NONNULL_END
