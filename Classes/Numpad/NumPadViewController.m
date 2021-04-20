//
//  NumPadViewController.m
//  sanchar
//
//  Created by Suhail Shabir on 17/04/21.
//

#import "NumPadViewController.h"

@interface NumPadViewController ()

@end

@implementation NumPadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onAddContactClick:(id)event {

}

- (IBAction)onBackClick:(id)event {
    
}
//- (IBAction)onAddressChange:(id)sender{
////    if ([self displayDebugPopup:_addressField.text]) {
////        _addressField.text = @"";
////    }
//    _addContactButton.enabled = _backspaceButton.enabled = ([[_addressField text] length] > 0);
//    _callButton.enabled = _addContactButton.enabled;
//    if ([_addressField.text length] == 0) {
//        [self.view endEditing:YES];
//    }
//
//}
//- (IBAction)onBackspaceClick:(id)sender {
//
//    if ([_addressField.text length] > 0) {
//        [_addressField setText:[_addressField.text substringToIndex:[_addressField.text length] - 1]];
//    }
//}
//
//- (void)setAddress:(NSString *)address {
//    [_addressField setText:address];
//}

#pragma mark - UITextFieldDelegate Functions

- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
                replacementString:(NSString *)string {
    //[textField performSelector:@selector() withObject:nil afterDelay:0];
    return YES;
}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    if (textField == _addressField) {
//        [_addressField resignFirstResponder];
//    }
//    if (textField.text.length > 0) {
//        LinphoneAddress *addr = [LinphoneUtils normalizeSipOrPhoneAddress:textField.text];
//        [LinphoneManager.instance call:addr];
//        if (addr)
//            linphone_address_destroy(addr);
//    }
//    return YES;
//}

- (IBAction)testAction:(id)sender {
    NSLog(@"Test action");
}
@end
