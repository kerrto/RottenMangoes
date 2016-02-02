//
//  MovieDetailViewController.m
//  movie2
//
//  Created by Kerry Toonen on 2016-02-02.
//  Copyright © 2016 Kerry Toonen. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "Movie.h"

@interface MovieDetailViewController ()

@end

@implementation MovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *reviewURL = [self.movie.reviewURL stringByAppendingString:@"?apikey=j9fhnct2tp8wu2q9h75kanh9&page_limit=3"];
    NSURL *url = [NSURL URLWithString:reviewURL];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"Inside completion handler");
        
        if (!error) {
            NSError *jsonParsingError;
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
            if (!jsonParsingError) {
                NSLog(@"%@", jsonData);
    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSArray *reviewArray = jsonData [@"reviews"];
                        
                        
                        NSDictionary *firstReviewDict = reviewArray[0];
                        self.movie.review1 = firstReviewDict[@"quote"];
                        
                        NSDictionary *secondReviewDict=reviewArray[1];
                        self.movie.review2=secondReviewDict[@"quote"];
                        
                        NSDictionary *thirdReviewDict=reviewArray[2];
                        self.movie.review3=thirdReviewDict[@"quote"];
                        
                        self.review1Label.text=self.movie.review1;
                        self.review2Label.text=self.movie.review2;
                        self.review3Label.text=self.movie.review3;
                    });
    
                }
           }
    }];
    
    
    
    
    [dataTask resume];
    
    
    NSLog(@"Somewhere below completion handler");
    
    // There are some shortcuts you can use to condense your code
    //NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"https://api.github.com/users/researchkit/repos"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
