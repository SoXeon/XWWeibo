//
//  SLPagingViewController.m
//  SLPagingView
//
//  Created by Stefan Lage on 20/11/14.
//  Copyright (c) 2014 Stefan Lage. All rights reserved.
//

#import "SLPagingViewController.h"

@interface SLPagingViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIView *navigationBarView;
@property (nonatomic, strong) NSMutableArray *navItemsViews;
@property (nonatomic, strong) NSMutableArray *controllerReferences;
@property (nonatomic) BOOL needToShowPageControl;
@property (nonatomic) BOOL isUserInteraction;
@property (nonatomic) NSInteger indexSelected;

@end

@implementation SLPagingViewController

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self initCrucialObjects:[UIColor whiteColor]
                 showPageControl:NO];
    }
    return self;
}

#pragma mark - constructors with views

-(id)initWithNavBarItems:(NSArray*) items views:(NSArray*)views{
    return [self initWithNavBarItems:items
                    navBarBackground:[UIColor whiteColor]
                               views:views
                     showPageControl:YES];
}

-(id)initWithNavBarItems:(NSArray*)items views:(NSArray*)views showPageControl:(BOOL)addPageControl{
    return [self initWithNavBarItems:items
                    navBarBackground:[UIColor whiteColor]
                               views:views
                     showPageControl:addPageControl];
}

-(id)initWithNavBarItems:(NSArray*)items navBarBackground:(UIColor*)background views:(NSArray*)views showPageControl:(BOOL)addPageControl{
    self = [super init];
    if(self){
        [self initCrucialObjects:background
                 showPageControl:addPageControl];
        int i                         = 0;
        for(i=0; i<items.count; i++){
            // Be sure items contains only UIView's object
            if([[items objectAtIndex:i] isKindOfClass:UIView.class])
                [self addNavigationItem:[items objectAtIndex:i] tag:i];
        }
        
        // is there any controllers ?
        if(views
           && views.count > 0){
            NSMutableArray *controllerKeys = [NSMutableArray new];
            for(i=0; i < views.count; i++){
                if([[views objectAtIndex:i] isKindOfClass:UIView.class]){
                    UIView *ctr = [views objectAtIndex:i];
                    // Set the tag
                    ctr.tag = i;
                    [controllerKeys addObject:@(i)];
                }
                else if([[views objectAtIndex:i] isKindOfClass:UIViewController.class]){
                    UIViewController *ctr = [views objectAtIndex:i];
                    // Set the tag
                    ctr.view.tag = i;
                    [controllerKeys addObject:@(i)];
                }
            }
            // Number of keys equals number of controllers ?
            if(controllerKeys.count == views.count)
                _viewControllers = [[NSMutableDictionary alloc] initWithObjects:views
                                                                        forKeys:controllerKeys];
            else{
                // Something went wrong -> inform the client
                NSException *exc = [[NSException alloc] initWithName:@"View Controllers error"
                                                              reason:@"Some objects in viewControllers are not kind of UIViewController!"
                                                            userInfo:nil];
                @throw exc;
            }
        }
    }
    return self;
}

#pragma mark - constructors with controllers

-(id)initWithNavBarControllers:(NSArray *)controllers{
    return [self initWithNavBarControllers:controllers
                          navBarBackground:[UIColor whiteColor]
                           showPageControl:YES];
}

-(id)initWithNavBarControllers:(NSArray *)controllers showPageControl:(BOOL)addPageControl{
    return [self initWithNavBarControllers:controllers
                          navBarBackground:[UIColor whiteColor]
                           showPageControl:addPageControl];
}

-(id)initWithNavBarControllers:(NSArray *)controllers navBarBackground:(UIColor *)background showPageControl:(BOOL)addPageControl{
    NSMutableArray *views = [[NSMutableArray alloc] initWithCapacity:controllers.count];
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:controllers.count];
    _controllerReferences = [[NSMutableArray alloc] initWithArray:controllers];
    for(int i =0; i<controllers.count; i++){
        // Be sure we got s subclass of UIViewController
        if([controllers[i] isKindOfClass:UIViewController.class]){
            UIViewController *ctr = controllers[i];
            [views addObject:[ctr view]];
            // Get associated item
            UILabel *item = [UILabel new];
            [item setText:ctr.title];
            [items addObject:item];
        }
    }
    return [self initWithNavBarItems:items
                    navBarBackground:background
                               views:views
                     showPageControl:addPageControl];
}

#pragma mark - constructors with items & controllers

-(id)initWithNavBarItems:(NSArray *)items controllers:(NSArray *)controllers{
    return [self initWithNavBarItems:items
                    navBarBackground:[UIColor whiteColor]
                         controllers:controllers
                     showPageControl:YES];
}

