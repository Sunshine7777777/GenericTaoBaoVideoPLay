//
//  GoodsVideoView.m
//  TianQin
//
//  Created by TianQin on 2019/7/16.
//  Copyright © 2019 TianQin. All rights reserved.
//

#import "GoodsVideoView.h"
#import <AVFoundation/AVFoundation.h>

@implementation GoodsVideoView
- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]init];
        _progressView.progressTintColor    = [UIColor orangeColor];
        _progressView.trackTintColor       = UIColor.clearColor;
    }
    return _progressView;
}
- (UIProgressView *)progressViewBg {
    if (!_progressViewBg) {
        _progressViewBg = [[UIProgressView alloc]init];
        _progressViewBg.progressTintColor    = [UIColor whiteColor];
        _progressViewBg.trackTintColor       = UIColor.clearColor;
    }
    return _progressViewBg;
}
-(UIButton *)playBtn{
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"video_play"] forState:0];
        [_playBtn setImage:[UIImage imageNamed:@"video_stop"] forState:UIControlStateSelected];
        [_playBtn addTarget:self action:@selector(playOrStop:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_playBtn];
        [_playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.size.mas_offset(CGSizeMake(29, 29));
        }];
    }
    return _playBtn;
}
-(void)playOrStop:(UIButton *)btn{
  //  [self.progressView setHidden:NO];

    if (_playBtn.selected) {
        [self.player pause];
    }else{
        if(self.progressView.progress == 1){

            [self.player seekToTime:kCMTimeZero toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
                self.progressView.progress = 0;
                [self.player play];
            }];
            [self.player play];

        }else{
        [self.player play];
        }
    }
    
      _playBtn.selected = !_playBtn.selected;
    [self performSelector:@selector(hidel) withObject:nil afterDelay:2];
}
-(void)stop{
    [self.player pause];
    self.playBtn.selected = NO;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        [self setUI];
        UITapGestureRecognizer *tapGesture1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidel)];
        [self addGestureRecognizer:tapGesture1];
    }
    return self;
}
-(void)hidel{
    _playBtn.hidden = !_playBtn.hidden;
}
-(void)playUrl:(NSString *)url{
    self.urlStr = url;
    self.player = [[AVPlayer alloc]initWithPlayerItem:[[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:self.urlStr]]];
    //    self.player = [[AVPlayer alloc]initWithURL:[NSURL URLWithString:self.urlStr]];
    AVPlayerLayer *avplayLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    avplayLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    avplayLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self.layer addSublayer:avplayLayer];
    
    [self.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self.player.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    UIView *progeeView = [UIView new];
    progeeView.backgroundColor = [UIColor colorWithWhite:.3 alpha:1];
    [self addSubview:progeeView];
    [progeeView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
        make.height.mas_offset(5);
    }];
    
    [progeeView addSubview:self.progressViewBg];
    
    [progeeView addSubview:self.progressView];
    
    [self.progressViewBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(progeeView).offset(0);
        make.top.equalTo(progeeView).offset(0);
        make.bottom.equalTo(progeeView).offset(0);
        make.width.mas_equalTo(progeeView).multipliedBy(1);
    }];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(progeeView).offset(0);
        make.top.equalTo(progeeView).offset(0);
        make.bottom.equalTo(progeeView).offset(0);
        make.width.mas_equalTo(progeeView).multipliedBy(1);
    }];
