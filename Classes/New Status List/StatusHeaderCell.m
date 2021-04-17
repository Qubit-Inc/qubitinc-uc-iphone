//
//  StatusHeaderCell.m
//  linphone
//
//  Created by Suhail on 26/12/20.
//

#import "StatusHeaderCell.h"

@implementation StatusHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)checkAction:(UIButton *)sender {

    [self updateButton:FALSE];
    [self.checkButtonDelegate checkboxOptionChanged:FALSE];
}

- (IBAction)uncheckAction:(UIButton *)sender {
    [self updateButton:TRUE];
    [self.checkButtonDelegate checkboxOptionChanged:TRUE];
}

- (IBAction)refreshAction:(UIButton *)sender {
    [self.checkButtonDelegate refreshList:TRUE];
}

- (void) updateButton: (BOOL) isChecked {
    
    _buttonCheck.hidden = !isChecked;
    _buttonUnCheck.hidden = isChecked;
    
}
@end