-(id)initWithNavBarItems:(NSArray *)items controllers:(NSArray *)controllers showPageControl:(BOOL)addPageControl{
    return [self initWithNavBarItems:items
                    navBarBackground:[UIColor whiteColor]
                         controllers:controllers
                     showPageControl:addPageControl];
}

-(id)initWithNavBarItems:(NSArray *)items navBarBackground:(UIColor *)background controllers:(NSArray *)controllers showPageControl:(BOOL)addPageControl{
    NSMutableArray *views = [[NSMutableArray alloc] initWithCapacity:controllers.count];
    _controllerReferences = [[NSMutableArray alloc] initWithArray:controllers];
    for(int i =0; i<controllers.count; i++){
        // Be sure we got s subclass of UIViewController
        if([controllers[i] isKindOfClass:UIViewController.class])
            [views addObject:[(UIViewController*)controllers[i] view]];
    }
    return [self initWithNavBarItems:items
                    navBarBackground:background
                               views:views
                     showPageControl:addPageControl];
}

#pragma mark - LifeCycle

- (void)loadView {
    [super loadView];
    // Notify all conctrollers
    [self notifyControllers:NSSelectorFromString(@"loadView")
                     object:nil
                 checkIndex:NO];
    // Try to load controller from storyboard
    [self loadStoryboardControllers];
    // Set up the controller
    [self setupPagingProcess];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // Be notify when the device's orientation change
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    // Notify all conctrollers
    [self notifyControllers:NSSelectorFromString(@"viewDidAppear:")
                     object:@(animated)
                 checkIndex:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // Notify all conctrollers
    [self notifyControllers:NSSelectorFromString(@"viewDidAppear:")
                     object:@(animated)
                 checkIndex:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // Notify all conctrollers
    [self notifyControllers:NSSelectorFromString(@"viewWillDisappear:")
                     object:@(animated)
                 checkIndex:YES];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Notify all conctrollers
    [self notifyControllers:NSSelectorFromString(@"viewDidLoad")
                     object:nil
                 checkIndex:NO];
    [self setCurrentIndex:self.indexSelected
                 animated:NO];
}

-(void)dealloc{
    // Remove Observers
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                             forKeyPath:UIDeviceOrientationDidChangeNotification];
    // Close relationships
    _didChangedPage           = nil;
    _pagingViewMoving         = nil;
    _pagingViewMovingRedefine = nil;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.navigationBarView.frame = (CGRect){0, 0, SCREEN_SIZE.width, 44};
}

#pragma mark - public methods

-(void)updateUserInteractionOnNavigation:(BOOL)activate{
    self.isUserInteraction = activate;
}

-(void)setCurrentIndex:(NSInteger)index animated:(BOOL)animated{
    // Be sure we got an existing index
    if(index < 0 || index > self.navigationBarView.subviews.count-1){
        NSException *exc = [[NSException alloc] initWithName:@"Index out of range"
                                                      reason:@"The index is out of range of subviews's count!"
                                                    userInfo:nil];
        @throw exc;
    }
    // save current index
    self.indexSelected = index;
    // Get the right position and update it
    CGFloat xOffset    = (index * ((int)SCREEN_SIZE.width));
    [self.scrollView setContentOffset:CGPointMake(xOffset, self.scrollView.contentOffset.y) animated:animated];
}

-(void)addViewControllers:(UIViewController *) controller needToRefresh:(BOOL) refresh{
    int tag = (int)self.viewControllers.count;
    // Try to get a navigation item
    UIView *v = nil;
    if(controller.title){
        UILabel *item = [UILabel new];
        [item setText:controller.title];
        v = item;
    }
    else if(controller.navigationItem && controller.navigationItem.titleView){
        v = controller.navigationItem.titleView;
    }
    // Adds a navigation item
    [self addNavigationItem:v
                        tag:tag];
    // Save the controller
    [self.viewControllers setObject:controller.view
                             forKey:@(tag)];
    // Save controller reference
    [self.controllerReferences addObject:controller];
    // Do we need to refresh the UI ?
    if(refresh)
       [self setupPagingProcess];
}

#pragma mark - Internal methods

-(void) initCrucialObjects:(UIColor *)background showPageControl:(BOOL) showPageControl{
    _needToShowPageControl             = showPageControl;
    _navigationBarView                 = [[UIView alloc] init];
    _navigationBarView.backgroundColor = background;
    // UserInteraction activate by default
    _isUserInteraction                 = YES;
    // Default value for the navigation style
    _navigationSideItemsStyle          = SLNavigationSideItemsStyleDefault;
    _viewControllers                   = [NSMutableDictionary new];
    _navItemsViews                     = [NSMutableArray new];
    _controllerReferences              = [NSMutableArray new];
}

// Load any defined controllers from the storyboard
- (void)loadStoryboardControllers
{
    if (self.storyboard)
    {
        BOOL isThereNextIdentifier = YES;
        int idx = 0;
        while (isThereNextIdentifier) {
            @try
            {
                [self performSegueWithIdentifier:[NSString stringWithFormat:@"%@%d", SLPagingViewPrefixIdentifier, idx]
                                          sender:nil];
                idx++;
            }
            @catch(NSException *exception) {
                isThereNextIdentifier = NO;
            }
        }
    }
}

// Perform a specific selector for each controllers
-(void)notifyControllers:(SEL)selector object:(id)object checkIndex:(BOOL)index{
    if(index && self.controllerReferences.count > self.indexSelected) {
        [(UIViewController*)self.controllerReferences[self.indexSelected] performSelectorOnMainThread:selector
                                                                                           withObject:object
                                                                                        waitUntilDone:NO];
    }
    else{
        [self.controllerReferences enumerateObjectsUsingBlock:^(UIViewController* ctr, NSUInteger idx, BOOL *stop) {
            [ctr performSelectorOnMainThread:selector
                                  withObject:object
                               waitUntilDone:NO];
        }];
    }
}

// Add a view as a navigationBarItem
-(void)addNavigationItem:(UIView*)v tag:(int)tag{
    CGFloat distance = (SCREEN_SIZE.width/2) - self.navigationSideItemsStyle;
    CGSize vSize = ([v isKindOfClass:[UILabel class]])? [self getLabelSize:(UILabel*)v] : v.frame.size;
    CGFloat originX = (SCREEN_SIZE.width/2 - vSize.width/2) + self.navItemsViews.count*distance;
    v.frame = (CGRect){originX, 8, vSize.width, vSize.height};
    v.tag = tag;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(tapOnHeader:)];
    [v addGestureRecognizer:tap];
    [v setUserInteractionEnabled:YES];
    [_navigationBarView addSubview:v];
    if(!_navItemsViews)
        _navItemsViews = [[NSMutableArray alloc] init];
    [_navItemsViews addObject:v];
}

