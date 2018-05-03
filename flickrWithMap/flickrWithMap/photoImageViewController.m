//
//  photoImageViewController.m
//  topPlaces
//
//  Created by Wang Tom on 2018-01-29.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import "photoImageViewController.h"
#import "FlickrFetcher.h"

@interface photoImageViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation photoImageViewController
@synthesize imageScrollView = _imageScrollView;
@synthesize imageView = _imageView;
@synthesize photo = _photo;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.imageScrollView.delegate = self;
    //[self updateImage];
}

- (void)setPhoto:(NSDictionary *)photo {
    _photo = photo;
    [self.navigationItem setTitle:[self.photo objectForKey:FLICKR_PHOTO_TITLE]];
    [self updateImage];
}

- (void)setImageScrollView:(UIScrollView *)imageScrollView {
    _imageScrollView = imageScrollView;
    self.imageScrollView.minimumZoomScale = 0.2;
    self.imageScrollView.maximumZoomScale = 1.5;
    self.imageScrollView.contentOffset = CGPointZero;
}

- (void)setImageView:(UIImageView *)imageView {
    _imageView = imageView;
}

- (void)zoomWholePhoto {
    CGFloat imageViewWidth = self.imageScrollView.bounds.size.width;
    CGFloat imageViewHeight = self.imageScrollView.bounds.size.height;
    CGFloat wholePhotoWidthScale = imageViewWidth / self.imageView.image.size.width;
    CGFloat wholePhotoHeightScale = imageViewHeight / self.imageView.image.size.height;
    //NSLog(@"scrollview width and height %f, %f", imageViewWidth, imageViewHeight);
    //NSLog(@"image width and height %f, %f", self.imageView.image.size.width, self.imageView.image.size.height);
    CGFloat minScale = wholePhotoWidthScale > wholePhotoHeightScale ? wholePhotoHeightScale : wholePhotoWidthScale;
    [self.imageScrollView setZoomScale:minScale];
    //NSLog(@"min image scroll %f", self.imageScrollView.zoomScale);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void) updateImage {
    /*
    if (self.imageView.image) {
        self.imageScrollView.zoomScale = 1.0;
        self.imageScrollView.contentSize = self.imageView.image.size;
    }
     */
    if (self.photo) {
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [spinner startAnimating];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
        
        dispatch_queue_t downloadQueue = dispatch_queue_create("image downlaod", NULL);
        dispatch_async(downloadQueue, ^{
            NSURL *imageURL = [FlickrFetcher urlForPhoto:self.photo format:FlickrPhotoFormatLarge];
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView.contentMode = UIViewContentModeScaleAspectFill;
                self.imageView.image = [[UIImage alloc] initWithData:imageData];
                self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
                self.navigationItem.rightBarButtonItem = NULL;
                [self zoomWholePhoto];
            });
        });
    }
}

- (BOOL)shouldAutorotate {
    return YES;
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
