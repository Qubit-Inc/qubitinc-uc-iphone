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
    
    BSDropDown *ddView=[[BSDropDown alloc] initWithWidth:200 withHeightForEachRow:50 originPoint:sender.center withOptions:@[@"option 1",@"option 2",@"option 3",@"option 4",@"option 5"]];
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
}

@end
