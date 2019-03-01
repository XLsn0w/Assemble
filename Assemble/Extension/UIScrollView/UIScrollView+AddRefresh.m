
#import "UIScrollView+AddRefresh.h"
#import "MJRefresh.h"
#import <objc/runtime.h>

@interface UIScrollView()

@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, copy) HeaderAction headerAction;
@property (nonatomic, copy) FooterAction footerAction;

@end

@implementation UIScrollView (AddRefresh)

//static char *pagaIndexKey = "pagaIndexKey";
static void *pagaIndexKey = &pagaIndexKey;
- (void)setPageIndex:(NSInteger)pageIndex{
    objc_setAssociatedObject(self, &pagaIndexKey, @(pageIndex), OBJC_ASSOCIATION_ASSIGN);
}

- (NSInteger)pageIndex {
    return [objc_getAssociatedObject(self, &pagaIndexKey) integerValue];
}

- (void)setHeaderAction:(HeaderAction)headerAction {
    objc_setAssociatedObject(self, @"HeaderAction", headerAction, OBJC_ASSOCIATION_COPY);
}

- (HeaderAction)headerAction {
    return objc_getAssociatedObject(self, @"HeaderAction");
}

- (void)setFooterAction:(FooterAction)footerAction {
    objc_setAssociatedObject(self, @"FooterAction", footerAction, OBJC_ASSOCIATION_COPY);
}

- (FooterAction)footerAction {
    return objc_getAssociatedObject(self, @"FooterAction");
}


- (void)addHeaderRefresh:(BOOL)beginRefresh animation:(BOOL)animation headerAction:(HeaderAction)headerAction {

    __weak typeof(self) weakSelf = self;
    self.headerAction = headerAction;
    
    MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf resetPageNum];
    
        if (weakSelf.headerAction) {
            weakSelf.headerAction();
        }
        [weakSelf endHeaderRefresh];
    }];
    
    if (beginRefresh && animation) {
        //有动画的刷新
        [self beginHeaderRefresh];
    }else if (beginRefresh && !animation){
        //刷新，但是没有动画
        [self.mj_header executeRefreshingCallback];
    }
    
    header.mj_h = 70.0;
    self.mj_header = header;
}

- (void)addFooterRefresh:(BOOL)automaticallyRefresh footerAction:(void(^)(NSInteger pageIndex))footerAction {
    
    self.footerAction = footerAction;
    
    if (automaticallyRefresh) {
        MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
             self.pageIndex += 1;
            if (self.footerAction) {
                self.footerAction(self.pageIndex);
            }
            [self endFooterRefresh];
        }];
        
        footer.automaticallyRefresh = automaticallyRefresh;
        
        [footer setTitle:@"" forState:MJRefreshStateIdle];//设置闲置状态下不显示“点击或上拉加载更多”
  
        footer.stateLabel.font = [UIFont systemFontOfSize:13.0];
        footer.stateLabel.textColor = [UIColor colorWithWhite:0.400 alpha:1.000];
        [footer setTitle:@"加载中…" forState:MJRefreshStateRefreshing];
        [footer setTitle:@"这是我的底线啦~" forState:MJRefreshStateNoMoreData];
        
        self.mj_footer = footer;
        
    } else {
        
        MJRefreshBackNormalFooter * footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
             self.pageIndex += 1;
            if (self.footerAction) {
                self.footerAction(self.pageIndex);
            }
            [self endFooterRefresh];
        }];
        
        footer.stateLabel.font = [UIFont systemFontOfSize:13.0];
        footer.stateLabel.textColor = [UIColor colorWithWhite:0.400 alpha:1.000];
        [footer setTitle:@"加载中…" forState:MJRefreshStateRefreshing];
        [footer setTitle:@"这是我的底线啦~" forState:MJRefreshStateNoMoreData];
        
        self.mj_footer = footer;
    }
   
}

-(void)beginHeaderRefresh {
    
    [self resetPageNum];
    [self.mj_header beginRefreshing];
}

- (void)resetPageNum {
    self.pageIndex = 1;///页数默认为1
}

- (void)resetNoMoreData {
    
    [self.mj_footer resetNoMoreData];
}

-(void)endHeaderRefresh {
    
    [self.mj_header endRefreshing];
    [self resetNoMoreData];
}

-(void)endFooterRefresh {
    [self.mj_footer endRefreshing];
}

@end
