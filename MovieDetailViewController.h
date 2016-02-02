//
//  MovieDetailViewController.h
//  movie2
//
//  Created by Kerry Toonen on 2016-02-02.
//  Copyright © 2016 Kerry Toonen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

@interface MovieDetailViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *review1Label;
@property (strong, nonatomic) IBOutlet UILabel *review2Label;

@property (strong, nonatomic) IBOutlet UILabel *review3Label;

@property (strong, nonatomic) Movie *movie;
@end
