//
//  ViewController.m
//  XYCacheManager
//
//  Created by billyye on 16/2/21.
//  Copyright © 2016年 billyye. All rights reserved.
//

#import "ViewController.h"
#import "TestModel.h"
#import "YCCacheManager.h"

@interface ViewController ()<UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) NSMutableArray *dataList;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubViews];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self layoutSubviews];
}

- (void)setupSubViews
{
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.addButton];
    [self.view addSubview:self.tableView];
}

- (void)layoutSubviews
{
    _tableView.frame = CGRectMake(0,0,CGRectGetWidth(self.view.frame),CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.addButton.frame));
    _addButton.frame = CGRectMake(0,CGRectGetMaxY(_tableView.frame),CGRectGetWidth(_tableView.frame) ,45);
}

#pragma mark - UI Getter Methods

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIButton *)addButton
{
    if (_addButton == nil) {
        
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton addTarget:self action:@selector(onAddButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _addButton.backgroundColor = [UIColor redColor];
        [_addButton setTitle:@"Add Row" forState:UIControlStateNormal];
    }
    return _addButton;
}

- (NSMutableArray *)dataList
{
    if (_dataList == nil) {
        
        id cacheObject = [[YCCacheManager shareManager] yc_objectForKey:@"cacheKey"];
        if (cacheObject && [cacheObject isKindOfClass:[NSArray class]]) {
            _dataList = [NSMutableArray arrayWithArray:cacheObject];
            
        } else {
            _dataList = [NSMutableArray array];
        }
    }
    
    return _dataList;
}

#pragma mark - Action Methods
- (void)onAddButtonClicked:(UIButton *)button
{
    TestModel *testModel = [[TestModel alloc] initWithDataDic:nil];
    testModel.title = [NSString stringWithFormat:@"第%zd Row",_dataList.count];
    testModel.subTitle = [NSString stringWithFormat:@"已缓存 %zd 个Row",_dataList.count];
    
    [self.dataList addObject:testModel];
    [_tableView reloadData];
    
    [[YCCacheManager shareManager] yc_setObject:_dataList forKey:@"cacheKey"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"reuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    }
    TestModel *testModel = [self.dataList objectAtIndex:indexPath.row];
    
    cell.textLabel.text = testModel.title;
    cell.detailTextLabel.text = testModel.subTitle;
    
    return cell;
}

@end
