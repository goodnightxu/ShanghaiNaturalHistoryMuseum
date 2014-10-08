//
//  LookStudyViewController.m
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Michael Lu on 14-9-27.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import "LookStudyViewController.h"
#import "DataManager.h"
#import "PublicMethod.h"
#import "MovieControlView.h"
#import <MediaPlayer/MediaPlayer.h>

@interface LookStudyViewController ()<UIScrollViewDelegate,MovieControlViewDelegate> {
    IBOutlet UIScrollView *lookScrollView;
    IBOutlet UIView *studyView;
    IBOutlet UIImageView *studyBackImageview;
    IBOutlet UIImageView *studyBackImageview1;
    IBOutlet UIScrollView *studyScrollView;
    IBOutlet UIButton *ShowAnswerBtn;
    IBOutlet UIButton *showStudyBtn;
    MPMoviePlayerController *moviePlayer;
    CGRect defaultFrame;
    IBOutlet UIView *movieBackView;
    MovieControlView *movieContr;
    NSTimer *mytimer;
    BOOL isMovieFinished;
    NSArray *studyImageArray;
}

@end

@implementation LookStudyViewController


@synthesize item;



-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [moviePlayer stop];
    moviePlayer=nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:movieContr];
    
    [mytimer invalidate];
    mytimer=nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    movieBackView.hidden=YES;
    lookScrollView.hidden=YES;
    
    [self configNavigationBar];
    
    if (item.lookPics.count>0) {
        NSMutableArray *requests=[[NSMutableArray alloc] init];
        if (item.lookPics.count>0) {
            for (NSString *picString in item.lookPics) {
                NSString *urlString = [NSString stringWithFormat:@"http://211.144.107.201:9090/museum/%@", picString];
                DataRequest *request=[DataRequest requestWithURL:[NSURL URLWithString:urlString]];
                [requests addObject:request];
            }
        }
        DataQueue *queue=[LXDataManager requestWithRequests:requests callback:^(DataQueue *result, BOOL success) {
            if (success) {
                NSMutableArray *looks=[[NSMutableArray alloc] init];
                for (DataRequest *result1 in result.requests) {
                    [looks addObject:[UIImage imageWithData:result1.responseData]];
                }
                
                movieBackView.hidden=YES;
                lookScrollView.hidden=NO;
                for (int i=0; i<looks.count; i++) {
                    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 658*i, 1024, 658)];
                    imageView.image=(UIImage *)[looks objectAtIndex:i];
                    [lookScrollView addSubview:imageView];
                }
                
                lookScrollView.contentSize=CGSizeMake(1024, 658*looks.count);
            }
        } ];
        
        queue.hud.mode = MBProgressHUDModeAnnularDeterminate;
        queue.cache = YES;
        [queue go];
        
        
       
    } else {
        if (item.lookVideoPath && item.lookVideoPath.length>0) {
             NSMutableArray *requests=[[NSMutableArray alloc] init];
            NSString *urlString = [NSString stringWithFormat:@"http://211.144.107.201:9090/museum/%@", item.lookVideoPath];
            DataRequest *request=[DataRequest requestWithURL:[NSURL URLWithString:urlString]];
            NSString *videoPath=[VIDEO_PATH stringByAppendingPathComponent:[[item.lookVideoPath componentsSeparatedByString:@"/"] lastObject]];
            request.downloadDestinationPath=videoPath;
            [requests addObject:request];
            DataQueue *queue=[LXDataManager requestWithRequests:requests callback:^(DataQueue *result, BOOL success) {
                if (success) {
                    movieBackView.hidden=NO;
                    lookScrollView.hidden=YES;
                    
                    //
                    
                    //        if ([videoPath rangeOfString:@"m4v"].length>0 || [videoPath rangeOfString:@"mov"].length>0 || [videoPath rangeOfString:@"mp4"].length>0 || [videoPath rangeOfString:@"3gp"].length>0) {
                    CGFloat videoWidth =  700.f;
                    CGFloat videoHeight = 535.f;
                    defaultFrame = CGRectMake(self.view.frame.size.width/2 - videoWidth/2, self.view.frame.size.height/2 - videoHeight/2, videoWidth, videoHeight);
                    moviePlayer = [[MPMoviePlayerController alloc] init];
                    moviePlayer.controlStyle=MPMovieControlStyleNone;
                    //            moviePlayer.delegate = self; //IMPORTANT!
                    moviePlayer.view.frame=CGRectMake(movieBackView.frame.size.width/2-614/2, 94, 614, 421);
                    
                    [movieBackView addSubview:moviePlayer.view];
                    
                    movieContr=[[MovieControlView alloc] initWithTitle:item.name];
                    movieContr.delegate=self;
                    [movieBackView addSubview:movieContr];
                    
                    
                    //            [moviePlayer setContentURL:[NSURL fileURLWithPath:videoPath]];
#warning 下载的视频格式不对，暂时手动修改测试
                    [moviePlayer setContentURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"popeye" ofType:@"mp4"]]];
                    [moviePlayer play];
                    isMovieFinished=NO;
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(knowDuration:) name:MPMoviePlayerReadyForDisplayDidChangeNotification object:nil];
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
                    
                    //        } else {
                    //            
                    //            [PublicMethod HUDOnlyLabelForView:self.view
                    //                                  withMessage:@"视频格式不正确，无法播放"];
                    //        }
                    

                 
                }
            } ];
            
            queue.hud.mode = MBProgressHUDModeAnnularDeterminate;
            queue.cache = YES;
            [queue go];

        }
    }
    

}




