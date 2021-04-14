//
//  SideMenuCell.m
//  linphone
//
//  Created by Suhail on 15/12/20.
//

#import "SideMenuCell.h"

@implementation SideMenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setUpCell:(int) index {
    
    UIButton *currentButton;
    
    [_buttonAccount setHidden:TRUE];
    [_buttonSettings setHidden:TRUE];
    [_buttonUCFeatures setHidden:TRUE];
    [_buttonVoicemail setHidden:TRUE];
    [_buttonFax setHidden:TRUE];
    [_buttonRecording setHidden:TRUE];
    [_buttonAbout setHidden:TRUE];
    [_parkedMember setHidden:TRUE];
    
    
    switch (index) {
        case 0:
            currentButton = _buttonAccount;
            [_buttonAccount setHidden:FALSE];
            break;
        case 1:
            currentButton = _buttonSettings;
            [_buttonSettings setHidden:FALSE];
            break;
        case 2:
            currentButton = _buttonUCFeatures;
            [_buttonUCFeatures setHidden:FALSE];
            break;
        case 3:
            currentButton = _parkedMember;
            [_parkedMember setHidden:FALSE];
            break;
        
        case 4:
            currentButton = _buttonVoicemail;
            [_buttonVoicemail setHidden:FALSE];
            break;
        case 5:
            currentButton = _buttonFax;
            [_buttonFax setHidden:FALSE];
            break;
        case 6:
            currentButton = _buttonRecording;
            [_buttonRecording setHidden:FALSE];
            break;
        case 7:
            currentButton = _buttonAbout;
            [_buttonAbout setHidden:FALSE];
            break;
        default:
            break;
    }
    
    if (@available(iOS 12.0, *)) {
        UIColor *color = [UIColor grayColor];
//        if( self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark ){
//            color = [UIColor whiteColor];
//        }
        
        NSDictionary *attributes = @{ NSForegroundColorAttributeName : color };
        NSAttributedString *pauseButtonAttrStr = [[NSAttributedString alloc] initWithString:currentButton.titleLabel.text  attributes:attributes];
        [currentButton setAttributedTitle:pauseButtonAttrStr forState:UIControlStateNormal];
    }
}

@end
