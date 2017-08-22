//
//  SBPlayerViewController.h
//  SBPlayer
//
//  Created by sycf_ios on 2017/8/21.
//  Copyright © 2017年 shibiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "SBControlView.h"
#import <Masonry.h>

@interface SBPlayerViewController : UIViewController

//@property(nonatomic)            NSTimeInterval currentPlaybackTime;
//@property(nonatomic, readonly)  NSTimeInterval duration;
//@property(nonatomic, readonly)  NSTimeInterval playableDuration;
//@property(nonatomic, readonly)  NSInteger bufferingProgress;
//
//@property(nonatomic, readonly)  BOOL isPreparedToPlay;
-(instancetype)initWithURL:(NSURL *)url;
//-(void)play;
//-(void)pause;
//-(void)stop;
//-(void)isPlaying;
//-(void)shutdown;
//-(void)setPauseInBackground:(BOOL)pause;
@end
