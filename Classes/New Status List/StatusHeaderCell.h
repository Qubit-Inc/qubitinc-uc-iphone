//
//  StatusHeaderCell.h
//  linphone
//
//  Created by Suhail on 26/12/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UpdateCheckButtonDelegate <NSObject>

-(void)checkboxOptionChanged : (BOOL) checkedStatus;
-(void)refreshList : (BOOL) refreshList;


@end


@interface StatusHeaderCell : UITableViewCell
@property(nonatomic, strong) id<UpdateCheckButtonDelegate> checkButtonDelegate;

@property (weak, nonatomic) IBOutlet UIButton *buttonUnCheck;
@property (weak, nonatomic) IBOutlet UIButton *buttonCheck;
- (IBAction)uncheckAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *textFieldSearch;
- (IBAction)checkAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;

- (void) updateButton: (BOOL) isChecked;

- (IBAction)refreshAction:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
