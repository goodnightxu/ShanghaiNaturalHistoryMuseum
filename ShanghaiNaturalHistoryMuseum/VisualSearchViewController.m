//
//  VisualSearchViewController.m
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Leon on 14/9/2.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import "VisualSearchViewController.h"
#import "DataManager.h"
#import "ExhibitItem.h"
#import "ResultViewController.h"

#import "LookStudyViewController.h"

@interface VisualSearchViewController ()
{
    NSString *_currentKey;
    ExhibitItem *_selectExhibitItem;
    
    
    ResultViewController *_resultVC;

}

@end

@implementation VisualSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

static NSString *reuseId = @"Cell";
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    //[self configNavigationBar];
    
    [self.tipTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseId];
    
    //
    [self.searchSV setContentSize:CGSizeMake(0, self.searchSV.frame.size.height +1)];
    
    //
    [self addKeyboard];

    
    [self hideTipListWithAnimaition:NO];
    
    //
    self.noFoundView.alpha = 0.0f;
}

- (void)viewWillAppear:(BOOL)animated{
    [self configNavigationBar];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

#pragma mark - Keyboard
- (void)addKeyboard
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}


- (void)onKeyboardShow:(NSNotification *)notification
{
    //键盘高度
    CGRect frame = ((NSValue *)notification.userInfo[@"UIKeyboardBoundsUserInfoKey"]).CGRectValue;
    [self.tipTableView setContentInset:UIEdgeInsetsMake(0, 0, frame.size.height, 0)];
    
    //
    [self.searchSV setContentOffset:CGPointMake(0, 74) animated:YES];
}

- (void)onKeyboardHide:(NSNotification *)notification
{
    [self.tipTableView setContentInset:UIEdgeInsetsZero];
    //
    [self.searchSV setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark - 隐藏 显示tipList
- (void)showTipList
{
    [UIView animateWithDuration:0.25 animations:^{
        self.tipTableView.transform = CGAffineTransformIdentity;
    }];
}

- (void)hideTipListWithAnimaition:(BOOL)ani
{
    if (ani) {
        [UIView animateWithDuration:0.25 animations:^{
            self.tipTableView.transform = CGAffineTransformMakeTranslation(self.tipTableView.frame.size.width+2, 0);
        }];
    }else{
        self.tipTableView.transform = CGAffineTransformMakeTranslation(self.tipTableView.frame.size.width+2, 0);
    }
    
}

#pragma mark - Search keyword
- (IBAction)onSearchKeyChange:(id)sender
{
    UITextField *searchTextField = (UITextField *)sender;
    
    __weak VisualSearchViewController *weakSelf = self;
    
    if (![searchTextField.text isEqualToString:_currentKey]) {
        
        _currentKey = searchTextField.text;
        //Clear
        if (searchTextField.text == nil || [searchTextField.text isEqualToString:@""]) {
            self.tips = nil;
            [self hideTipListWithAnimaition:YES];

            return;
        }
        
        //
        //静默
        [DataManager loadExhibitWithKeyword:_currentKey showHUD:NO inView:nil callback:^(NSArray *exhibits, BOOL success) {
   
            weakSelf.tips = exhibits;
            [weakSelf showTipList];
            [weakSelf.tipTableView reloadData];

        }];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self onSearchBt:nil];
    return YES;
}

#pragma mark SearchBt
- (void)onSearchBt:(id)sender{
    //
    if (self.searchTextField.text == nil || [self.searchTextField.text isEqualToString:@""])
    {
        return;
    }
    
    [self.searchTextField resignFirstResponder];
    
    //通过关键字搜索
    __weak VisualSearchViewController *weakSelf = self;
    [DataManager loadExhibitWithKeyword:self.searchTextField.text showHUD:YES inView:self.contentView callback:^(NSArray *exhibits, BOOL success) {

        
        if (success && exhibits.count !=0) {
            
            ExhibitItem *exhibitItem = exhibits[0];
            [DataManager loadRelationWithExhibit:exhibitItem callback:^(NSArray *exhibits, BOOL success) {
                //
                if (success && exhibits.count != 0) {
                    //
                    [weakSelf addResultWithExhibitItem:exhibitItem relationItems:exhibits];
                }else
                {
                    //不可能没有远亲、近邻
                }
            }];
        }else{
            [self showNoFound];
        }
        
    }];
}


#pragma mark -  提示 TableView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 270, 42)];
    sectionView.backgroundColor = [UIColor whiteColor];
    UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 20, 250, 22)];
    sectionLabel.text = @"你是否想找";
    sectionLabel.textColor = Color(255, 132, 20, 1);
    sectionLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:18];
    [sectionView addSubview:sectionLabel];
    
    return sectionView;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tips.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId forIndexPath:indexPath];
    
    ExhibitItem *exhibitItem = self.tips[indexPath.row];

    
    cell.textLabel.text = exhibitItem.name;
    cell.textLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:18];
    cell.textLabel.textColor = Color(102, 102, 102, 1);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //
    [self.searchTextField resignFirstResponder];
    //
    ExhibitItem *exhibitItem = self.tips[indexPath.row];
    _selectExhibitItem = exhibitItem;
    self.searchTextField.text = exhibitItem.name;
    
    //通过ExhibitItem搜索
    
    __weak VisualSearchViewController *weakSelf = self;

    
    [DataManager loadRelationWithExhibit:exhibitItem callback:^(NSArray *exhibits, BOOL success) {
        if (success && exhibits.count != 0) {
            //
            [weakSelf addResultWithExhibitItem:exhibitItem relationItems:exhibits];
        }else{
            //不可能没有远亲、近邻
        }
    }];
     
}


