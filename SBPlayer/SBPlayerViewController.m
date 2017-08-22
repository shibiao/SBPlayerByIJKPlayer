//
//  SBPlayerViewController.m
//  SBPlayer
//
//  Created by sycf_ios on 2017/8/21.
//  Copyright © 2017年 shibiao. All rights reserved.
//

#import "SBPlayerViewController.h"

@interface SBPlayerViewController ()<SBControlViewDelegate>{
    NSTimer *_timer;
}

@property (nonatomic,strong) NSURL *url;
@property (nonatomic,strong) id<IJKMediaPlayback> player;
@property (nonatomic,strong) SBControlView *controlView;
@end

@implementation SBPlayerViewController
-(SBControlView *)controlView{
    if (!_controlView) {
        _controlView = [[SBControlView alloc]init];
        _controlView.value = 0.f;
        _controlView.currentTime = @"00:00";
        _controlView.totalTime = @"00:00";
        _controlView.bufferValue = 0.f;
        _controlView.delegate = self;
    }
    return _controlView;
}
-(instancetype)initWithURL:(NSURL *)url{
    self = [super init];
    if (self) {
        _url = url;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _url = [NSURL URLWithString:@"http://download.3g.joy.cn/video/236/60236937/1451280942752_hd.mp4"];
//    self.player = [[IJKAVMoviePlayerController alloc]initWithContentURL:self.url];
    IJKFFOptions *options = [IJKFFOptions optionsByDefault]; //使用默认配置
    
    //硬解
    [options setPlayerOptionIntValue:0 forKey:@"videotoolbox"];
    self.player = [[IJKFFMoviePlayerController alloc]initWithContentURL:_url withOptions:options];
    UIView *tmpView = self.player.view;
    [self.view addSubview:tmpView];
    
    [tmpView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    [tmpView addSubview:self.controlView];
    [self.controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(tmpView);
        make.height.mas_equalTo(@44);
    }];
    [self.player setScalingMode:IJKMPMovieScalingModeAspectFit];
    //添加消息中心
    [self addNotifications];
    [self addTimer];
    [self.player prepareToPlay];
//     [self.player play];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   
}
//添加计时器
-(void)addTimer{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
}
-(void)handleTimer:(NSTimer *)timer{
    self.controlView.currentTime = [self convertTime:(long)self.player.currentPlaybackTime];
    self.controlView.totalTime = [self convertTime:(long)self.player.duration];
//    NSLog(@"__%f",self.player.currentPlaybackTime);
    NSLog(@"___%f",self.player.playableDuration);
//    NSLog(@"____%lld",self.player.numberOfBytesTransferred);
    NSLog(@"_____%ld",(long)self.player.bufferingProgress);
    
}
//将数值转换成时间
- (NSString *)convertTime:(CGFloat)second{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (second/3600 >= 1) {
        [formatter setDateFormat:@"HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"mm:ss"];
    }
    NSString *showtimeNew = [formatter stringFromDate:d];
    return showtimeNew;
}
//添加消息中心
-(void)addNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:_player];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_player];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];


}

