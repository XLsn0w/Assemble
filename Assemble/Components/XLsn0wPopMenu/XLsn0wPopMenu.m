
#import "XLsn0wPopMenu.h"
#import "PopMenuModel.h"

#ifndef SCREEN_WIDTH
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#endif

#define PopMenuHeight 360

static CGFloat const kCellHeight = 40;

@interface PopMenuTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;

@end

@interface XLsn0wPopMenu ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *tableData;
@property (nonatomic, assign) CGPoint trianglePoint;

@end

@implementation XLsn0wPopMenu

- (instancetype)initWithItems:(NSArray *)array
                        width:(CGFloat)width
             triangleLocation:(CGPoint)point
                       action:(XLsn0wPopMenuBlock)action {
    if (array.count == 0) return nil;
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        self.alpha = 0;
        _tableData = [array copy];
        _trianglePoint = point;
        self.action = action;
        
        
        // 添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
        
        // 创建tableView
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - width - 5, point.y + 10, width, PopMenuHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.layer.masksToBounds = YES;
        _tableView.layer.cornerRadius = 5;
        _tableView.bounces = false;
        _tableView.rowHeight = kCellHeight;
        [_tableView registerClass:[PopMenuTableViewCell class] forCellReuseIdentifier:@"PopMenuTableViewCell"];
        [self addSubview:_tableView];
    
    }
    return self;
}

+ (void)popWithDataArray:(NSArray *)dataArray
                width:(CGFloat)width
     triangleLocation:(CGPoint)point
               action:(XLsn0wPopMenuBlock)action {
    XLsn0wPopMenu *pop = [[XLsn0wPopMenu alloc] initWithItems:dataArray width:width triangleLocation:point action:action];
    [pop show];
}

- (void)tap {
    [self hide];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:NSClassFromString(@"UITableViewCellContentView")]) {
        return NO;
    }
    if (touch.view.tag == 1000) {
        return NO;
    }
    return YES;
}

#pragma mark - show or hide
- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    // 设置右上角为transform的起点（默认是中心点）
    _tableView.layer.position = CGPointMake(SCREEN_WIDTH - 5, _trianglePoint.y + 10);
    // 向右下transform
    _tableView.layer.anchorPoint = CGPointMake(1, 0);
    _tableView.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1;
        self->_tableView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
        self->_tableView.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
    } completion:^(BOOL finished) {
        [self->_tableView removeFromSuperview];
        [self removeFromSuperview];
        if (self.hideHandle) {
            self.hideHandle();
        }
    }];
}

#pragma mark - Draw triangle
- (void)drawRect:(CGRect)rect {
    // 设置背景色
    [[UIColor whiteColor] set];
    //拿到当前视图准备好的画板
    CGContextRef context = UIGraphicsGetCurrentContext();
    //利用path进行绘制三角形
    CGContextBeginPath(context);
    CGPoint point = _trianglePoint;
    // 设置起点
    CGContextMoveToPoint(context, point.x, point.y);
    // 画线
    CGContextAddLineToPoint(context, point.x - 6, point.y + 10);
    CGContextAddLineToPoint(context, point.x + 6, point.y + 10);
    CGContextClosePath(context);
    // 设置填充色
    [[UIColor whiteColor] setFill];
    // 设置边框颜色
    [[UIColor whiteColor] setStroke];
    // 绘制路径
    CGContextDrawPath(context, kCGPathFillStroke);
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PopMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PopMenuTableViewCell" forIndexPath:indexPath];
    PopMenuModel *model = _tableData[indexPath.row];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@", ![model.projectName isKindOfClass:[NSNull class]]?model.projectName:@""];
    [cell.titleLabel sizeToFit];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.separatorInset = UIEdgeInsetsZero;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionHeader = [UIView new];
    sectionHeader.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0);
    UILabel *title = [UILabel new];
    [sectionHeader addSubview:title];
    title.frame = CGRectMake(15, 15, 100, 20);
    title.text = @"所属项目";
    title.font = [UIFont systemFontOfSize:13];
//    title.textColor = HLMyHexRGB(0x666666);
    sectionHeader.backgroundColor = UIColor.whiteColor;
    sectionHeader.tag = 1000;
    return sectionHeader;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.action) {
        [self hide];
        PopMenuModel *model = _tableData[indexPath.row];
        self.action(indexPath.row, model);
    }
    if (self.hideAction) {
        self.hideAction(true);
    }
}

@end

///Cell
@implementation PopMenuTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, (kCellHeight - 20) / 2, 0, 0)];
        _titleLabel.font = [UIFont systemFontOfSize:12];
//        _titleLabel.textColor = HLMyHexRGB(0x333333);
        [self.contentView addSubview:_titleLabel];
        
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    }else {
        self.backgroundColor = [UIColor whiteColor];
    }
}

@end
