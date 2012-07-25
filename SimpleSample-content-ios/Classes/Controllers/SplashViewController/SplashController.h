//
//  SplashController.h
//  SimpleSampleContent
//
//  Created by kirill on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SplashController : UIViewController<QBActionStatusDelegate>

@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