- (void)loadStateDidChange:(NSNotification*)notification {
    IJKMPMovieLoadState loadState = _player.loadState;
    
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        
        NSLog(@"LoadStateDidChange: IJKMovieLoadStatePlayThroughOK: %d\n",(int)loadState);
    }else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
    } else {
        NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
    }
}
- (void)moviePlayBackFinish:(NSNotification*)notification {
    int reason =[[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    switch (reason) {
        case IJKMPMovieFinishReasonPlaybackEnded:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonUserExited:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonPlaybackError:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %d\n", reason);
            break;
            
        default:
            NSLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}
- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification {

    NSLog(@"mediaIsPrepareToPlayDidChange\n");
}
- (void)moviePlayBackStateDidChange:(NSNotification*)notification {
    switch (_player.playbackState) {
        case IJKMPMoviePlaybackStateStopped:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStatePlaying:
            
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStatePaused:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStateInterrupted:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)_player.playbackState);
            break;
        }
            
        default: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)_player.playbackState);
            break;
        }
    }
}
- (void)removeMovieNotificationObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                                  object:_player];
    
}
-(void)deviceOrientationDidChange:(NSNotification *)notification{
    UIInterfaceOrientation _interfaceOrientation=[[UIApplication sharedApplication]statusBarOrientation];
    switch (_interfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
        {
//            [UIApplication sharedApplication].keyWindow.layer.anchorPoint = CGPointMake(kScreenWidth/2, kScreenHeight/2);
            self.view.contentMode = UIViewContentModeCenter;
            self.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
            [self.view bringSubviewToFront:self.view];
//            [[UIApplication sharedApplication].keyWindow addSubview:self.view];
//            self.view.transform = CGAffineTransformMakeRotation(0);
//            self.view.transform = CGAffineTransformRotate(self.view.transform, 0);
//            [UIView animateWithDuration:0.5 animations:^{
//                [self.view layoutIfNeeded];
//            }];
            
//            [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.edges.mas_equalTo([UIApplication sharedApplication].keyWindow);
////                make.center.mas_equalTo([UIApplication sharedApplication].keyWindow).priorityLow();
//            }];
//            [UIView animateKeyframesWithDuration:0.2 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeCubicPaced animations:^{
//                [self.view layoutIfNeeded];
//            } completion:nil];
        }
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
        case UIInterfaceOrientationPortrait:
        {
//            [self.view removeFromSuperview];
//            self.view.frame = CGRectZero;
            self.view.contentMode = UIViewContentModeCenter;
//            [self getCurrentVC].view.layer.anchorPoint = CGPointMake(kScreenWidth/2, kScreenHeight/2);
            self.view.frame = CGRectMake(0, 20, kScreenWidth, 250);
//            [[self getCurrentVC].view addSubview:self.view];
            
//            [self getCurrentVC].view.transform = CGAffineTransformIdentity;
//            [UIView animateWithDuration:0.5 animations:^{
//                [self.view layoutIfNeeded];
//            }];
            
            
//            [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.right.left.mas_equalTo([self getCurrentVC].view);
//                make.top.mas_equalTo([self getCurrentVC].view.mas_top).offset(20);
//                make.height.mas_equalTo(250);
//                
//            }];
//            [UIView animateKeyframesWithDuration:0.2 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeCubicPaced animations:^{
//                [self.view layoutIfNeeded];
//            } completion:nil];
//            self.view.layer.anchorPoint = CGPointMake(kScreenWidth/2, kScreenHeight/2);
//            self.view add
            
        }
            break;
        case UIInterfaceOrientationUnknown:
            NSLog(@"UIInterfaceOrientationUnknown");
            break;
    }
    
    
}
-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    return result;
}
/**
 点击UISlider获取点击点
 
 @param controlView 控制视图
 @param value 当前点击点
 */
-(void)controlView:(SBControlView *)controlView pointSliderLocationWithCurrentValue:(CGFloat)value{
    
}

/**
 拖拽UISlider的knob的时间响应代理方法
 
 @param controlView 控制视图
 @param slider UISlider
 */
-(void)controlView:(SBControlView *)controlView draggedPositionWithSlider:(UISlider *)slider {
    
}

/**
 点击放大按钮的响应事件
 
 @param controlView 控制视图
 @param button 全屏按钮
 */
-(void)controlView:(SBControlView *)controlView withLargeButton:(UIButton *)button{
    if (kScreenWidth<kScreenHeight) {
        [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
    }else{
        [self interfaceOrientation:UIInterfaceOrientationPortrait];
    }
}
//旋转方向
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector             = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val                  = orientation;
        
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    if (orientation == UIInterfaceOrientationLandscapeRight||orientation == UIInterfaceOrientationLandscapeLeft) {
        // 设置横屏
    } else if (orientation == UIInterfaceOrientationPortrait) {
        // 设置竖屏
    }else if (orientation == UIInterfaceOrientationPortraitUpsideDown){
        //
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
