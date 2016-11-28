//
//  LZCategoryTableViewController.m
//  LazadaAssignement
//
//  Created by abhijeet upadhyay on 27/11/16.
//  Copyright © 2016 lazada. All rights reserved.
//

#import "LZCategoryTableViewController.h"
#import "LZPhotosCollectionViewController.h"

@interface LZCategoryTableViewController ()

@property (nonatomic,strong) NSArray *categoriesList;

@end

@implementation LZCategoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Fetching Category data from plist as there is no API for it and only values provided.
    //This can be done using core data but I think that would be overhead.
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Categories" ofType:@"plist"]];
    self.categoriesList = [dictionary objectForKey:@"CategoryValues"];
   
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CategoryCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.categoriesList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryCell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.categoriesList[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    
    LZPhotosCollectionViewController *photosViewController = (LZPhotosCollectionViewController*)[storyboard instantiateViewControllerWithIdentifier:@"photos"];
    photosViewController.categoryName = self.categoriesList[indexPath.row];

    [self.navigationController pushViewController:photosViewController animated:YES];
    
}

@end
