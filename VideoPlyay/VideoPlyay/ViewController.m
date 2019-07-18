//
//  ViewController.m
//  VideoPlyay
//
//  Created by TianQin on 2019/7/18.
//  Copyright © 2019 TianQin. All rights reserved.
//

#import "ViewController.h"
#import "GoodsVideoView.h"
#define Screen_W [UIScreen mainScreen].bounds.size.width
@interface ViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong) GoodsVideoView *videoView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0];
    [self setUI];
    // Do any additional setup after loading the view.
}
-(void)setUI{
    
    UIScrollView *sv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 100, Screen_W, Screen_W)];
    sv.pagingEnabled = YES;
    sv.delegate = self;
    sv.showsHorizontalScrollIndicator = NO;
    sv.contentSize = CGSizeMake(Screen_W *3, Screen_W);
    [self.view addSubview:sv];
    
    for (int i = 0; i<3; i++) {
        CGRect frame = CGRectMake(Screen_W *i, 0, Screen_W, Screen_W);
        
        if (i == 0) {
//            http://220.249.115.46:18080/wav/day_by_day.mp4
//            http://220.249.115.46:18080/wav/Lovey_Dovey.mp4
            [self.videoView playUrl:@"http://220.249.115.46:18080/wav/no.9.mp4"];
            self.videoView.frame = frame;
            [sv addSubview:self.videoView];
        }else{
        UIImageView *im = [[UIImageView alloc]initWithFrame:frame];
            im.image = [UIImage imageNamed:@"img.jpg"];
        [sv addSubview:im];
        }
        
    }
    
}
-(GoodsVideoView *)videoView{
    if (!_videoView) {
        _videoView = [[GoodsVideoView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Screen_W)];
    }
    return _videoView;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth+1);
    if (page !=0 ) {
        [self.videoView stop];
    }
 
}
@end
