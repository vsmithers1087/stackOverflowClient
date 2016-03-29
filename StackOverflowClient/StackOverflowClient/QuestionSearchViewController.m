//
//  QuestionSearchViewController.m
//  StackOverflowClient
//
//  Created by Vincent Smithers on 3/28/16.
//  Copyright © 2016 Vince Smithers. All rights reserved.
//

#import "QuestionSearchViewController.h"
#import "StackOverflowService.h"
#import "JSONParser.h"
#import "Question.h"

@interface QuestionSearchViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBAr;


@property(strong, nonatomic)NSArray<Question*> *datasource;


@end

@implementation QuestionSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView.dataSource = self;
    
    // Do any additional setup after loading the view.
    [StackOverflowService searchWithTerm:@"iOS" withCompletion:^(NSDictionary * _Nullable data, NSError * _Nullable error) {
        
        if (error == nil) {
            
            NSLog(@"DATA: %@", data);
             self.datasource = [JSONParser questionsArrayFromDictionary:data];
            
            [_tableView reloadData];
        
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+(NSString*)identifier{
    return @"QuestionSearchViewController";
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"questionCell"];
    
    cell.textLabel.text = self.datasource[indexPath.row].title;
    
    return cell;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_datasource count];
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [StackOverflowService searchWithTerm:searchBar.text withCompletion:^(NSDictionary * _Nullable data, NSError * _Nullable error) {
        
        if (error == nil) {
            
            self.datasource = [JSONParser questionsArrayFromDictionary:data];
             
            [_tableView reloadData];
            
        }
    }];
    
    [self resignFirstResponder];
}

@end