-(void)setupPagingProcess{
    // Make our ScrollView
    self.scrollView                                           = [UIScrollView new];
    self.scrollView.backgroundColor                           = [UIColor clearColor];
    self.scrollView.pagingEnabled                             = YES;
    self.scrollView.showsHorizontalScrollIndicator            = NO;
    self.scrollView.showsVerticalScrollIndicator              = NO;
    self.scrollView.delegate                                  = self;
    self.scrollView.bounces                                   = NO;
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView setContentInset:UIEdgeInsetsMake(0, 0, -80, 0)];
    [self.view addSubview:self.scrollView];
    
    // setup scrollview constraints
    // Width constraint, equal parent view width
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"scrollView": self.scrollView}]];
    // Height constraint, equal parent view height
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"scrollView": self.scrollView}]];
    // Adds all views
    [self addControllers];
    
    if(self.needToShowPageControl){
        // Make the page control
        self.pageControl               = [[UIPageControl alloc] init];
        self.pageControl.frame         = (CGRect){0, 35, 0, 0};
        self.pageControl.numberOfPages = self.navigationBarView.subviews.count;
        self.pageControl.currentPage   = 0;
        if(self.currentPageControlColor) self.pageControl.currentPageIndicatorTintColor = self.currentPageControlColor;
        if(self.tintPageControlColor) self.pageControl.pageIndicatorTintColor = self.tintPageControlColor;
        [self.navigationBarView addSubview:self.pageControl];
    }
    [self.navigationController.navigationBar addSubview:self.navigationBarView];
}

// Add all views
-(void)addControllers{
    if(self.viewControllers
       && self.viewControllers.count > 0){
        float width                 = SCREEN_SIZE.width * self.viewControllers.count;
        float height                = CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.navigationBarView.frame);
        self.scrollView.contentSize = (CGSize){width, height};
        [self.viewControllers enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, id obj, BOOL *stop) {
            UIView *v = (UIView*)obj;
            [self.scrollView addSubview:v];
            v.translatesAutoresizingMaskIntoConstraints = NO;
            // Width constraint, half of parent view width
            [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:v
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.scrollView
                                                                        attribute:NSLayoutAttributeWidth
                                                                       multiplier:1.0
                                                                         constant:0]];
            // Height constraint, half of parent view height
            [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:v
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.scrollView
                                                                        attribute:NSLayoutAttributeHeight
                                                                       multiplier:1.0
                                                                         constant:0]];
            UIView *previous = [self.viewControllers objectForKey:[NSNumber numberWithFloat:([key intValue] - 1)]];
            if(previous)
                // Distance constraint: set distance between previous view and the current one
                [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[previous]-0-[v]"
                                                                                        options:0
                                                                                        metrics:nil
                                                                                          views:@{@"v" : v,
                                                                                                  @"previous" : previous}]];
            // Oridnate constraint : set the space between the Top and the current view
            [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[v]", CGRectGetHeight(self.navigationBarView.frame)]
                                                                                    options:0
                                                                                    metrics:nil
                                                                                      views:@{@"v" : v}]];
        }];
    }
}

