//
//  MainController.h
//  SimpleSampleContent
//
//  Created by kirill on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define IMAGE_WIDTH 100
#define IMAGE_HEIGHT 100
#define START_POSITION_X 22
#define START_POSITION_Y 10
#define MARGING 5

#define IMAGES_IN_ROW 3
@interface MainController : UIViewController<UIImagePickerControllerDelegate,QBActionStatusDelegate,UIGestureRecognizerDelegate>{
    UIImagePickerController* imagePicker;
    NSMutableArray* blobIds;
    
    int currentImageX;
    int currentImageY;
    int picturesInRowCounter;
    int currentPictureIndex;
    NSMutableArray* imageViews;
    
    BOOL allPicturesLoad;
}
@property (retain, nonatomic) IBOutlet UIScrollView *scroll;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic,retain) UIImagePickerController* imagePicker;

@end
