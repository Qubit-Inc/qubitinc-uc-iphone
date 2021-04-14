//
//  VoiceMailViewController.h
//  linphone
//
//  Created by Suhail on 12/11/20.
//

#import <UIKit/UIKit.h>
#import "UICompositeView.h"
#import "HTTPClient.h"
#import "SVProgressHUD.h"
#import "VoiceMailDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VoiceMailViewController : UIViewController<UICompositeViewDelegate, UITableViewDataSource,UITableViewDelegate> {
@private
    NSMutableDictionary *voiceMails;
    //This has sub arrays indexed with the date of the recordings, themselves containings the recordings.
    NSString *writablePath;
    //This is the path to the folder where we write the recordings to. We should probably define it in LinphoneManager though.
}
@property (nonatomic, strong)NSMutableArray<VoiceMailDataModel*> *voiceMailDataList;
@property (weak, nonatomic) IBOutlet UILabel *labelStatus;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)backAction:(UIButton *)sender;


@end

NS_ASSUME_NONNULL_END
