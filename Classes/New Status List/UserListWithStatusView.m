//
//  UserListWithStatusView.m
//  linphone
//
//  Created by Suhail on 09/11/20.
//

#import "UserListWithStatusView.h"
#import "PhoneMainView.h"
#import "UserStatusModel.h"
#import "LinphoneManager.h"
#import "UICompositeView.h"
#import "HTTPClient.h"
#import "SVProgressHUD.h"



@interface UserListWithStatusView ()
{
    
    NSMutableArray<UserStatusModel*> *userModelArray;
    NSArray<UserStatusModel*> *original;
    
    UISearchController* searchController;
    BOOL isChecked;
    
    NSMutableDictionary *callLogsList;
    
}

@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation UserListWithStatusView

@synthesize searchController;


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

- (void)loadData {
    
   callLogsList = [[NSMutableDictionary alloc]init];
    
    const bctbx_list_t *logs = linphone_core_get_call_logs(LC);
    while (logs != NULL) {
        LinphoneCallLog *log = (LinphoneCallLog *)logs->data;
        logs = bctbx_list_next(logs);
        const LinphoneAddress *addr = linphone_call_log_get_to_address(log);
        Contact *contact = [FastAddressBook getContactWithAddress:addr];
        if(contact != nil)
            [callLogsList setObject:[NSValue valueWithPointer:linphone_call_log_ref(log)] forKey:contact.sipAddresses.firstObject];
        else{
            NSString *name = [FastAddressBook displayNameForAddress:addr];
            [callLogsList setObject:[NSValue valueWithPointer:linphone_call_log_ref(log)] forKey:name];
        }
            
        //[callLogsList addObject:[NSValue valueWithPointer:linphone_call_log_ref(log)]];
    }
}