// Scroll to the view tapped
-(void)tapOnHeader:(UITapGestureRecognizer *)recognizer{
    if(self.isUserInteraction){
        // Get the wanted view
        UIView *view = [self.viewControllers objectForKey:@(recognizer.view.tag)];
        [self.scrollView scrollRectToVisible:view.frame
                                    animated:YES];
    }
}

-(CGSize) getLabelSize:(UILabel *)lbl{
    return [[lbl text] sizeWithAttributes:@{NSFontAttributeName:[lbl font]}];;
}

#pragma mark - Internal Methods
#pragma mark - Views management

/* Update all nav items frame
 *
 * @param xOffset, abscissa of the scrollview's contentOffset
 */
-(void)updateNavItems:(CGFloat) xOffset{
    __block int i = 0;
    [self.navItemsViews enumerateObjectsUsingBlock:^(UIView* v, NSUInteger idx, BOOL *stop) {
        CGFloat distance = (SCREEN_SIZE.width/2) - self.navigationSideItemsStyle;
        CGSize vSize     = ([v isKindOfClass:[UILabel class]])? [self getLabelSize:(UILabel*)v] : v.frame.size;
        CGFloat originX  = ((SCREEN_SIZE.width/2 - vSize.width/2) + i*distance) - xOffset/(SCREEN_SIZE.width/distance);
        v.frame          = (CGRect){originX, 8, vSize.width, vSize.height};
        i++;
    }];
}

// Adapt all views the main screen
-(void)adaptViews{
    // Update the nav items + the scrollview
    [self updateNavItems:self.scrollView.contentOffset.x];
    // Be sure to stay on the same view
    [self setCurrentIndex:self.indexSelected
                 animated:NO];
    [self.scrollView setNeedsUpdateConstraints];
    [self.view setNeedsUpdateConstraints];
}

#pragma mark - Internal Methods
#pragma mark - Notifications

// Call when the screen orientation is updated
- (void)orientationChanged:(NSNotification *)notification{
    [self adaptViews];
}

#pragma mark - SLPagingViewDidChanged delegate

-(void)sendNewIndex:(UIScrollView *)scrollView{
    CGFloat xOffset    = scrollView.contentOffset.x;
    self.indexSelected = ((int) roundf(xOffset) % (self.navigationBarView.subviews.count * (int)SCREEN_SIZE.width)) / SCREEN_SIZE.width;
    if(self.pageControl){
        if (self.pageControl.currentPage != self.indexSelected)
        {
            self.pageControl.currentPage = self.indexSelected;
            if(self.didChangedPage)
                self.didChangedPage(self.indexSelected);
        }
    }
    else{
        if(self.didChangedPage)
            self.didChangedPage(self.indexSelected);
    }
    // Try to notify the controller concerned
    [self notifyControllers:NSSelectorFromString(@"viewDidAppear:")
                     object:@(YES)
                 checkIndex:YES];
}

#pragma mark - ScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Update nav items
    [self updateNavItems:scrollView.contentOffset.x];
    if(self.pagingViewMoving)
        // Customize the navigation items
        self.pagingViewMoving(self.navItemsViews);
    if(self.pagingViewMovingRedefine)
        // Wants to redefine all behaviors
        self.pagingViewMovingRedefine(scrollView, self.navItemsViews);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self sendNewIndex:scrollView];
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self sendNewIndex:scrollView];
}

@end

#pragma mark - SLPagingViewControllerSegueSetController segue identifier's prefix

NSString * const SLPagingViewPrefixIdentifier = @"sl_";

#pragma mark - SLPagingViewControllerSegueSetController class

@implementation SLPagingViewControllerSegueSetController

-(void)perform{
    // Get SLPagingViewController (sourceViewController)
    SLPagingViewController *src = self.sourceViewController;
    // Add it to the subviews
    if(self.destinationViewController)
        [src addViewControllers:self.destinationViewController
                  needToRefresh:NO];
}

@end
