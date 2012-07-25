//
//  DataManager.h
//  SimpleSampleContent
//
//  Created by kirill on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject{
    
}
@property (nonatomic,retain) NSMutableArray* blobIds;
@property (nonatomic,retain) NSMutableArray* userImages;

+(DataManager*)instance;

-(void)saveBlobIds:(NSMutableArray*)blobs;
-(void)saveUserPicture:(UIImage*)userImage;

@end
