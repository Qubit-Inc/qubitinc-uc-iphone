//
//  SideMenuCell.h
//  linphone
//
//  Created by Suhail on 15/12/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SideMenuCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *buttonAccount;
@property (weak, nonatomic) IBOutlet UIButton *buttonVoicemail;
@property (weak, nonatomic) IBOutlet UIButton *buttonFax;
@property (weak, nonatomic) IBOutlet UIButton *buttonRecording;
@property (weak, nonatomic) IBOutlet UIButton *buttonAbout;
@property (weak, nonatomic) IBOutlet UIButton *buttonSettings;
@property (weak, nonatomic) IBOutlet UIButton *buttonUCFeatures;
@property (weak, nonatomic) IBOutlet UIButton *parkedMember;



@property (weak, nonatomic) IBOutlet UILabel *labelMenuTitle;

-(void)setUpCell:(int)index;

@end

NS_ASSUME_NONNULL_END
