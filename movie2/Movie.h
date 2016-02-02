//
//  Movie.h
//  movie2
//
//  Created by Kerry Toonen on 2016-02-02.
//  Copyright © 2016 Kerry Toonen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Movie : NSObject

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) UIImage *thumbnailImage;

@property (nonatomic, strong) NSString *reviewURL;

@property (nonatomic, strong) NSString *review1;

@property (nonatomic, strong) NSString *review2;

@property (nonatomic, strong) NSString *review3;


@end