#pragma mark - 搜索结果显示
#pragma mark 没有找到
- (void)showNoFound
{
    [self hideTipListWithAnimaition:YES];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.noFoundView.alpha = 1.0f;
        _resultVC.view.alpha = 0.0f;
    }completion:^(BOOL finished) {
        [self removeResultVC];
    }];
}

- (void)hideNoFound
{
    [UIView animateWithDuration:0.25 animations:^{
        self.noFoundView.alpha = 0.0f;
    }];
}

#pragma mark 显示找到
- (void)addResultWithExhibitItem:(ExhibitItem *)exhibitItem relationItems:(NSArray *)relationItems
{
    [self hideNoFound];
    [self hideTipListWithAnimaition:YES];
    
    if (_resultVC != nil) {
        [self removeResultVC];
    }
    
    _resultVC = [[ResultViewController alloc] initWihtExhibitItem:exhibitItem relationItems:relationItems];
    _resultVC.view.frame = CGRectMake(0, 0, 1024-270, 658);
    [self addChildViewController:_resultVC];
    [self.contentView insertSubview:_resultVC.view belowSubview:_tipTableView];
    [_resultVC didMoveToParentViewController:self];
    
    
    __weak VisualSearchViewController *weakSelf = self;
    [_resultVC setOnStoryBt:^(ExhibitItem *detailItem){
        
        [DataManager loadSpecimenWithSpecimenId:detailItem.sepicmenId callback:^(SpecimenItem *specimenItem, BOOL success) {
            if (success) {
                LookStudyViewController *lookStudyVC=[[LookStudyViewController alloc] initWithNibName:@"LookStudyViewController" bundle:nil];
                lookStudyVC.item=specimenItem;
                [weakSelf.navigationController pushViewController:lookStudyVC animated:YES];

            }
        }];
    }];
    
    
    [_resultVC setOnLocateBt:^(InfoItem *infoItem) {
        {
            if (weakSelf.onLocate !=nil) {
                weakSelf.onLocate(infoItem);
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
            
        }
    }];
}

- (void)removeResultVC
{
    if (_resultVC == nil) {
        return;
    }
    
    [_resultVC willMoveToParentViewController:nil];
    [_resultVC.view removeFromSuperview];
    [_resultVC removeFromParentViewController];
    _resultVC = nil;
}

#pragma mark - StatusBar
//ios7 隐藏StatusBar
- (BOOL)prefersStatusBarHidden
{
    return YES;
}


@end
