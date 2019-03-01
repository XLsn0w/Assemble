
#import "XLsn0wPullMenu.h"
#import "XLsn0wPullMenuCell.h"
#import "XLsn0wPullMenuModel.h"

#define VIEW_CENTER(aView)       ((aView).center)
#define VIEW_CENTER_X(aView)     ((aView).center.x)
#define VIEW_CENTER_Y(aView)     ((aView).center.y)

#define FRAME_ORIGIN(aFrame)     ((aFrame).origin)
#define FRAME_X(aFrame)          ((aFrame).origin.x)
#define FRAME_Y(aFrame)          ((aFrame).origin.y)

#define FRAME_SIZE(aFrame)       ((aFrame).size)
#define FRAME_HEIGHT(aFrame)     ((aFrame).size.height)
#define FRAME_WIDTH(aFrame)      ((aFrame).size.width)



#define VIEW_BOUNDS(aView)       ((aView).bounds)

#define VIEW_FRAME(aView)        ((aView).frame)

#define VIEW_ORIGIN(aView)       ((aView).frame.origin)
#define VIEW_X(aView)            ((aView).frame.origin.x)
#define VIEW_Y(aView)            ((aView).frame.origin.y)

#define VIEW_SIZE(aView)         ((aView).frame.size)
#define VIEW_HEIGHT(aView)       ((aView).frame.size.height)
#define VIEW_WIDTH(aView)        ((aView).frame.size.width)


#define VIEW_X_Right(aView)      ((aView).frame.origin.x + (aView).frame.size.width)
#define VIEW_Y_Bottom(aView)     ((aView).frame.origin.y + (aView).frame.size.height)






#define AnimateTime 0.25f   // 下拉动画时间



@implementation XLsn0wPullMenu {
    UIImageView * _arrowMark;   // 尖头图标
    UIView      * _listView;    // 下拉列表背景View
    UITableView * _tableView;   // 下拉列表
    
    NSArray     * _titleArr;    // 选项数组
    CGFloat       _rowHeight;   // 下拉列表行高
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createMainBtnWithFrame:frame];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self createMainBtnWithFrame:frame];
}

