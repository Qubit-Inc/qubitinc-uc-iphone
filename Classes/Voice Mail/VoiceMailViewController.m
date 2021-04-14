//
//  VoiceMailViewController.m
//  linphone
//
//  Created by Suhail on 12/11/20.
//

#import "VoiceMailViewController.h"
#import "PhoneMainView.h"
#import "UIRecordingCell.h"

@interface VoiceMailViewController ()

@end

@implementation VoiceMailViewController
@synthesize  voiceMailDataList;

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
    voiceMailDataList  = [NSMutableArray new];
    _tableView.tableFooterView = [[UIView alloc] init];
    voiceMails = [NSMutableDictionary dictionary];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    writablePath = [paths objectAtIndex:0];
    writablePath = [writablePath stringByAppendingString:@"/"];
}

- (void)viewWillAppear:(BOOL)animated {
    [self getVoiceMailData];
}

-(void)getVoiceMailData {
    
    HTTPClient *sharedManager = [HTTPClient sharedManager];
    NSDictionary *param = [[NSDictionary alloc] init];
    LinphoneProxyConfig *default_proxy = linphone_core_get_default_proxy_config(LC);
    
    if (default_proxy != NULL) {
        LinphoneAppDelegate* del = [LinphoneAppDelegate appDelegate];
        
        const char *userName = linphone_address_get_username(linphone_proxy_config_get_identity_address(default_proxy));
        
        NSString *encryptedUserName = [del getEncryptedName:[NSString stringWithFormat:@"%s", userName]];
        NSString *path = [NSString stringWithFormat:@"getpendingvoicemails/%@", encryptedUserName];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [SVProgressHUD show];
        [sharedManager callGetApi:path parameters:param :^(id  _Nonnull response, NSError * _Nonnull error) {
            [SVProgressHUD dismiss];
            if (error == nil) {
                voiceMailDataList = [NSMutableArray new];
                NSDictionary *jsonDictionary=(NSDictionary *)response;
                NSInteger status = [[jsonDictionary valueForKey:@"status"] intValue];
                if (status == 0) {
                    
                    NSMutableArray *arrayData = [jsonDictionary valueForKey:@"data"];
                    if([arrayData count] > 0) {
                        for(NSDictionary *json in arrayData) {
                            VoiceMailDataModel *model = [[VoiceMailDataModel new] initModel:json];
                            [voiceMailDataList addObject:model];
                            [self downLoadVoiceMail:model];
                        }
                    }
                    else{
                        NSLog(@"No Voice mail found");
                        [self loadVoiceMails];
                    }
                }
                else
                    NSLog(@"Failed to get voicemail list, errorcode: %ld", (long)status);
            }
            else {
                
            }
        }];
    }
}

-(void) downLoadVoiceMail:(VoiceMailDataModel*) data{
    HTTPClient *sharedManager = [HTTPClient sharedManager];
    NSDictionary *param = [[NSDictionary alloc] init];
    LinphoneProxyConfig *default_proxy = linphone_core_get_default_proxy_config(LC);
    LinphoneAppDelegate* del = [LinphoneAppDelegate appDelegate];
    const char *userName = linphone_address_get_username(linphone_proxy_config_get_identity_address(default_proxy));
    NSString *encryptedUserName = [del getEncryptedName:[NSString stringWithFormat:@"%s", userName]];
    NSString *encryptedCoralID = [del getEncryptedName:[NSString stringWithFormat:@"%@", data.coralId]];
//    NSString *filename = data.filePath; //[data.filePath componentsSeparatedByString:@"/"].lastObject;
//    NSString *encryptedFilePath = [del getEncryptedName: filename];

    NSString *path = [NSString stringWithFormat:@"downloadvoicemailv1?contact=%@&coralrecordid=%@", encryptedUserName, encryptedCoralID];
    
    NSLog(@"FILE PATH: %@", path);
    
    [sharedManager downloadVoiceMail:path andCompletion:^(id  _Nonnull response, NSError * _Nonnull error) {
        if (error == nil) {
            NSData *fileToWrite = (NSData*) response;
            NSString *path = [CallManager.instance voicemailFilePathWithOtherparty:data.otherParty createdEpoc:data.createdEpoch];
            NSLog(@"PATH :- %@", path);
            NSError *error = nil;
            [fileToWrite writeToFile:path options:NSDataWritingAtomic error:&error];
            
            if(error != NULL)
                NSLog(@"Write returned error: %@", [error localizedDescription]);
            else
                NSLog(@"File saved Successfully");
            [self loadVoiceMails];
        }
        else {
            
        }
    }];
}

-(void) loadVoiceMails {
    LOGI(@"====>>>> Load voicemail list - Start");
    
    voiceMails = [NSMutableDictionary dictionary];
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:writablePath error:NULL];
    for (NSString *file in directoryContent) {
        if (![file hasPrefix:@"voicemail_"]) {
            continue;
        }
        NSArray *parsedName = [LinphoneUtils parseVoiceMailName:file];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"EEEE, MMM d, yyyy"];
        NSString *dayPretty = [dateFormat stringFromDate:[parsedName objectAtIndex:1]];
        NSMutableArray *recOfDay = [voiceMails objectForKey:dayPretty];
        if (recOfDay) {
            // Loop through the object until a later object, then insert it right before
            int i;
            for (i = 0; i < [recOfDay count]; ++i) {
                NSString *fileAtIndex = [recOfDay objectAtIndex:i];
                NSArray *parsedNameAtIndex = [LinphoneUtils parseVoiceMailName:fileAtIndex];
                if ([[parsedName objectAtIndex:1] compare:[parsedNameAtIndex objectAtIndex:1]] == NSOrderedDescending) {
                    break;
                }
            }
            [recOfDay insertObject:[writablePath stringByAppendingString:file] atIndex:i];
        } else {
            recOfDay = [NSMutableArray arrayWithObjects:[writablePath stringByAppendingString:file], nil];
            [voiceMails setObject:recOfDay forKey:dayPretty];
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });

    LOGI(@"====>>>> Load voicemail list - End");
}

