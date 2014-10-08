//
//  MenuList.m
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Leon on 14/8/28.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import "MenuList.h"

@implementation MenuItem

@end

@interface MenuList ()

@end

//
#define kBottomViewHeight 130.0f
//
#define kCellHeight 50.0f

#define kLeftPadding 20.0f


@implementation MenuList

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


static NSString *reuseId = @"Cell";
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //Menu
    MenuItem *menuItem1 = [[MenuItem alloc] init];
    menuItem1.title = @"参观路线";
    menuItem1.iconName = @"pathIcon.png";
    
    MenuItem *menuItem2 = [[MenuItem alloc] init];
    menuItem2.title = @"学习单";
    menuItem2.iconName = @"studyIcon.png";
    
    MenuItem *menuItem3 = [[MenuItem alloc] init];
    menuItem3.title = @"互动社区";
    menuItem3.iconName = @"interactIcon.png";
    
    MenuItem *menuItem4 = [[MenuItem alloc] init];
    menuItem4.title = @"可视化搜索";
    menuItem4.iconName = @"searchIcon.png";
    
    MenuItem *menuItem5 = [[MenuItem alloc] init];
    menuItem5.title = @"预约查询";
    menuItem5.iconName = @"appointIcon.png";
    
    MenuItem *menuItem6 = [[MenuItem alloc] init];
    menuItem6.title = @"寻宝游戏";
    menuItem6.iconName = @"gameIcon.png";
    
    MenuItem *menuItem7 = [[MenuItem alloc] init];
    menuItem7.title = @"系统管理";
    menuItem7.iconName = @"settingIcon.png";

    self.datas = @[menuItem1, menuItem2, menuItem3, menuItem4, menuItem5, menuItem6, menuItem7];

    //
    [self initializeTableView];
    //
    [self initializeBottomView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 底部信息
- (void)initializeBottomView
{
    CGSize size = [Help viewSize:self.view];
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, size.height - kBottomViewHeight-200, size.width, kBottomViewHeight)];
    [self.tableView addSubview:bottomView];
    
    CGSize bottomSize = bottomView.bounds.size;
    
    //About us
    UIButton *aboutUsBt = [UIButton buttonWithType:UIButtonTypeCustom];
    aboutUsBt.frame = CGRectMake(kLeftPadding, 0, bottomSize.width, 22);
    [aboutUsBt setTitle:@"关于我们" forState:UIControlStateNormal];
    [aboutUsBt setTitleColor:Color(153.0f, 153.0f, 153.0f, 1.0f) forState:UIControlStateNormal];
    aboutUsBt.titleLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:12];
    [aboutUsBt sizeToFit];
    [aboutUsBt addTarget:self action:@selector(onAboutUsBt) forControlEvents:UIControlEventTouchUpInside];
    
    [bottomView addSubview:aboutUsBt];
    
    //Office web
    UIButton *officeWebBt = [UIButton buttonWithType:UIButtonTypeCustom];
    officeWebBt.frame = CGRectMake(kLeftPadding, 32, bottomSize.width, 22);
    [officeWebBt setTitle:@"博物馆官网" forState:UIControlStateNormal];
    [officeWebBt setTitleColor:Color(153.0f, 153.0f, 153.0f, 1.0f) forState:UIControlStateNormal];
    officeWebBt.titleLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:12];
    [officeWebBt sizeToFit];
    [officeWebBt addTarget:self action:@selector(onOfficeWebBt) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:officeWebBt];
    
    
    //Ver
    UILabel *verLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLeftPadding,70, bottomSize.width, bottomSize.height)];
    verLabel.numberOfLines = 3;
    verLabel.text = @"© 2014\r\nShanghai Natural History Museum\r\nAll Rights reserved.";
    verLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
    verLabel.textColor = Color(206.0f, 206.0f, 206.0f, 1.0);
    [verLabel sizeToFit];
    [bottomView addSubview:verLabel];
    
}

#pragma  mark - TableView Config
- (void)initializeTableView
{
    //左侧效果
    self.tableView.clipsToBounds = NO;
    CGSize size = [Help viewSize:self.tableView];
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    bg.layer.shadowColor = [UIColor blackColor].CGColor;
    bg.layer.shadowOpacity = 0.05f;
    bg.layer.shadowOffset = CGSizeMake(-3, 0);
    self.tableView.backgroundView = bg;
    
    //下划线
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, size.height)];
    bottomLine.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.25];
    [bg addSubview:bottomLine];
    //
    self.tableView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    //
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseId];
    

}

#pragma mark - Button
- (void)onAboutUsBt
{
    NSLog(@"on AboutUs");
}

- (void)onOfficeWebBt
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kOfficeWebUrl]];
}

#pragma mark - Table View

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId forIndexPath:indexPath];
    
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    MenuItem *menuItem = self.datas[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:menuItem.iconName];
    
    //Title
    cell.textLabel.text = menuItem.title;
    cell.textLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:15.0];
    cell.textLabel.textColor = Color(102.0f, 102.0f, 102.0f, 1.0f);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuItem *menuItem = self.datas[indexPath.row];
    self.selectedMenu(menuItem);
}
@end
