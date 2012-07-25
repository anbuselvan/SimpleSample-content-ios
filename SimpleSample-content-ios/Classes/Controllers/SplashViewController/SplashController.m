//
//  SplashController.m
//  SimpleSampleContent
//
//  Created by kirill on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SplashController.h"
#import "DataManager.h"
@interface SplashController ()

@end

@implementation SplashController
@synthesize activityIndicator;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [activityIndicator startAnimating];
    
    // QuickBlox application authorization
    QBASessionCreationRequest *extendedAuthRequest = [[QBASessionCreationRequest alloc] init];
    extendedAuthRequest.userLogin = @"iostest";
    extendedAuthRequest.userPassword = @"iostest2";
    
    [QBAuth createSessionWithExtendedRequest:extendedAuthRequest delegate:self];
    
    [extendedAuthRequest release];
}

- (void)viewDidUnload
{
    [self setActivityIndicator:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)hideSplashScreen{
    [activityIndicator stopAnimating];
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark QBActionStatusDelegate

// QuickBlox API queries delegate
-(void)completedWithResult:(Result *)result{
    // Success result
    if(result.success){
        
        // QuickBlox application authorization result
        if ([result isKindOfClass:[QBAAuthSessionCreationResult class]]) {
            
            // send request for getting all user's files
            PagedRequest *pagedRequest = [[PagedRequest alloc] init];    
            [pagedRequest setPerPage:10];
            
            [QBContent blobsWithPagedRequest:pagedRequest delegate:self];
            
            [pagedRequest release];
        
        // Get User's files result
        } else if ([result isKindOfClass:[QBCBlobPagedResult class]]){
            QBCBlobPagedResult *res = (QBCBlobPagedResult *)result; 
            
            // get all UIDs for downloading files and save them
            NSMutableArray* blobs = [[NSMutableArray alloc] init];
            for (QBCBlob* blob in res.blobs) {
                [blobs addObject:blob.UID];
            }
            [[DataManager instance] saveBlobIds:blobs];
            [blobs release];
            
            // hid splash screen
            [self performSelector:@selector(hideSplashScreen) withObject:self afterDelay:1];
        }
    }
}

@end
