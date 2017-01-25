
//
//  loginvc.m
//  NewRDBeacon
//
//  Created by totyu3 on 17/1/25.
//  Copyright © 2017年 NIT. All rights reserved.
//

#import "loginvc.h"

@interface loginvc ()
@property (weak, nonatomic) IBOutlet UITextField *devicename;

@end

@implementation loginvc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![NITUserDefaults objectForKey:@"devicename"]) {
        _devicename.text = @"";
    }else{
        _devicename.text = [NITUserDefaults objectForKey:@"devicename"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)ToMain:(id)sender {
    if (!_devicename.text.length) {
        
    }else{
        [NITUserDefaults setObject:_devicename.text forKey:@"devicename"];
        [self performSegueWithIdentifier:@"ToMainPush" sender:self];
    }
}

#pragma mark -Text field delegate and Text view delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
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
