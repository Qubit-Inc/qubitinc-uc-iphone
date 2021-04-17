//
//  ParkedMembersViewController.m
//  sanchar
//
//  Created by Suhail Shabir on 17/04/21.
//

#import "ParkedMembersViewController.h"
#import "PhoneMainView.h"
#import "UserStatusModel.h"
#import "LinphoneManager.h"
#import "HTTPClient.h"
#import "SVProgressHUD.h"


@interface ParkedMembersViewController ()
@property(nonatomic, strong)UIAlertAction *sendAction;

@end

@implementation ParkedMembersViewController

#pragma mark - UICompositeViewDelegate Functions

static UICompositeViewDescription *compositeDescription = nil;

+ (UICompositeViewDescription *)compositeViewDescription {
    if (compositeDescription == nil) {
        compositeDescription = [[UICompositeViewDescription alloc] init:self.class
                                                              statusBar:StatusBarView.class
                                                                 tabBar:TabBarView.class
                                                               sideMenu:SideMenuView.class
                                                             fullscreen:false
                                                         isLeftFragment:YES
                                                           fragmentWith:nil];
    }
    return compositeDescription;
    
}

- (UICompositeViewDescription *)compositeViewDescription {
    return self.class.compositeViewDescription;
}


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

- (IBAction)backAction:(UIButton *)sender {
    //[PhoneMainView.instance popCurrentView];
    [PhoneMainView.instance changeCurrentView:DialerView.compositeViewDescription];
}

- (IBAction)showDropDown:(UIButton *)sender {
    NSLog(@"Show dropdown");
    NSArray *options = [[NSArray alloc] initWithObjects: @"Can't talk now. What's up?",@"I'll call you right back.", @"I'll call you later",@"Can't talk now. Call me later?",@"Write your own...", nil];
    
    BSDropDown *ddView=[[BSDropDown alloc] initWithWidth:250 withHeightForEachRow:50 originPoint:sender.frame.origin withOptions:options];
    ddView.delegate=self;
    if (@available(iOS 13.0, *)) {
        ddView.dropDownBGColor=[UIColor systemBackgroundColor];
        ddView.dropDownTextColor=[UIColor labelColor];
    } else {
        ddView.dropDownBGColor=[UIColor whiteColor];
        ddView.dropDownTextColor=[UIColor blackColor];
    }
    //    ddView.dropDownFont=[UIFont systemFontOfSize:13];
    [self.view addSubview:ddView];
}

#pragma mark - DropDown Delegate
-(void)dropDownView:(UIView *)ddView AtIndex:(NSInteger)selectedIndex{
    
    NSLog(@"selectedIndex: %li",(long)selectedIndex);
    NSArray *options = [[NSArray alloc] initWithObjects: @"Can't talk now. What's up?",@"I'll call you right back." @"I'll call you later",@"Can't talk now. Call me later?",@"Write your own...", nil];
    
    if(selectedIndex == 4) {
        //show alert to write custom message
        [self showCustomMessageAlert];
        
    }else
        NSLog(@"Disconnect call");
    
    
    
}


-(void)showCustomMessageAlert {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @""
                                                                              message: @""
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Write your own...";
        if (@available(iOS 13.0, *)) {
            textField.textColor = [UIColor labelColor];
        } else {
            // Fallback on earlier versions
            textField.textColor = [UIColor blackColor];
        }
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.delegate = self;
    }];
    
     [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }]];
    
    self.sendAction = [UIAlertAction actionWithTitle:@"Send" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField * namefield = textfields[0];
        NSLog(@"%@",namefield.text);
    }];
    [alertController addAction:self.sendAction];
    self.sendAction.enabled = NO;
    [self presentViewController:alertController animated:YES completion:nil];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    NSString *finalString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self.sendAction setEnabled:(finalString.length >= 1)];
    return YES;
}

@end
