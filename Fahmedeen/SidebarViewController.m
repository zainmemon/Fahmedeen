//
//  SidebarViewController.m
//  SidebarDemo
//
//  Created by Simon on 29/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "SidebarViewController.h"
#import "SWRevealViewController.h"
#import "Bayan.h"

@interface SidebarViewController ()

@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, strong) NSArray *type;
@end

@implementation SidebarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _menuItems = @[@"Favourites",@"Sunday Bayanaat", @"Bayanaat", @"Morning Dars", @"Mufti Taqi Usmani",@"Ramzan Bayanaat",@"Tafseer",@"Others"];
    _type = @[@"",@"sunday",@"bayans",@"morning",@"tusmani",@"ramdhan",@"tafseer",@"others"];
    
    self.sidebarTableView.bounces = false;
    self.sidebarTableView.tableFooterView = [UIView new];
    
    [self.sidebarTableView setSeparatorColor:[UIColor colorWithRed:168/255.0
                                                             green:216/255.0
                                                              blue:240/255.0
                                                             alpha:1.0]];
}

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    // Set the title of navigation bar by using the menu items
    NSIndexPath *indexPath = [self.sidebarTableView indexPathForSelectedRow];
    if (indexPath.row > 0) {
        NSLog(@"index: %ld",(long)indexPath.row);
        if ([segue.identifier isEqualToString:@"show"]) {
            Bayan *b = (Bayan*)segue.destinationViewController;
            b.title = [[self.menuItems objectAtIndex:indexPath.row -1] capitalizedString];
            
            NSLog(@"title: %@",[self.menuItems objectAtIndex:indexPath.row -1]);
            
            b.type = [self.type objectAtIndex:indexPath.row -1];
            NSLog(@"type: %@",[self.type objectAtIndex:indexPath.row -1]);
        }
        
        if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
            SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
            
            swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
                
                UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
                [navController setViewControllers: @[dvc] animated: NO ];
                [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
            };
        }
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.menuItems count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        NSString *CellIdentifier = @"logoCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        cell.backgroundColor = [UIColor colorWithRed:110.0f/255.0f green:207.0f/255.0f blue:246.0f/255.0f alpha:1.0];
        return cell;
    }
    else
    {
        
        NSString *CellIdentifier = @"listitem";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        UIView *customColorView = [[UIView alloc] init];
        customColorView.backgroundColor = [UIColor colorWithRed:255/255.0
                                                          green:239/255.0
                                                           blue:206/255.0
                                                          alpha:1.0];
        cell.selectedBackgroundView =  customColorView;
        
        cell.textLabel.text = [self.menuItems objectAtIndex:indexPath.row - 1];
        
        return cell;
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"show" sender:self];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if(indexPath.row == 0)
    {
        return 150;
    }
    else
    {
        return 40;
    }
}

@end
