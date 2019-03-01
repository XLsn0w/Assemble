
#import "PopMenuView.h"
#import "PopMenuCell.h"
#import "PopMenuModel.h"

#define triangleHeight 60
#define cellHeight 40
#define sectionHeight 40
#define PopMenuView_X ([UIScreen mainScreen].bounds.size.width - 114*width_scale)

@interface PopMenuView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataArray;

@end

@implementation PopMenuView

- (instancetype)initWithPopMenuWidth:(CGFloat)width popMenuViewY:(CGFloat)y dataArray:(NSArray *)dataArray {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.dataArray = dataArray;

        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(PopMenuView_X, y, width*width_scale, cellHeight*(dataArray.count)+sectionHeight) style:UITableViewStyleGrouped];
        self.tableView.dataSource = self;
        self.tableView.delegate   = self;
        self.tableView.layer.cornerRadius = 3;
        self.tableView.layer.anchorPoint = CGPointMake(1.0, 0);
        self.tableView.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
        [self addSubview:self.tableView];
        self.tableView.scrollEnabled = false;
        self.tableView.backgroundColor = UIColor.redColor;
        [self show];
    }
    return self;
}

- (void)show {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
   
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PopMenuCell *cell = [PopMenuCell initWithTableView:tableView];
    PopMenuModel *model = self.dataArray[indexPath.row];
//    cell.textLabel.text = model.title;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return sectionHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionHeader = [UIView new];
    sectionHeader.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0);
    UILabel *title = [UILabel new];
    [sectionHeader addSubview:title];
    title.text = @"所属项目";
    title.font = [UIFont systemFontOfSize:13];
    title.textColor = HexFromRGB(0x666666);
    sectionHeader.backgroundColor = UIColor.whiteColor;
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(sectionHeader);
        make.height.mas_equalTo(13);
        make.left.mas_equalTo(15);
    }];
    return sectionHeader;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.action) {
        PopMenuModel *model = self.dataArray[indexPath.row];
//        self.action(indexPath.row, model.title);
    }
    [self hide];
}

#pragma mark 绘制三角形
- (void)drawRect:(CGRect)rect {
    // 设置背景色
    [[UIColor whiteColor] set];
    //拿到当前视图准备好的画板
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //利用path进行绘制三角形
    
    CGContextBeginPath(context);//标记
    CGFloat location = [UIScreen mainScreen].bounds.size.width;
    CGContextMoveToPoint(context, location -  20*width_scale, triangleHeight);//设置起点
    
    CGContextAddLineToPoint(context, location - 25*width_scale ,  triangleHeight-10*height_scale);
    
    CGContextAddLineToPoint(context, location - 30*width_scale , triangleHeight);
    
    CGContextClosePath(context);//路径结束标志，不写默认封闭
    
    [[UIColor whiteColor] setFill];  //设置填充色
    
    [[UIColor whiteColor] setStroke]; //设置边框颜色
    
    CGContextDrawPath(context, kCGPathFillStroke);//绘制路径path
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hide];
}

- (void)hide {
    [UIView animateWithDuration:0.15 animations:^{
        self.tableView.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
    } completion:^(BOOL finished) {
        [self.tableView removeFromSuperview];
        [self removeFromSuperview];
        self.tableView = nil;
    }];
}

@end
