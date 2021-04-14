//
//  VoiceMailDataModel.m
//  linphone
//
//  Created by Suhail on 02/01/21.
//

#import "VoiceMailDataModel.h"

@implementation VoiceMailDataModel
@synthesize coralId,otherParty, filePath,createdEpoch;

-(instancetype) initModel:(NSDictionary*) json {
    self = [super init];

    if (self) {
        coralId = [json valueForKey:@"coralid"];
        otherParty = [json valueForKey:@"otherparty"];
        filePath = [json valueForKey:@"filepath"];
        createdEpoch = [NSString stringWithFormat:@"%@", [json valueForKey:@"created_epoch"] ];
    }
    return self;
}
@end
