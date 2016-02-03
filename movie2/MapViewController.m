//
//  MapViewController.m
//  movie2
//
//  Created by Kerry Toonen on 2016-02-02.
//  Copyright © 2016 Kerry Toonen. All rights reserved.
//

#import "MapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import <CoreLocation/CLGeocoder.h>
#import <CoreLocation/CLPlacemark.h>

@interface MapViewController () <CLLocationManagerDelegate, MKMapViewDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (assign, nonatomic) BOOL initialLocationSet;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.mapView=[[MKMapView alloc]init];
    
    self.mapView.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getJSONMapData:(CLLocation*)location
{
    CLGeocoder* reverseGeocoder = [[CLGeocoder alloc] init];
    if (reverseGeocoder)
    {
        [reverseGeocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
         {
             CLPlacemark* placemark = [placemarks firstObject];
             if (placemark)
             {
                 //Using blocks, get zip code
                 NSString *postalCode = placemark.postalCode;
                 
                 NSURLSession *session = [NSURLSession sharedSession];
                 
                 NSString *urlString = @"http://lighthouse-movie-showtimes.herokuapp.com/theatres.json?address=";
                 
                 NSString *addPostalString=[urlString stringByAppendingString:postalCode];
                 
                 NSString *addMovieString=[addPostalString stringByAppendingString:@"&movie="];
                 
                 NSString *realURLString = [addMovieString stringByAppendingString:self.movie.title];
                 realURLString = [realURLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                 
                 NSURL *url = [NSURL URLWithString:realURLString];
                 
                 NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
                 NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                   {
                       NSLog(@"Inside completion handler");
                       
                       if (!error)
                       {
                           NSError *jsonParsingError;
                           NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
                           if (!jsonParsingError)
                           {
                               
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   NSArray *theatres = jsonData[@"theatres"];
                                   
                                   CLLocationCoordinate2D location;
                                   for (NSDictionary *theatre in theatres)
                                   {
                                       
                                       MKPointAnnotation *marker = [[MKPointAnnotation alloc] init];
                                       
                                       marker.coordinate = CLLocationCoordinate2DMake([theatre[@"lat"] doubleValue], [theatre[@"lng"] doubleValue]);
                                       marker.title = theatre[@"name"];
                                       marker.subtitle = theatre[@"address"];
                                       
                                       NSLog(@"%f %f", marker.coordinate.latitude, marker.coordinate.longitude);
                                       [self.mapView addAnnotation:marker];
                                       location = marker.coordinate;
                                   }
                                   
                                   [self.mapView setRegion:MKCoordinateRegionMake(location, MKCoordinateSpanMake(0.1, 0.1)) animated:YES];
                                   
                               });
                           }
                       }
                   }];
                 [dataTask resume];
             }
         }];
        
        
    }
}



#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"Authorization changed");
    
    // If the user's allowed us to use their location, we can start getting location updates
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        [self.locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    
    // Get the last object from the list of locations we get back
    CLLocation *userLocation = [locations lastObject];
    
    // Only do the zoom in once
    if (!self.initialLocationSet) {
        self.initialLocationSet = YES;
        
        // Create a region around the user's location
        CLLocationCoordinate2D userCoordinate = userLocation.coordinate;
        MKCoordinateRegion userRegion = MKCoordinateRegionMake(userCoordinate, MKCoordinateSpanMake(0.01, 0.01));
        
        [self getJSONMapData:userLocation];
        
        [self.mapView setRegion:userRegion animated:YES];
        
        
        //        CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
        //        [geoCoder geocodeAddressString:@"46 Spadina, Toronto" completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        //            if (!error) {
        //                // The Placemark will have information about the location, like the coordinates, postal code, etc.
        //                CLPlacemark *placemark = [placemarks lastObject];
        //                NSLog(@"%@", placemark);
        //            }
        //        }];
    }
}

#pragma mark MKMapViewDelegate


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    // Don't customize user's location annotation
    if (annotation == mapView.userLocation) {
        return nil;
    }
    
    // Create our own annotations and customize the image
    MKAnnotationView *pinView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"Theatre"];
    if (!pinView) {
        pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Theatre"];
        pinView.image = [UIImage imageNamed:@"stacks-image-530F043.png"];
        pinView.centerOffset = CGPointMake(0, -pinView.image.size.height/2);
    }
    
    return pinView;
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
