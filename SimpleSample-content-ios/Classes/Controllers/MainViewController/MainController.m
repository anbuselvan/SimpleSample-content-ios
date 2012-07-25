//
//  MainController.m
//  SimpleSampleContent
//
//  Created by kirill on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainController.h"
#import "PhotoController.h"
#import "DataManager.h"
@interface MainController ()

@end

@implementation MainController
@synthesize scroll;
@synthesize activityIndicator;
@synthesize imagePicker;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        currentImageX = START_POSITION_X;
        currentImageY = START_POSITION_Y;
        picturesInRowCounter = 0;
        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActionSheetStyleDefault];
        currentPictureIndex = 0;
        imageViews = [[NSMutableArray alloc] init];
        allPicturesLoad = NO;
                
        
        // Show toolbar
        UIBarButtonItem* uploadItem = [[UIBarButtonItem alloc] initWithTitle:@"Add new image" style:UIBarButtonSystemItemAdd  target:self action:@selector(selectPicture)];        
        UIToolbar *toolbar = [[UIToolbar alloc] init];
        toolbar.frame = CGRectMake(0, self.view.frame.size.height-87, self.view.frame.size.width, 44);
        [toolbar setItems:[NSArray arrayWithObject:uploadItem]];
        [uploadItem release];
        [self.view addSubview:toolbar];
        [toolbar release];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    CGRect appframe = [[UIScreen mainScreen] bounds];
    [scroll setContentSize:appframe.size];
    [scroll setMaximumZoomScale:4];
    [activityIndicator startAnimating];
}

-(void)viewDidAppear:(BOOL)animated{
    if (![[DataManager instance] userImages]) {
        
        // Download files
        [self downloadFile];
        return;
    }    
}

- (void)viewDidUnload
{
    [self setActivityIndicator:nil];
    [self setScroll:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// when photo is selected from gallery - > upload it to server
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage* selectedImage = [info valueForKey:UIImagePickerControllerOriginalImage];   
    NSData* imageData = UIImagePNGRepresentation(selectedImage);
    
    // Show image on gallery
    UIImageView* imageView = [[UIImageView alloc] initWithImage:selectedImage];
    [self showImage:imageView];
    [imageView release];
    [imagePicker dismissModalViewControllerAnimated:NO];
    [imagePicker release];
    
    
    // Upload file to QuickBlox
    [QBContent TUploadFile:imageData fileName:@"Great Image" contentType:@"image/png" isPublic:NO delegate:self];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [imagePicker dismissModalViewControllerAnimated:NO];
    [imagePicker release];
}

-(void)downloadFile{
    NSString* UID = [[[DataManager instance] blobIds] lastObject];
    if(UID){
        [QBContent downloadFileWithUID:UID delegate:self];
    }
    
    // when all pictures are loaded stop animating
    if ([[DataManager instance] blobIds].count == 0) {
        [activityIndicator stopAnimating];
        activityIndicator.hidden = YES;
    }
}


#pragma mark -
#pragma mark QBActionStatusDelegate

// QuickBlox API queries delegate
-(void)completedWithResult:(Result *)result{
    
    // Download file result
    if ([result isKindOfClass:QBCFileResult.class]) {
        
        // Success result
        if (result.success) {
            
            QBCFileResult *res = (QBCFileResult *)result;
            if ([res data]) {   
                
                // Add image to gallery
                [[DataManager instance] saveUserPicture:[UIImage imageWithData:[res data]]];
                UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:[res data]]];
                [self showImage:imageView];
                [imageView release];
                [[[DataManager instance] blobIds] removeLastObject];
                
                
                // Download next file
                [self downloadFile];
            }          
        }else{
            [[[DataManager instance] blobIds] removeLastObject];
            [self downloadFile];
        }
    }
}

// Show image on your gallery
-(void)showImage:(UIImageView*) image{
    image.frame = CGRectMake(currentImageX, currentImageY, IMAGE_WIDTH, IMAGE_HEIGHT);
    image.userInteractionEnabled = YES;
    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fullScreenPicture:)];
    [image addGestureRecognizer:tapRecognizer];
    [tapRecognizer release];
    
    [scroll addSubview:image];
    currentImageX += IMAGE_WIDTH;
    currentImageX += MARGING; // distance between two images
    picturesInRowCounter++;
    
    if (picturesInRowCounter == IMAGES_IN_ROW) {
        currentImageX = START_POSITION_X;
        currentImageY += IMAGE_HEIGHT;
        currentImageY += MARGING;
        picturesInRowCounter = 0;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

-(void)fullScreenPicture:(id)sender{
    UITapGestureRecognizer* tapRecognizer = (UITapGestureRecognizer*)sender;
    UIImageView* selectedImageView = (UIImageView*)[tapRecognizer view];
    PhotoController* photoController = [[PhotoController alloc] initWithImage:selectedImageView.image];
    [self.navigationController pushViewController:photoController animated:YES];
    [photoController release];
}

// Show Picker for select picture from iPhone gallery to add to your gallery
-(void)selectPicture{
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.allowsEditing = NO;
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    [self presentModalViewController:imagePicker animated:NO];
}

- (void)dealloc {
    [imageViews release];
    [super dealloc];
}

@end
