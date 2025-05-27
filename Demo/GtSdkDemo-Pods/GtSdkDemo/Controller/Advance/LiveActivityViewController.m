//
//  LiveActivityViewController.m
//  GtSdkDemo
//
//  Created by ak on 2023/06/20.
//  Copyright © 2019 Gexin Interactive (Beijing) Network Technology Co.,LTD. All rights reserved.
//

#import "LiveActivityViewController.h"
#import "GtSdkDemo-Swift.h"

#if !TARGET_OS_MACCATALYST


@interface LiveModel: NSObject
@property (nonatomic, copy) NSString *activityId;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *uuid;
+ (instancetype)modelWithActivityId:(NSString *)activityId token:(NSString*)token uuid:(NSString*)uuid;
@end


@implementation LiveModel
+ (instancetype)modelWithActivityId:(NSString *)activityId token:(NSString*)token uuid:(NSString*)uuid {
    LiveModel *m = [LiveModel new];
    m.activityId = activityId;
    m.token = token;
    m.uuid = uuid;
    return m;
}
@end


@interface LiveActivityViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (nonatomic, assign) int state;
@property (nonatomic, weak) IBOutlet UITextField *activityIdText;
@property (nonatomic, strong) NSMutableDictionary<NSString*, LiveModel*> *dic;
@end

@implementation LiveActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"灵动岛交互";
    self.state = 0;
    self.dic = @{}.mutableCopy;
}

- (IBAction)create {
    self.state = 0;
    if (@available(iOS 16.1, *)) {
        NSString *laid = self.activityIdText.text;
        if (laid.length == 0) {
            [Utils AlertControllerWithTitle:@"业务ID不能为空" andMessage:@""];
            return;
        }
//        void (^pushTokenUpdate)(NSString *uuid, NSString *token, BOOL enable) = ^(NSString *uuid, NSString *token, BOOL enable) {
//            if (!enable || token.length == 0) {
//                if (uuid.length > 0) {
//                    [self.dic removeObjectForKey:uuid];
//                }
//                //删除
//                //[GeTuiSdk registerLiveActivity:laid activityToken:@"" sequenceNum:uuid];
//            }
//            if (uuid.length > 0 && ![self.dic.allKeys containsObject:uuid]) {
//                //新增
//                LiveModel *model = [LiveModel modelWithActivityId:laid token:token uuid:uuid];
//                self.dic[uuid] = model;
//                //[GeTuiSdk registerLiveActivity:laid activityToken:token sequenceNum:uuid];
//                //NSLog(@"向个推注册灵动岛, Activity laid:%@ token:%@ sn:%@", laid, token, uuid);
//            }
//            if ([self.dic.allKeys containsObject:uuid] && ![self.dic[uuid].token isEqualToString:token]) {
//                //更新
//                self.dic[uuid].token = token;
//                //[GeTuiSdk registerLiveActivity:laid activityToken:token sequenceNum:uuid];
//                //NSLog(@"向个推更新灵动岛, Activity laid:%@ token:%@ sn:%@", laid, token, uuid);
//            }
//        };
        
        if (self.segment.selectedSegmentIndex == 0) {
            [LiveActivityUtils startActivity1WithActivityId:laid];
        } else {
            [LiveActivityUtils startActivity2WithActivityId:laid];
        }
    }
}

- (IBAction)update {
    if (@available(iOS 16.1, *)) {
        self.state = (self.state + 1) % 4;
        if (self.segment.selectedSegmentIndex == 0) {
            [LiveActivityUtils updateActivityState1:self.state];
        } else {
            [LiveActivityUtils updateActivityState2:self.state];
        }
    }
}

- (IBAction)end {
    if (@available(iOS 16.1, *)) {
        if (self.segment.selectedSegmentIndex == 0) {
            [LiveActivityUtils endPreActivity1];
        } else {
            [LiveActivityUtils endPreActivity2];
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
@end
#endif
