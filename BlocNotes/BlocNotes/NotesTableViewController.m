//
//  NotesTableViewController.m
//  BlocNotes
//
//  Created by Xoi's iMac on 2015-09-21.
//  Copyright (c) 2015 XoiAHin. All rights reserved.
//

#import "NotesTableViewController.h"
#import "DetailNotesViewController.h"
#import "myShareManager.h"
#import "BlocNotes.h"



@interface NotesTableViewController () <UISearchControllerDelegate>

@property (nonatomic, strong) NSMutableArray *notesArray;
@property (nonatomic, strong) NSMutableArray *filterNotesArray;

@property (readwrite, strong) NSManagedObjectContext *managedObjectContext;
@property (readwrite, strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end


@implementation NotesTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    self.navigationItem.title = NSLocalizedString(@"BlocNotes", @"TableView Title");
    
    myShareManager *sharedManager = [myShareManager sharedManager];
    self.managedObjectContext = [sharedManager createManagedObjectContextWithConcurrencyType:NSMainQueueConcurrencyType];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Fetch the devices from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"BlocNotes"];
    
    // Sort
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"noteTitle" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    self.notesArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    [self.tableView reloadData];
}



#pragma mark - Search

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"(noteTitle contains[c] %@) or (noteText contains[c] %@)", searchText, searchText];
    self.filterNotesArray = [[self.notesArray filteredArrayUsingPredicate:resultPredicate]mutableCopy];
}



-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.filterNotesArray count];
    } else {
        return self.notesArray.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"NoteCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    NSManagedObject *myNote = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        myNote = [self.filterNotesArray objectAtIndex:indexPath.row];
    } else {
        myNote = [self.notesArray objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.font = [ UIFont fontWithName: @"Bodoni 72 Oldstyle" size: 20.0 ];
    cell.textLabel.textColor = [UIColor brownColor];
    [cell.textLabel setText:[NSString stringWithFormat:@"%@", [myNote valueForKey:@"noteTitle"]]];
    
    [cell.detailTextLabel setText:[myNote valueForKey:@"noteText"]];
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Delete object from database
        if (self.searchDisplayController.active) {
            NSIndexPath *indexPath = nil;
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            [context deleteObject:[self.filterNotesArray objectAtIndex:indexPath.row]];
        } else {
        [context deleteObject:[self.notesArray objectAtIndex:indexPath.row]];
        }
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }
        
        
        // Remove device from table view
        
        if (self.searchDisplayController.active) {
            [self.filterNotesArray removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            [self.notesArray removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"UpdateNote"]) {
        
        NSManagedObject *selectedNote = nil;
        NSIndexPath *indexPath = nil;
        
        if (self.searchDisplayController.active) {
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            selectedNote = [self.filterNotesArray objectAtIndex:indexPath.row];
        } else {
            indexPath = [self.tableView indexPathForSelectedRow];
            selectedNote = [self.notesArray objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
        }
        
        DetailNotesViewController *destViewController = segue.destinationViewController;
        destViewController.selectedNote = selectedNote;
    }
}








@end
