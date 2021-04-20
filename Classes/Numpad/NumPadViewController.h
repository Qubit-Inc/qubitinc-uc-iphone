//
//  NumPadViewController.h
//  sanchar
//
//  Created by Suhail Shabir on 17/04/21.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>

#import "UICompositeView.h"

#import "UICamSwitch.h"
#import "UICallButton.h"
#import "UIDigitButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface NumPadViewController
    : TPMultiLayoutViewController <UITextFieldDelegate, UICompositeViewDelegate> {
}
/*
@property (weak, nonatomic) IBOutlet UIView *numberView;
@property(nonatomic, strong) IBOutlet UITextField *addressField;
@property(nonatomic, strong) IBOutlet UIButton *addContactButton;
@property(nonatomic, strong) IBOutlet UICallButton *callButton;
@property(nonatomic, strong) IBOutlet UIButton *backButton;
@property(weak, nonatomic) IBOutlet UIButton *backspaceButton;

@property(nonatomic, strong) IBOutlet UIDigitButton *oneButton;
@property(nonatomic, strong) IBOutlet UIDigitButton *twoButton;
@property(nonatomic, strong) IBOutlet UIDigitButton *threeButton;
@property(nonatomic, strong) IBOutlet UIDigitButton *fourButton;
@property(nonatomic, strong) IBOutlet UIDigitButton *fiveButton;
@property(nonatomic, strong) IBOutlet UIDigitButton *sixButton;
@property(nonatomic, strong) IBOutlet UIDigitButton *sevenButton;
@property(nonatomic, strong) IBOutlet UIDigitButton *eightButton;
@property(nonatomic, strong) IBOutlet UIDigitButton *nineButton;
@property(nonatomic, strong) IBOutlet UIDigitButton *starButton;
@property(nonatomic, strong) IBOutlet UIDigitButton *zeroButton;
@property(nonatomic, strong) IBOutlet UIDigitButton *hashButton;
@property(weak, nonatomic) IBOutlet UIView *padView;

@property (weak, nonatomic) IBOutlet UILabel *abcLabel;
@property (weak, nonatomic) IBOutlet UILabel *defLabel;

@property (weak, nonatomic) IBOutlet UILabel *ghiLabel;
@property (weak, nonatomic) IBOutlet UILabel *jklLabel;
@property (weak, nonatomic) IBOutlet UILabel *mnoLabel;

@property (weak, nonatomic) IBOutlet UILabel *pqrsLabel;
@property (weak, nonatomic) IBOutlet UILabel *tuvLabel;

@property (weak, nonatomic) IBOutlet UILabel *wxyzlabel;
@property (weak, nonatomic) IBOutlet UILabel *plusLabel;



- (IBAction)onAddContactClick:(id)event;
- (IBAction)onBackClick:(id)event;
- (IBAction)onAddressChange:(id)sender;
- (IBAction)onBackspaceClick:(id)sender;

- (void)setAddress:(NSString *)address;

@property (weak, nonatomic) IBOutlet UIButton *swipeButton;

@property (weak, nonatomic) IBOutlet UIButton *swipeButtonAction;
*/

- (IBAction)testAction:(id)sender;


@end

NS_ASSUME_NONNULL_END