- (void)createMainBtnWithFrame:(CGRect)frame {
    [_mainBtn removeFromSuperview];
    _mainBtn = nil;
    
    // 主按钮 显示在界面上的点击按钮
    // 样式可以自定义
    _mainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_mainBtn];
    [_mainBtn setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [_mainBtn addTarget:self action:@selector(clickMainBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [_mainBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [_mainBtn setTitle:@"请选择" forState:UIControlStateNormal];
//    _mainBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    _mainBtn.titleLabel.font    = [UIFont systemFontOfSize:14.f];
//    _mainBtn.titleEdgeInsets    = UIEdgeInsetsMake(0, 15, 0, 0);
//    _mainBtn.selected           = NO;
//    _mainBtn.backgroundColor    = [UIColor whiteColor];
//    _mainBtn.layer.borderColor  = [UIColor blackColor].CGColor;
//    _mainBtn.layer.borderWidth  = 1;
    [_mainBtn setBackgroundImage:[UIImage imageNamed:@"My_devBtn"] forState:(UIControlStateNormal)];

    // 旋转尖头
    _arrowMark = [[UIImageView alloc] initWithFrame:CGRectMake(_mainBtn.frame.size.width - 15, 0, 9, 9)];
    _arrowMark.center = CGPointMake(VIEW_CENTER_X(_arrowMark), VIEW_HEIGHT(_mainBtn)/2);
    _arrowMark.image  = [UIImage imageNamed:@"XLsn0wPullMenu_Arrow.png"];
    [_mainBtn addSubview:_arrowMark];
}


- (void)setMenuTitles:(NSArray *)titlesArr rowHeight:(CGFloat)rowHeight{
    
    if (self == nil) {
        return;
    }
    
    _titleArr  = [NSArray arrayWithArray:titlesArr];
    _rowHeight = rowHeight;

    
    // 下拉列表背景View
    _listView = [[UIView alloc] init];
    _listView.frame = CGRectMake(VIEW_X(self) , VIEW_Y_Bottom(self), VIEW_WIDTH(self),  0);
    _listView.clipsToBounds       = YES;
    _listView.layer.masksToBounds = NO;
    _listView.layer.borderColor   = [UIColor lightTextColor].CGColor;
    _listView.layer.borderWidth   = 0.5f;

    
    // 下拉列表TableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,VIEW_WIDTH(_listView), VIEW_HEIGHT(_listView))];
    _tableView.delegate        = self;
    _tableView.dataSource      = self;
    _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    _tableView.bounces         = NO;
    [_listView addSubview:_tableView];
    
    [_tableView xlsn0w_addBorderColor:[UIColor xlsn0w_hexString:@"#FF6600"] borderWidth:0.5];
    [_listView xlsn0w_addBorderColor:[UIColor xlsn0w_hexString:@"#FF6600"] borderWidth:0.5];
    [_tableView xlsn0w_addCornerRadius:5];
    [_listView xlsn0w_addCornerRadius:5];
}

- (void)clickMainBtn:(UIButton *)button {
    [self.superview addSubview:_listView]; // 将下拉视图添加到控件的俯视图上
    
    if(button.selected == NO) {
        [self show];
    } else {
        [self hide];
    }
}

- (void)show {   // 显示下拉列表
    
    [_listView.superview bringSubviewToFront:_listView]; // 将下拉列表置于最上层
    
    
    
    if ([self.delegate respondsToSelector:@selector(dropdownMenuWillShow:)]) {
        [self.delegate dropdownMenuWillShow:self]; // 将要显示回调代理
    }
    
    
    [UIView animateWithDuration:AnimateTime animations:^{
        
        _arrowMark.transform = CGAffineTransformMakeRotation(M_PI);
        _listView.frame  = CGRectMake(VIEW_X(_listView), VIEW_Y(_listView), VIEW_WIDTH(_listView), 30*4);
        _tableView.frame = CGRectMake(0, 0, VIEW_WIDTH(_listView), VIEW_HEIGHT(_listView));
        
    }completion:^(BOOL finished) {
        
        if ([self.delegate respondsToSelector:@selector(dropdownMenuDidShow:)]) {
            [self.delegate dropdownMenuDidShow:self]; // 已经显示回调代理
        }
    }];
    
    
    _mainBtn.selected = YES;
}

- (void)hide {  // 隐藏下拉列表
    if ([self.delegate respondsToSelector:@selector(dropdownMenuWillHidden:)]) {
        [self.delegate dropdownMenuWillHidden:self]; // 将要隐藏回调代理
    }

    [UIView animateWithDuration:AnimateTime animations:^{
        _arrowMark.transform = CGAffineTransformIdentity;
        _listView.frame  = CGRectMake(VIEW_X(_listView), VIEW_Y(_listView), VIEW_WIDTH(_listView), 0);
        _tableView.frame = CGRectMake(0, 0, VIEW_WIDTH(_listView), VIEW_HEIGHT(_listView));
        
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(dropdownMenuDidHidden:)]) {
            [self.delegate dropdownMenuDidHidden:self]; // 已经隐藏回调代理
        }
    }];
    
    _mainBtn.selected = NO;
}

#pragma mark - UITableView Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _rowHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_titleArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";

    XLsn0wPullMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[XLsn0wPullMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle          = UITableViewCellSelectionStyleNone;
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, _rowHeight -0.5, VIEW_WIDTH(cell), 0.5)];
    line.backgroundColor = [UIColor xlsn0w_hexString:@"#FF6600"];
    [cell addSubview:line];
    XLsn0wPullMenuModel *model = [_titleArr objectAtIndex:indexPath.row];
    cell.title.text = model.title;
    
    if ([model.selected boolValue] == false) {
       [cell.status setImage:[UIImage imageNamed:@"My_unselected"] forState:(UIControlStateNormal)];
    } else {
       [cell.status setImage:[UIImage imageNamed:@"My_selected"] forState:(UIControlStateNormal)];
    }
    
    @WeakObj(cell);
    cell.action = ^(BOOL selected) {
        XLsn0wPullMenuCell *tap_cell = (XLsn0wPullMenuCell *)[cellWeak.status superview];
        NSIndexPath *indexPath = [_tableView indexPathForCell:tap_cell];
        
        XLsn0wPullMenuModel *model = [_titleArr objectAtIndex:indexPath.row];
        
        BOOL isAdd = false;

        if (selected) {///第一次点击
            if ([model.selected boolValue] == true) {
                [tap_cell.status setImage:[UIImage imageNamed:@"My_unselected"] forState:(UIControlStateNormal)];
                model.selected = @0;
                isAdd = false;
            } else {
                [tap_cell.status setImage:[UIImage imageNamed:@"My_selected"] forState:(UIControlStateNormal)];
                model.selected = @1;
                isAdd = true;
            }

            
        }else{
            if ([model.selected boolValue] == true) {
                [tap_cell.status setImage:[UIImage imageNamed:@"My_unselected"] forState:(UIControlStateNormal)];
                model.selected = @0;
                isAdd = false;
            } else {
                [tap_cell.status setImage:[UIImage imageNamed:@"My_selected"] forState:(UIControlStateNormal)];
                model.selected = @1;
                isAdd = true;
            }
        }
        
        if ([self.delegate respondsToSelector:@selector(dropdownMenu:selectedCellNumber:selectedCellText:isAdd:)]) {
            [self.delegate dropdownMenu:self selectedCellNumber:indexPath.row selectedCellText:tap_cell.title.text isAdd:isAdd]; // 回调代理
        }
        
        [_tableView reloadData];
    };
    
    return cell;
}

@end
