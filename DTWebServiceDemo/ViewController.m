//
//  ViewController.m
//  DTWebServiceDemo
//
//  Created by Dimitris-Sotiris Tsolis on 12/3/15.
//  Copyright (c) 2015 DFG-Team. All rights reserved.
//

#import "ViewController.h"
#import "DTWebService.h"

@interface ViewController ()

@property (nonatomic, strong) DTWebService *webService1;
@property (nonatomic, strong) DTWebService *webService2;
@property (weak, nonatomic) IBOutlet UIButton *btnService1Download;
@property (weak, nonatomic) IBOutlet UIButton *btnService1Cancel;
@property (weak, nonatomic) IBOutlet UIButton *btnService2Download;
@property (weak, nonatomic) IBOutlet UIButton *btnService2Cancel;
@property (weak, nonatomic) IBOutlet UIProgressView *service1ProgressBar;
@property (weak, nonatomic) IBOutlet UIProgressView *service2ProgressBar;
@property (weak, nonatomic) IBOutlet UITextField *tfFile1;
@property (weak, nonatomic) IBOutlet UITextField *tfFile2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)btnService1DownloadAction:(id)sender {
    self.webService1 = [DTWebService webServiceWithURL:[NSURL URLWithString:self.tfFile1.text]];
    
    [self.webService1 startWithFinishedBlock:^(NSData *data, NSStringEncoding stringEncoding) {
        [self showMessageWithTitle:@"Message" message:@"File 1 download completed"];
        
        [self toggleWebService1Buttons];
        self.service1ProgressBar.progress = 0;
    } fail:^(NSError *error, BOOL cancelled) {
        
        if (error && !cancelled)
            [self showErrorMessage:error.localizedDescription];
        
        [self toggleWebService1Buttons];
        self.service1ProgressBar.progress = 0;
    } progress:^(float progressPercentage) {
        self.service1ProgressBar.progress = progressPercentage/100;
    }];
    [self toggleWebService1Buttons];
}

- (IBAction)btnService1CancelAction:(id)sender {
    [self.webService1 stop];
}




- (IBAction)btnService2DownloadAction:(id)sender {
    self.webService2 = [DTWebService webServiceWithURL:[NSURL URLWithString:self.tfFile2.text]];
    
    [self.webService2 startWithFinishedBlock:^(NSData *data, NSStringEncoding stringEncoding) {
        [self showMessageWithTitle:@"Message" message:@"File 2 download completed"];
        
        [self toggleWebService2Buttons];
        self.service2ProgressBar.progress = 0;
    } fail:^(NSError *error, BOOL cancelled) {
        
        if (error && !cancelled)
            [self showErrorMessage:error.localizedDescription];
        
        [self toggleWebService2Buttons];
        self.service2ProgressBar.progress = 0;
    } progress:^(float progressPercentage) {
        self.service2ProgressBar.progress = progressPercentage/100;
    }];
    [self toggleWebService2Buttons];
}

- (IBAction)btnService2CancelAction:(id)sender {
    [self.webService2 stop];
}



- (IBAction)dismissKeyboard:(id)sender {
    if ([self.tfFile1 isFirstResponder])
        [self.tfFile1 resignFirstResponder];
    else if ([self.tfFile2 isFirstResponder])
        [self.tfFile2 resignFirstResponder];
}

#pragma mark - Helpers
- (void)toggleWebService1Buttons {
    self.btnService1Download.enabled = !self.webService1.isBusy;
    self.btnService1Cancel.enabled   = self.webService1.isBusy;
}

- (void)toggleWebService2Buttons {
    self.btnService2Download.enabled = !self.webService2.isBusy;
    self.btnService2Cancel.enabled   = self.webService2.isBusy;
}

- (void)showMessageWithTitle:(NSString *)title message:(NSString *)msg {
    [[[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (void)showErrorMessage:(NSString *)msg {
    [self showMessageWithTitle:@"Error" message:msg];
}

@end
