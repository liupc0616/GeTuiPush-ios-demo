//
//  AdvanceViewController.m
//  GtSdkDemo
//
//  Created by ak on 2020/03/20.
//  Copyright © 2019 Gexin Interactive (Beijing) Network Technology Co.,LTD. All rights reserved.
//
#import <WidgetKit/WidgetKit.h>
#import "AdvanceViewController.h"
#import "AliasViewController.h"
#import "AliasUnbindViewController.h"
#import "TagViewController.h"
#import "BadgeViewController.h"
#import "MessageViewController.h"
#import "LiveActivityViewController.h"
#import "GtSdkDemo-Swift.h"

@interface AdvanceViewController ()
@property (nonatomic, weak) IBOutlet UIView *bindAliasView;
@property (nonatomic, weak) IBOutlet UIView *unbindAliasView;
@property (nonatomic, weak) IBOutlet UIView *setTagView;
@property (nonatomic, weak) IBOutlet UIView *sendMessageView;
@property (nonatomic, weak) IBOutlet UIView *setBadgeView;
@property (nonatomic, weak) IBOutlet UIView *resetBadgeView;
@property (nonatomic, weak) IBOutlet UILabel *sdkStateLabel;
@property (nonatomic, weak) IBOutlet UISwitch *runBackgroundEnableSwitch;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *liveActivityView;
@property (nonatomic, weak) IBOutlet UIView *controlsView;

@end

@implementation AdvanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"高级功能";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateStatusView) name:GTSdkStateNotification object:nil];
    [self addGestureRecognizer];
//    [self updateStatusView];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateStatusView {
    SdkStatus status = [GeTuiSdk status];
    switch (status) {
        case SdkStatusStarted:
            self.sdkStateLabel.text = @"启动";
            break;
        case SdkStatusStarting:
            self.sdkStateLabel.text = @"正在启动";
            break;
        default:
            self.sdkStateLabel.text = @"停止";
            break;
    }
}

- (void)addGestureRecognizer {
    [self.bindAliasView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bindAliasClick)]];
    [self.unbindAliasView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(unBindAliasClick)]];
    [self.setTagView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setTagClick)]];
    [self.sendMessageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendMessageClick)]];
    [self.setBadgeView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setBadgeClick)]];
    [self.resetBadgeView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetBadgeClick)]];
    [self.liveActivityView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(liveActivityClick)]];
    [self.controlsView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(controlsClick)]];
    
}

// MARK: Click Action

- (void)bindAliasClick {
    [self.navigationController pushViewController:[AliasViewController new] animated:NO];
}

- (void)unBindAliasClick {
    [self.navigationController pushViewController:[AliasUnbindViewController new] animated:NO];
}

- (void)setTagClick {
    [self.navigationController pushViewController:[TagViewController new] animated:NO];
}

- (void)sendMessageClick {
    [self.navigationController pushViewController:[MessageViewController new] animated:NO];
}

- (void)setBadgeClick {
    [self.navigationController pushViewController:[BadgeViewController new] animated:NO];
}

- (void)resetBadgeClick {
    [GeTuiSdk resetBadge];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [Utils AlertControllerWithTitle:@"复位角标成功" andMessage:@""];
}

- (IBAction)runBackgroundEnable:(id)sender {
    [GeTuiSdk runBackgroundEnable:self.runBackgroundEnableSwitch.on];
}

- (void)liveActivityClick {
#if !TARGET_OS_MACCATALYST
    [self.navigationController pushViewController:[LiveActivityViewController new] animated:NO];
#endif
}

- (void)controlsClick {
    if (@available(iOS 18.0, *)) {
        [ControlsCenterUtils getTokens:^(NSDictionary<NSString *,NSString *> * _Nonnull tokens) {
            [GeTuiSdk registerControlsTokens:tokens sequenceNum:@"sn1"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [Utils AlertControllerWithTitle:@"注册Controls Token" andMessage:[tokens debugDescription]];
            });
        }];
    }
}

@end