//    self.progressView.progress = .01;
//    self.progressViewBg.progress = .01;
    
    
    
    __weak typeof(self)WeakSelf = self;
    __strong typeof(WeakSelf) strongSelf = WeakSelf;
    [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1, NSEC_PER_SEC)
                                              queue:NULL
                                         usingBlock:^(CMTime time) {
                                             NSTimeInterval currentTime = CMTimeGetSeconds(time);
                                             //视频的总时间
                                             NSTimeInterval totalTime = CMTimeGetSeconds(WeakSelf.player.currentItem.duration);
                                             if (currentTime != 0) {
                                                 strongSelf.progressView.progress = currentTime/totalTime;

                                             }

                                             //进度 当前时间/总时间
                                            // CGFloat progress = CMTimeGetSeconds(WeakSelf.player.currentItem.currentTime) / CMTimeGetSeconds(WeakSelf.player.currentItem.duration);
                                             float f = CMTimeGetSeconds(WeakSelf.player.currentItem.duration) -  CMTimeGetSeconds(WeakSelf.player.currentItem.currentTime);
                                             NSLog(@"剩余时间: %f",f);
                                             //在这里截取播放进度并处理
                                             if (strongSelf.progressView.progress == 1.0f) {

                                                 //播放百分比为1表示已经播放完毕
                                                 WeakSelf.playBtn.selected = NO;
                                                 WeakSelf.playBtn.hidden = NO;
                                                 //处理成员变量在block中报警告问题
                                                 //                                                   strongSelf -> isplay = NO;
                                                 //改变播放按钮状态
                                                 //                                                   [WeakSelf.bottomPlayBtn setImage:[UIImage imageNamed:@"视频播放"] forState:UIControlStateNormal];
                                                 //停止并移除计时器
                                                 //                                                   [WeakSelf stopTimer];
                                                 //                                                   [WeakSelf removeTimer];
                                                 //强制竖屏
                                                 //                                                   [WeakSelf orientationToPortrait:UIInterfaceOrientationPortrait];
                                                 //                                                   [WeakSelf endView];
                                             }
                                             
                                         }];
    
 //   [self.progressView setHidden:YES];
}
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        //获取playerItem的status属性最新的状态
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue];
        switch (status) {
            case AVPlayerStatusReadyToPlay:{
                //获取视频长度
                CMTime duration = playerItem.duration;
                //更新显示:视频总时长(自定义方法显示时间的格式)
             //   CGFloat f =  CMTimeGetSeconds(duration);
               // NSLog(@"视频总时长%02d:%02d:%02d",(int)f/3600,((int)f%3600)/60,(int)f%60);
                //                self.totalNeedPlayTimeLabel.text = [self formatTimeWithTimeInterVal:CMTimeGetSeconds(duration)];
                //开启滑块的滑动功能
                // self.sliderView.enabled = YES;
                //关闭加载Loading提示
                //   [self showaAtivityInDicatorView:NO];
                //开始播放视频
//                [self.player play];
                [self.playBtn setHidden:NO];
                break;
            }
            case AVPlayerStatusFailed:{//视频加载失败，点击重新加载
                //  [self showaAtivityInDicatorView:NO];//关闭Loading视图
                //self.playerInfoButton.hidden = NO; //显示错误提示按钮，点击后重新加载视频
                //[self.playerInfoButton setTitle:@"资源加载失败，点击继续尝试加载" forState: UIControlStateNormal];
                break;
            }
            case AVPlayerStatusUnknown:{
                NSLog(@"加载遇到未知问题:AVPlayerStatusUnknown");
                break;
            }
            default:
                break;
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        //获取视频缓冲进度数组，这些缓冲的数组可能不是连续的
        NSArray *loadedTimeRanges = playerItem.loadedTimeRanges;
        //获取最新的缓冲区间
        CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
        //缓冲区间的开始的时间
        NSTimeInterval loadStartSeconds = CMTimeGetSeconds(timeRange.start);
        //缓冲区间的时长
        NSTimeInterval loadDurationSeconds = CMTimeGetSeconds(timeRange.duration);
        //当前视频缓冲时间总长度
        NSTimeInterval currentLoadTotalTime = loadStartSeconds + loadDurationSeconds;
        //        NSLog(@"开始缓冲:%f,缓冲时长:%f,总时间:%f", loadStartSeconds, loadDurationSeconds, currentLoadTotalTime);
        //更新显示：当前缓冲总时长
        //_currentLoadTimeLabel.text = [self formatTimeWithTimeInterVal:currentLoadTotalTime];
        //更新显示：视频的总时长
        //_totalNeedLoadTimeLabel.text = [self formatTimeWithTimeInterVal:CMTimeGetSeconds(self.player.currentItem.duration)];
        //更新显示：缓冲进度条的值
        _progressViewBg.progress = currentLoadTotalTime/CMTimeGetSeconds(self.player.currentItem.duration);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