#pragma mark - UITableView Functions

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *selectedRow = [self.tableView indexPathForSelectedRow];
    if (selectedRow && [selectedRow compare:indexPath] == NSOrderedSame) {
        return 150;
    } else {
        return 40;
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    [_tableView setHidden:voiceMails.count == 0];
    return [voiceMails count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sortedKey = [self getSortedKeys];
    return [(NSArray *)[voiceMails objectForKey:[sortedKey objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *kCellId = NSStringFromClass(UIRecordingCell.class);
    UIRecordingCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId];
    if (cell == nil) {
        cell = [[UIRecordingCell alloc] initWithIdentifier:kCellId];
    }
    NSString *date = [[self getSortedKeys] objectAtIndex:[indexPath section]];
    NSMutableArray *subAr = [voiceMails objectForKey:date];
    NSString *recordingPath = subAr[indexPath.row];
    [cell setRecording:recordingPath];
    //[super accessoryForCell:cell atPath:indexPath];
    //accessoryForCell set it to gray but we don't want it
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell updateFrame];
    cell.contentView.userInteractionEnabled = false;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGRect frame = CGRectMake(0, 0, tableView.frame.size.width, tableView.sectionHeaderHeight);
    UIView *tempView = [[UIView alloc] initWithFrame:frame];
    if (@available(iOS 13, *)) {
        tempView.backgroundColor = [UIColor systemBackgroundColor];
    } else {
        tempView.backgroundColor = [UIColor whiteColor];
    }
    
    UILabel *tempLabel = [[UILabel alloc] initWithFrame:frame];
    tempLabel.backgroundColor = [UIColor clearColor];
    tempLabel.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"color_A.png"]];
    tempLabel.text = [[self getSortedKeys] objectAtIndex:section];
    tempLabel.textAlignment = NSTextAlignmentCenter;
    tempLabel.font = [UIFont boldSystemFontOfSize:17];
    tempLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [tempView addSubview:tempLabel];
    
    return tempView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //[super tableView:tableView didSelectRowAtIndexPath:indexPath];
    if (![self isEditing]) {
        [tableView beginUpdates];
        [(UIRecordingCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath] updateFrame];
        [tableView endUpdates];
    }
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [NSNotificationCenter.defaultCenter removeObserver:self];
        [tableView beginUpdates];
        
        
        NSString *date = [[self getSortedKeys] objectAtIndex:[indexPath section]];
        NSMutableArray *subAr = [voiceMails objectForKey:date];
        NSString *recordingPath = subAr[indexPath.row];
        [subAr removeObjectAtIndex:indexPath.row];
        if (subAr.count == 0) {
            [voiceMails removeObjectForKey:date];
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section]
                     withRowAnimation:UITableViewRowAnimationFade];
        }
        
        UIRecordingCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell setRecording:NULL];
        
        remove([recordingPath cStringUsingEncoding:NSUTF8StringEncoding]);
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
        
        //[self loadData];
    }
}

//- (void)removeSelectionUsing:(void (^)(NSIndexPath *))remover {
//    [super removeSelectionUsing:^(NSIndexPath *indexPath) {
//        [NSNotificationCenter.defaultCenter removeObserver:self];
//
//        NSString *date = [[self getSortedKeys] objectAtIndex:[indexPath section]];
//        NSMutableArray *subAr = [voiceMails objectForKey:date];
//        NSString *recordingPath = subAr[indexPath.row];
//        [subAr removeObjectAtIndex:indexPath.row];
//        if (subAr.count == 0) {
//            [voiceMails removeObjectForKey:date];
//        }
//        UIRecordingCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
//        [cell setRecording:NULL];
//        remove([recordingPath cStringUsingEncoding:NSUTF8StringEncoding]);
//    }];
//}

- (void)setSelected:(NSString *)filepath {
    NSArray *parsedName = [LinphoneUtils parseVoiceMailName:filepath];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEEE, MMM d, yyyy"];
    NSString *dayPretty = [dateFormat stringFromDate:[parsedName objectAtIndex:1]];
    NSUInteger section;
    NSArray *keys = [voiceMails allKeys];
    for (section = 0; section < [keys count]; ++section) {
        if ([dayPretty isEqualToString:(NSString *)[keys objectAtIndex:section]]) {
            break;
        }
    }
    NSUInteger row;
    NSArray *recs = [voiceMails objectForKey:dayPretty];
    for (row = 0; row < [recs count]; ++row) {
        if ([filepath isEqualToString:(NSString *)[recs objectAtIndex:row]]) {
            break;
        }
    }
    NSUInteger indexes[] = {section, row};
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathWithIndexes:indexes length:2] animated:TRUE scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark - Utilities

- (NSArray *)getSortedKeys {
    return [[voiceMails allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString *day2, NSString *day1){
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"EEEE, MMM d, yyyy"];
        NSDate *date1 = [dateFormat dateFromString:day1];
        NSDate *date2 = [dateFormat dateFromString:day2];
        return [date1 compare:date2];
    }];
}

- (IBAction)backAction:(UIButton *)sender {
    //[self.navigationController popViewControllerAnimated:TRUE];
    [PhoneMainView.instance changeCurrentView:DialerView.compositeViewDescription];
}
@end
