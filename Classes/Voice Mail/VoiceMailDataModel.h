//
//  VoiceMailDataModel.h
//  linphone
//
//  Created by Suhail on 02/01/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VoiceMailDataModel : NSObject

@property(nonatomic,strong)NSString* coralId;
@property(nonatomic,strong)NSString* otherParty;
@property(nonatomic,strong)NSString* filePath;
@property(nonatomic,strong)NSString* createdEpoch;

-(instancetype) initModel:(NSDictionary*) json;

@end

NS_ASSUME_NONNULL_END
