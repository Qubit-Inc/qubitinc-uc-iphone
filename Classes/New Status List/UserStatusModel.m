//
//  UserStatusModel.m
//  linphone
//
//  Created by SHAD HAIDARI on 13/11/20.
//

#import "UserStatusModel.h"
#import <Foundation/Foundation.h>

@implementation UserStatusModel

@synthesize name, contact, status, statusColor, statusColorHex;


-(instancetype) initModel:(NSDictionary*) json {
    self = [super init];

    if (self) {
        name = [json valueForKey:@"name"];
        contact = [json valueForKey:@"contact"];
        status = [json valueForKey:@"status"];
        statusColor = [json valueForKey:@"statuscolor"];
        statusColorHex = [json valueForKey:@"statuscolorhex"];
    }
    return self;
}

@end
