//
//  ShowMeImageViewController.m
//  Mercury
//
//  Created by IOS dev on 15/2/4.
//  Copyright (c) 2015年 GangXu. All rights reserved.
//

#import "ShowMeImageViewController.h"
#import "UIImageView+WebCache.h"
#import "Const.h"
#import "SVProgressShow.h"


@interface SubPageViewController : UIViewController<UIAlertViewDelegate>

@property(nonatomic,assign)NSInteger index;
@property(nonatomic,retain)NSString *urlStr;
@property(nonatomic,retain)UIImageView *imageView;
@end

@implementation SubPageViewController


-(void)viewDidLoad{

    self.view.backgroundColor=[UIColor whiteColor];
    
    _imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    [self.view addSubview:_imageView];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
//    [_imageView setImageWithURL:[NSURL URLWithString:_urlStr] placeholderImage:[UIImage imageNamed:@"启动页"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            CGFloat scaleHeight=screenHeight*(_imageView.image.size.height/_imageView.image.size.width);
//            _imageView.frame=CGRectMake(0, (screenHeight-scaleHeight)/2, screenWidth, scaleHeight);
//        });
//    }];
    
    [_imageView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",_urlStr]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            CGFloat scaleHeight=screenHeight*(_imageView.image.size.height/_imageView.image.size.width);
            _imageView.frame=CGRectMake(0, (screenHeight-scaleHeight)/2, screenWidth, scaleHeight);
        });
    }];
    
    _imageView.userInteractionEnabled=YES;
    
    UIPinchGestureRecognizer *pinchGestureRecognizer=[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchGestureEven:)];
    [_imageView addGestureRecognizer:pinchGestureRecognizer];
    
    UILongPressGestureRecognizer *longPressGestureRecognizer=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureEven:)];
     [_imageView addGestureRecognizer:longPressGestureRecognizer];

}


-(void)longPressGestureEven:(UILongPressGestureRecognizer *)sender{

    if (sender.state==UIGestureRecognizerStateEnded) {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"保存" message:@"保存该图片到相册？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alertView.tag=30;
        [alertView show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex==1) {
        UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = @"";
    if (!error) {
        message = @"成功保存到相册";
    }else
    {
        message = [error description];
    }
    [SVProgressShow showInfoWithStatus:message];
}


-(void)pinchGestureEven:(UIPinchGestureRecognizer *)sender{
    sender.view.layer.transform=CATransform3DScale(sender.view.layer.transform, sender.scale, sender.scale, 1);
    sender.scale=1.0f;
    
}

@end

@interface ShowMeImageViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>

@property(nonatomic,retain)UIPageViewController *pageViewController;
@property(nonatomic,retain)NSMutableArray *viewControllers;
@property(nonatomic,retain)UIPageControl *pageControl;

@end

@implementation ShowMeImageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.view.userInteractionEnabled=YES;
    UITapGestureRecognizer *tapGestureRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureEven:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    
    _showImageView = [[UIImageView alloc] init];
    if (self.imagesArray==nil||self.imagesArray.count<=0) {
        _showImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [_showImageView sd_setImageWithURL:[NSURL URLWithString:_showImageNsstring] placeholderImage:[UIImage imageNamed:@"启动页"]  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            dispatch_async(dispatch_get_main_queue(), ^{
                CGFloat scaleHeight=screenHeight*(_showImageView.image.size.height/_showImageView.image.size.width);
                _showImageView.frame=CGRectMake(0, (screenHeight-scaleHeight)/2, screenWidth, scaleHeight);
            });
        }];
        
//        [_showImageView setImageWithURL:[NSURL URLWithString:_showImageNsstring] placeholderImage:[UIImage imageNamed:@"启动页"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                CGFloat scaleHeight=screenHeight*(_showImageView.image.size.height/_showImageView.image.size.width);
//                _showImageView.frame=CGRectMake(0, (screenHeight-scaleHeight)/2, screenWidth, scaleHeight);
//            });
//        }];
        _showImageView.userInteractionEnabled=YES;
        
        UIPinchGestureRecognizer *pinchGestureRecognizer=[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchGestureEven:)];
        [_showImageView addGestureRecognizer:pinchGestureRecognizer];
    }
    else{
        
        _viewControllers=[[NSMutableArray alloc]init];
        
        _pageViewController=[[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageViewController.delegate=self;
        _pageViewController.dataSource=self;
        
        NSInteger i=0;
        for (NSString *urlStr in _imagesArray) {
            SubPageViewController *subPageViewController=[[SubPageViewController alloc]init];
            subPageViewController.urlStr=urlStr;
            subPageViewController.index=i;
            i++;
            [_viewControllers addObject:subPageViewController];
        }
        SubPageViewController *subPageViewController=_viewControllers[_currentImageIndex];
        
        [_pageViewController setViewControllers:@[subPageViewController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
            
        }];
        [self.view addSubview:_pageViewController.view];
        
        _pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake((self.view.bounds.size.width-200)/2, self.view.bounds.size.height-100, 200, 30)];
        _pageControl.enabled=NO;
        _pageControl.numberOfPages=_imagesArray.count;
        _pageControl.currentPage=_currentImageIndex;
        [self.view addSubview:_pageControl];
    
    }
    
}

-(void)pinchGestureEven:(UIPinchGestureRecognizer *)sender{
    sender.view.layer.transform=CATransform3DScale(sender.view.layer.transform, sender.scale, sender.scale, 1);
    sender.scale=1.0f;
    
}

-(void)tapGestureEven:(UITapGestureRecognizer *)sender{
    
    [self dismissViewControllerAnimated:YES completion:^{
    }];
   // [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -  PageViewController 方法

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{

    SubPageViewController *subPageViewController=(SubPageViewController*)pageViewController.viewControllers[0];
    _currentImageIndex=subPageViewController.index;
    _currentImageIndex++;
    if (_currentImageIndex>=_imagesArray.count) {
        return nil;
    }

    return _viewControllers[_currentImageIndex];
}


-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{

    SubPageViewController *subPageViewController=(SubPageViewController*)pageViewController.viewControllers[0];
    _currentImageIndex=subPageViewController.index;
    _currentImageIndex--;
    if (_currentImageIndex<0) {
        return nil;
    }
  
    return _viewControllers[_currentImageIndex];
}

-(void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers{
    SubPageViewController *subPageViewController=(SubPageViewController*)pageViewController.viewControllers[0];
    subPageViewController.imageView.layer.transform=CATransform3DIdentity;
}

-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{

    SubPageViewController *subPageViewController=(SubPageViewController*)pageViewController.viewControllers[0];
    _pageControl.currentPage=subPageViewController.index;

}

@end
