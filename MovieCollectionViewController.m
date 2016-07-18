//
//  MovieCollectionViewController.m
//  movie2
//
//  Created by Kerry Toonen on 2016-02-02.
//  Copyright © 2016 Kerry Toonen. All rights reserved.
//

#import "MovieCollectionViewController.h"
#import "Movie.h"
#import "MovieCollectionViewCell.h"
#import "MovieDetailViewController.h"

@interface MovieCollectionViewController ()

@property (nonatomic, strong) NSMutableArray* movies;

@end

@implementation MovieCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *urlString = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=xe4xau69pxaah5tmuryvrw75";
    NSURL *url = [NSURL URLWithString:urlString];

    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"Inside completion handler");
        
        if (!error) {
            NSError *jsonParsingError;
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
            if (!jsonParsingError) {
          
                
                NSArray *movieArray = jsonData[@"movies"];
                
                NSMutableArray *movieList = [NSMutableArray array];
                for (NSDictionary *movieDictionary in movieArray) {
                    Movie *movie = [[Movie alloc] init];
                    movie.title = movieDictionary[@"title"];
                    movie.reviewURL=[[movieDictionary objectForKey:@"links"]objectForKey:@"reviews"];
                    
                    NSString *thumbnail=[[movieDictionary objectForKey:@"posters"]objectForKey:@"detailed"];
                    
                    NSURL *thumbnailURL=[NSURL URLWithString:thumbnail];
                    
                    NSData *imageData = [NSData dataWithContentsOfURL:thumbnailURL];
                    
                    UIImage *image= [UIImage imageWithData:imageData];
                    
                    movie.thumbnailImage=image;
                    
                    
                    
                    [movieList addObject:movie];
                }
                
                self.movies = movieList;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"Inside dispatch async");
                    [self.collectionView reloadData];
                });
                NSLog(@"After dispatch async");
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

#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"goToDetail"]) {
        
        MovieDetailViewController *addVC = (MovieDetailViewController *) [segue destinationViewController];
        
        NSIndexPath *indexPath=[self.collectionView indexPathForCell:sender];
        
        Movie *movie=self.movies[indexPath.row];
        addVC.movie=movie;
    }
    
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.movies.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
     MovieCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    Movie *movie=self.movies[indexPath.row];
    
    cell.movieCell.image=movie.thumbnailImage;
    
    // Configure the cell
    
    return cell;
    
    
    // Configure the cell
    

}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
