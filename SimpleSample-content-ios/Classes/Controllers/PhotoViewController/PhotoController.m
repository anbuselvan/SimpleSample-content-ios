//
//  PhotoController.m
//  SimpleSampleContent
//
//  Created by kirill on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotoController.h"

@interface PhotoController ()

@end

@implementation PhotoController

-(id)initWithImage:(UIImage*)imageToDisplay{
    self = [super init];
    if (self) {
        
        // Show full screen image
        UIImageView* photoDisplayer = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 400, 420)];
        photoDisplayer.opaque = NO;
        [photoDisplayer setImage:imageToDisplay];
        [self.view addSubview:photoDisplayer];
        [photoDisplayer release];
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
