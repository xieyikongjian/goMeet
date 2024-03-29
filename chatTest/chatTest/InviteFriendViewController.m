//
//  InviteFriendViewController.m
//  chatTest
//
//  Created by Simin Liu on 5/15/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import "InviteFriendViewController.h"
#import "CreateNewEventViewController.h"
#import "AppDelegate.h"

#define OFF_SET 18.0

@interface InviteFriendViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UICollectionView *friendCollectionView;


@property (strong,nonatomic)NSString* searchString;

@property (strong,nonatomic)NSArray* sortedList;
@property (strong,nonatomic)NSMutableArray* selectedList;

@end

@implementation InviteFriendViewController
@synthesize orginalController;
BOOL isSearching;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    _searchBar.delegate = self;
    isSearching = false;
    _searchBar.showsCancelButton = YES;
    _selectedList = [[NSMutableArray alloc]init];
    [_friendCollectionView setDataSource:self];
    [_friendCollectionView setDelegate:self];
    _friendCollectionView.allowsMultipleSelection = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    //Need more observation of performance
    //[self setup];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma searchBar editor help
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}


-(BOOL)searchBarDidEndEditing:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [_searchBar resignFirstResponder];
    return YES;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    isSearching = true;
    _searchString = [[@"*" stringByAppendingString:searchText ] stringByAppendingString:@"*"];
    [[_friendCollectionView subviews] makeObjectsPerformSelector: @selector(removeFromSuperview)];
    [self setup];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder]; // using method search bar
    [_searchBar resignFirstResponder]; // using actual object name
    [self.view endEditing:YES];
    isSearching = false;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_searchBar resignFirstResponder];
}



-(void)setup
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Friend"];
    request.predicate = nil;
    if(isSearching){
        NSPredicate *predicate =[NSPredicate predicateWithFormat:@"userNickName like[c] %@",_searchString];
        [request setPredicate:predicate];
        
    }
    
    NSError *error;
    NSArray *array = [[NSArray alloc]init];
    array = [[(AppDelegate*) [[UIApplication sharedApplication]delegate] managedObjectContext] executeFetchRequest:request error:&error];
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"userNickName" ascending:YES];
    _sortedList = [[NSArray alloc]init];
    _sortedList=[array sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor, nil]];
    if (array != nil) {
        NSUInteger count = [array count]; // May be 0 if the object has been deleted.
        NSLog(@"%lu Friends available",(unsigned long)count);
    }
    else {
        // Deal with error.
        NSLog(@"No Friends Available");
    }
    [self.friendCollectionView reloadData];
}

#pragma collectionView editor help

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 120);
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    NSLog(@"Numver of cells %lu",(unsigned long)[self.sortedList count]);
    return [self.sortedList count];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"Array is %@",self.sortedList);
    FriendCell*cell = [[FriendCell alloc]init];
    cell= [self.friendCollectionView dequeueReusableCellWithReuseIdentifier:@"FriendCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.myFriend = _sortedList[indexPath.row];
    [cell deselect:cell];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath

{
    FriendCell *cell = (FriendCell *)[collectionView cellForItemAtIndexPath:indexPath];
    // Set the index once user taps on a cell
    [_selectedList addObject:cell.myFriend];
    // Set the selection here so that selection of cell is shown to ur user immediately
    [cell select:cell];
    [cell setNeedsDisplay];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath

{
    //NSLog(@"Diselect one cell");
    FriendCell *cell = (FriendCell *)[collectionView cellForItemAtIndexPath:indexPath];
    // Set the index once user taps on a cell
    [_selectedList removeObject:cell.myFriend];
    // Set the selection here so that selection of cell is shown to ur user immediately
    [cell deselect:cell];
    [cell setNeedsDisplay];
}


- (IBAction)confirm:(id)sender {
    //NSLog(@"SELECTED LIST IS %@",_selectedList);
    [self.orginalController setFoo:_selectedList];
    [self dismissViewControllerAnimated:NO completion:nil];
}



@end