-(IBAction)clickBtn:(UIButton *)sender {
    if (sender.tag==1) {//will show study
        [moviePlayer pause];
        [mytimer setFireDate:[NSDate distantFuture]];
        movieContr.pauseBtn.selected=YES;
        
        NSMutableArray *requests=[[NSMutableArray alloc] init];
        if (item.studyPics.count>0) {
            for (NSString *picString in item.studyPics) {
                NSString *urlString = [NSString stringWithFormat:@"http://211.144.107.201:9090/museum/%@", picString];
                DataRequest *request=[DataRequest requestWithURL:[NSURL URLWithString:urlString]];
                [requests addObject:request];
            }
        }
        DataQueue *queue=[LXDataManager requestWithRequests:requests callback:^(DataQueue *result, BOOL success) {
            if (success) {
                NSMutableArray *studys=[[NSMutableArray alloc] init];
                for (DataRequest *result1 in result.requests) {
                    [studys addObject:[UIImage imageWithData:result1.responseData]];
                }
                studyImageArray=[NSArray arrayWithArray:studys];
                if (studyImageArray.count>=3) {
                    ShowAnswerBtn.titleLabel.font=[UIFont fontWithName:LanTingHei size:18.0f];
                    
                    studyBackImageview.image=(UIImage *)[studyImageArray objectAtIndex:0];
                    
                    UIImage *image=(UIImage *)[studyImageArray objectAtIndex:2];
                    UIImageView *imageView=[[UIImageView alloc] initWithImage:image];
                    imageView.frame=CGRectMake(0, 0, image.size.width/2, image.size.height/2);
                    studyScrollView.frame=CGRectMake(1024/2-imageView.frame.size.width/2, -658, imageView.frame.size.width, 658);
                    [studyScrollView addSubview:imageView];
                    studyScrollView.contentSize=CGSizeMake(0, imageView.frame.size.height);
                } else {
                    studyView.hidden=YES;
                    showStudyBtn.hidden=YES;
                }
                [UIView animateWithDuration:0.25f
                                 animations:^{
                                     studyView.center=lookScrollView.center;
                                 }
                                 completion:nil];
          
            }
        } ];
        
        queue.hud.mode = MBProgressHUDModeAnnularDeterminate;
        queue.cache = YES;
        [queue go];
       
    } else if (sender.tag==2) {//will show look
        [UIView animateWithDuration:0.25f
                         animations:^{
                             studyView.center=CGPointMake(lookScrollView.center.x+1024, lookScrollView.center.y);
                         }
                         completion:nil];
    }  else if (sender.tag==3) {
        ShowAnswerBtn.enabled=NO;
        [ShowAnswerBtn setTitle:@"了解更多" forState:UIControlStateNormal];
        [UIView animateWithDuration:0.25f
                         animations:^{
                             studyBackImageview1.alpha=1;
                             studyBackImageview1.image=(UIImage *)[studyImageArray objectAtIndex:1];
                         }
                         completion:^(BOOL finished) {
                             ShowAnswerBtn.tag=4;
                             ShowAnswerBtn.enabled=YES;
                         }];
    }  else if (sender.tag==4) {
        ShowAnswerBtn.enabled=NO;
        [UIView animateWithDuration:0.25f
                         animations:^{
                             studyScrollView.center=studyBackImageview.center;
                             ShowAnswerBtn.alpha=0;
                         }
                         completion:nil];

    }
}
-(void)videoDidFinish:(NSNotification *)note {
    [mytimer invalidate];
    mytimer=nil;
    [movieContr finish];
    isMovieFinished=YES;
}
-(void)knowDuration:(NSNotification *)note {
    movieContr.movieDuration=moviePlayer.playableDuration;
    [moviePlayer setCurrentPlaybackTime:0];
    mytimer=[NSTimer scheduledTimerWithTimeInterval:1.0F
                                             target:self
                                           selector:@selector(timerSelector)
                                           userInfo:nil
                                            repeats:YES];
}
-(void)timerSelector {
    [movieContr showCurrentTime:moviePlayer.playableDuration-moviePlayer.currentPlaybackTime];
}
#pragma mark - UIScrollViewDelegate
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    if (scrollView.tag==1) {
//        NSInteger index = fabs(scrollView.contentOffset.x)/scrollView.frame.size.width;
//        pageCon.currentPage=index;
//    }
}


