//
//  GoodsVideoView.h
//  TianQin
//
//  Created by TianQin on 2019/7/16.
//  Copyright © 2019 TianQin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Masonry.h"

NS_ASSUME_NONNULL_BEGIN

@interface GoodsVideoView : UIView
@property (nonatomic,strong) AVPlayer *player;
@property (nonatomic,strong) AVPlayerItem *playerItem;
@property (nonatomic,strong) NSString *urlStr;
@property (nonatomic,strong) UIProgressView *progressView;
@property (nonatomic,strong) UIProgressView *progressViewBg;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UIButton *playBtn;
-(void)playUrl:(NSString *)url;
-(void)stop;
@end

NS_ASSUME_NONNULL_END
