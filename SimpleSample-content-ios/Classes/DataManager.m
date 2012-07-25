//
//  DataManager.m
//  SimpleSampleContent
//
//  Created by kirill on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataManager.h"

static DataManager* instance = nil;

@implementation DataManager

@synthesize blobIds = _blobIds;
@synthesize userImages = _userImages;

+(DataManager*)instance{
    if (!instance) {
        instance = [[DataManager alloc] init];
    }
    return instance;
}

-(void)saveBlobIds:(NSMutableArray*)blobs{
    _blobIds = [[NSMutableArray alloc] initWithArray:blobs];
}

-(void)saveUserPicture:(UIImage*)userImage{
    if (!_userImages) {
        _userImages = [[NSMutableArray alloc] init];
    }
    [_userImages addObject:userImage];
}

@end