- (void)viewDidLoad {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"UserPreferredChoice"] == NULL) {
        isChecked = TRUE;
        [[NSUserDefaults standardUserDefaults] setObject:@"TRUE" forKey:@"UserPreferredChoice"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else {
        NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserPreferredChoice"];
        if([value isEqual:@"TRUE"])
            isChecked =  TRUE;
        else
            isChecked = FALSE;
    }
    
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.labelDataNotFound.text = @"";
    
    UINib *nib = [UINib nibWithNibName:@"UserStatusTableViewCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:@"UserStatusTableViewCell"];
    
    UINib *headerNib = [UINib nibWithNibName:@"StatusHeaderCell" bundle:nil];
    [_tableView registerNib:headerNib forCellReuseIdentifier:@"StatusHeaderCell"];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self addSearchField];
    //[self getContactStatus];
    LinphoneAppDelegate* sharedDelegate = [LinphoneAppDelegate appDelegate];
    
    userModelArray = [[NSMutableArray alloc]initWithArray:sharedDelegate.userModelArray];
    original = [[NSMutableArray alloc]initWithArray:sharedDelegate.userModelArray];
    
    [self filterData];
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    if([SVProgressHUD isVisible]) {
        [SVProgressHUD dismiss];
    }
}


- (NSString*) getEncryptedName :(NSString*) name {
    
    AESAlgorithm* aesAlgo = [[AESAlgorithm alloc] init];
    NSString* AES_KEY = @"C234567890123456";
    NSString* AES_IV = @"1234567890123456";
    NSString *encryptedName = [aesAlgo encryptvalue:name withKey:AES_KEY andiv:AES_IV];
    NSLog(@"Encryted data %@", encryptedName);
    
    
    // Create NSData object
    NSData *nsdata = [encryptedName dataUsingEncoding:NSUTF8StringEncoding];
    // Get NSString from NSData object in Base64
    NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
    
    // Print the Base64 encoded string
    NSLog(@"Encoded: %@", base64Encoded);
    return  base64Encoded;
}

- (void) addSearchField {
    StatusHeaderCell *cell = (StatusHeaderCell *) [_tableView dequeueReusableCellWithIdentifier:@"StatusHeaderCell"];
    cell.frame = CGRectMake(0, 0, self.view.frame.size.width, 60);
    cell.checkButtonDelegate = self;
    [cell.textFieldSearch setDelegate:self];
    [cell updateButton:isChecked];
    [self.view addSubview:cell];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if(searchText.length > 0) {
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[cd] %@", searchText];
        NSArray* filteredData = [original filteredArrayUsingPredicate:predicate];
        userModelArray = [[NSMutableArray alloc]initWithArray:filteredData];
        if (userModelArray.count == 0){
            self.labelDataNotFound.text = @"No records found";
            [self.tableView reloadData];
        } else {
            self.labelDataNotFound.text = @"";
            [self.tableView reloadData];
        }
    }
    else
        [self resetData];
    
}

-(void) resetData {
    userModelArray = [[NSMutableArray alloc]initWithArray:original];
    [_tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self resetData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(userModelArray == nil) {
        return  0;
    }
    else
        return  [userModelArray count];
}



-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  @"Call";
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    return NO;
//}
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [self makeCall:tableView indexPath:indexPath];
//    }
//}

//- (void) makeCall:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
//    LinphoneAddress *addr = [LinphoneUtils normalizeSipOrPhoneAddress:userModelArray[indexPath.row].contact];
//    [LinphoneManager.instance call:addr];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserStatusTableViewCell *cell = (UserStatusTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"UserStatusTableViewCell"];
    UserStatusModel *model = userModelArray[indexPath.row];
    NSString *userNameWithContactID = [NSString stringWithFormat: @"%@ %@", model.name, model.contact];
    [cell.labelUserName setText:userNameWithContactID];
    [cell.labelStatusColor setBackgroundColor: [self convertHextoUIColor:model.statusColorHex]];
    cell.detailsButton.tag = indexPath.row;
    [cell.detailsButton addTarget:self action:@selector(detailAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return  cell;
    
}

- (void) detailAction : (UIButton*) sender {
    UserStatusModel *model = userModelArray[sender.tag];
    NSLog(@"%@", model.contact);
    
    id logId = [callLogsList objectForKey:model.contact];
//    if(logId == nil)
//        logId = [callLogsList objectForKey:model.name];
    
    
        
    if(logId != nil){
        HistoryDetailsView *view = VIEW(HistoryDetailsView);
        //HistoryDetailsView* view =[[HistoryDetailsView alloc] initWithNibName:@"HistoryDetailsView" bundle:nil];
        LinphoneCallLog *callLog = [logId pointerValue];
        if (linphone_call_log_get_call_id(callLog) != NULL) {
            // Go to History details view
            [view setCallLogId:[NSString stringWithUTF8String:linphone_call_log_get_call_id(callLog)]];
        }
        [PhoneMainView.instance changeCurrentView:view.compositeViewDescription];
        //[self.navigationController pushViewController:view animated:TRUE];
        

    }
    else {
        //[view setCallLogId: @""];
        ContactDetailsView *view = VIEW(ContactDetailsView);
       // ContactDetailsView* view =[[ContactDetailsView alloc] initWithNibName:@"ContactDetailsView" bundle:nil];

        CNContact *cnContact = [[CNContact alloc] init];
        Contact* contact = [[Contact alloc] initWithCNContact:cnContact];
        [contact setSipAddress:model.contact atIndex:0];
        [view setContact:contact];
        //[self.navigationController pushViewController:view.compositeViewDescription animated:TRUE];
        [PhoneMainView.instance changeCurrentView:view.compositeViewDescription];
        //[self.navigationController pushViewController:view animated:TRUE];

    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString* searchString = @"";
    if(range.length == 0) { //character added
        searchString = [NSString stringWithFormat: @"%@%@", textField.text,string];
    }
    else if(textField.text.length > 1){ //Character Removed
        searchString = [NSString stringWithFormat: @"%@", [textField.text substringToIndex:[textField.text length]-1]];
    }
    NSLog(@"Search String--, %@", searchString );
    
    if(searchString.length > 0) {
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[cd] %@ OR SELF.contact contains[cd] %@", searchString, searchString];
        NSArray* filteredData = [original filteredArrayUsingPredicate:predicate];
        userModelArray = [[NSMutableArray alloc]initWithArray:filteredData];
        if (userModelArray.count == 0){
            self.labelDataNotFound.text = @"No records found";
            [self.tableView reloadData];
        } else {
            self.labelDataNotFound.text = @"";
            [self.tableView reloadData];
        }
    }
    else
        [self resetData];
    
    
    return  TRUE;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return  TRUE;
}


-(void)checkboxOptionChanged : (BOOL) checkedStatus {
    isChecked = checkedStatus;
    if(isChecked) {
        [[NSUserDefaults standardUserDefaults] setObject:@"TRUE" forKey:@"UserPreferredChoice"];
    }
    else {
        [[NSUserDefaults standardUserDefaults] setObject:@"FALSE" forKey:@"UserPreferredChoice"];
        
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self filterData];
}

-(void)refreshList : (BOOL) refreshList {
    [self getContactStatus];
}

-(void)filterData {
    if(isChecked) {
        NSString *status = @"Registered";
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF.status = %@", status];
        NSArray* filteredData = [original filteredArrayUsingPredicate:predicate];
        userModelArray = [[NSMutableArray alloc]initWithArray:filteredData];
        if (userModelArray.count == 0){
            self.labelDataNotFound.text = @"No records found";
            [self.tableView reloadData];
        } else {
            self.labelDataNotFound.text = @"";
            [self.tableView reloadData];
        }
    }
    else
        [self resetData];
    
    [self.tableView reloadData];
}

- (UIColor *)convertHextoUIColor: (NSString *)hexString {
    
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    
    NSLog(@"colorString :%@",colorString);
    CGFloat alpha, red, blue, green;
    
    // #RGB
    alpha = 1.0f;
    red   = [self colorComponentFrom: colorString start: 0 length: 2];
    green = [self colorComponentFrom: colorString start: 2 length: 2];
    blue  = [self colorComponentFrom: colorString start: 4 length: 2];
    
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

- (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}


-(void) getContactStatus {
    
    HTTPClient *sharedManager = [HTTPClient sharedManager];
    NSDictionary *param = [[NSDictionary alloc] init];
    LinphoneProxyConfig *default_proxy = linphone_core_get_default_proxy_config(LC);
    
    if (default_proxy != NULL) {
        
        const char *userName = linphone_address_get_username(linphone_proxy_config_get_identity_address(default_proxy));
        
        NSString *encryptedUserName = [self getEncryptedName:[NSString stringWithFormat:@"%s", userName]];
        NSString *path = [NSString stringWithFormat:@"getstatuslist/%@", encryptedUserName];
        
        [SVProgressHUD show];
        [sharedManager callGetApi:path parameters:param :^(id  _Nonnull response, NSError * _Nonnull error) {
            [SVProgressHUD dismiss];
            userModelArray = [NSMutableArray new];
            if (error == nil){
                NSDictionary *jsonDictionary=(NSDictionary *)response;
                NSInteger status = [[jsonDictionary valueForKey:@"status"] intValue];
                if (status == 0) {
                    NSMutableArray *arrayData = [jsonDictionary valueForKey:@"data"];
                    for(NSDictionary *json in arrayData) {
                        UserStatusModel *model = [[UserStatusModel new] initModel:json];
                        [userModelArray addObject:model];
                    }
                    original = [[NSArray alloc] initWithArray:userModelArray];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.labelDataNotFound.text = @"";
                        [self filterData];
                    });
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.labelDataNotFound.text = @"Records not found";
                        
                    });
                }
            }
        }];
    }
    
}

@end