#pragma mark - MovieControlViewDelegate
//YES表示放大，NO表示缩小
-(void)videoNeedResizeToBig:(BOOL)flag button:(UIButton *)btn {
    if (flag) {
        [UIView animateWithDuration:0.25 animations:^{
            moviePlayer.view.frame=CGRectMake(0, 0, 1024, 658);
        } completion:^(BOOL finished) {
             btn.enabled=YES;
         }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            moviePlayer.view.frame=CGRectMake(movieBackView.frame.size.width/2-614/2, 94, 614, 421);
        } completion:^(BOOL finished) {
            btn.enabled=YES;
        }];
    }
}

//YES表示暂停，NO表示继续播放
-(void)videoNeedPause:(BOOL)flag button:(UIButton *)btn {
    if (flag) {
        [moviePlayer pause];
        [mytimer setFireDate:[NSDate distantFuture]];
        btn.enabled=YES;
    } else {
        if (isMovieFinished) {
            [self knowDuration:nil];
        }
        [moviePlayer play];
        [mytimer setFireDate:[NSDate date]];
        btn.enabled=YES;
    }
}


#pragma mark - MoviePlayerControllerDelegate
//IMPORTANT!
//- (void)moviePlayerWillMoveFromWindow {
//    //movie player must be readded to this view upon exiting fullscreen mode.
//    if (![self.view.subviews containsObject:moviePlayer.view])
//        [self.view addSubview:moviePlayer.view];
//    
//    //you MUST use [ALMoviePlayerController setFrame:] to adjust frame, NOT [ALMoviePlayerController.view setFrame:]
//    [moviePlayer setFrame:defaultFrame];
//}
//
//- (void)movieTimedOut {
//    NSLog(@"MOVIE TIMED OUT");
//}





#pragma mark - Navigation Bar
- (void)configNavigationBar
{
    
    CustomNavigationController *nav = (CustomNavigationController *)self.navigationController;
    nav.subTopTitle = nil;
    nav.subBottomTitle = nil;
    
    FRDLivelyButton *menuBt = [[FRDLivelyButton alloc] initWithFrame:CGRectMake(0, 0, kNavButtonItemWidth, kNavButtonItemHeight)];
    [menuBt setStyle:kFRDLivelyButtonStyleArrowLeft animated:NO];
    [menuBt addTarget:self action:@selector(onMenuBt:) forControlEvents:UIControlEventTouchUpInside];
    [menuBt setOptions:@{kFRDLivelyButtonLineWidth:@3.0f, kFRDLivelyButtonColor: Color(206.f, 206.0f, 206.0f, 1.0f)}];
    nav.barButton = menuBt;
}
- (void)onMenuBt:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - StatusBar
//ios7 隐藏StatusBar
- (BOOL)prefersStatusBarHidden
{
    return YES;
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
