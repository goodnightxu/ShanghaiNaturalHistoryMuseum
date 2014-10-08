//
//  PictureSelectViewController.m
//  ShanghaiNaturalHistoryMuseum
//
//  Created by Leon on 14/9/19.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import "PictureSelectViewController.h"

@interface PictureSelectViewController ()

@end

@implementation PictureSelectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil contentVC:(UIViewController *)contentVC;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.contentVC = contentVC;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - StartMediaBrowse
- (BOOL)startMediaBrowserFromViewController: (UIViewController*) controller
                                        type:(UIImagePickerControllerSourceType)sourceType{
    
    if (([UIImagePickerController isSourceTypeAvailable:
          sourceType] == NO)
        || (controller == nil))
        return NO;
    
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = sourceType;
    mediaUI.allowsEditing = YES;
    mediaUI.delegate = self;
    
    [self presentViewController:mediaUI animated:YES completion:nil];
    
    return YES;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *editedImage = (UIImage *) [info objectForKey:
                                        UIImagePickerControllerEditedImage];

    [picker dismissViewControllerAnimated:YES completion:^{
       
    }];
    if (self.onComplete!= nil) {
        self.onComplete(editedImage);
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
       
    }];
    if (self.onComplete != nil) {
        self.onComplete(nil);
    }
}


#pragma mark - Button
- (IBAction)onLocalBt:(id)sender
{

    [self startMediaBrowserFromViewController:self.contentVC type:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (IBAction)onCameraBt:(id)sender
{
    [self startMediaBrowserFromViewController:self.contentVC type:UIImagePickerControllerSourceTypeCamera];
}
@end
