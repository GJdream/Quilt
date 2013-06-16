//
//  AccountViewController.m
//  Quilt
//
//  Created by Thomas, Anna E on 13/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

//#import <MobileCoreServices/UTCoreTypes.h>
#import "AccountViewController.h"
#import "Account.h"
#import "FriendsDataController.h"

@interface AccountViewController ()

@end

@implementation AccountViewController
@synthesize popoverController;
@synthesize imageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.password.delegate = (id)self;
    self.confirmPassword.delegate = (id)self;
    self.username.text = [Account current].username;
    [[Account current] setPhoto:self];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"QuiltTexture.png"]];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == self.confirmPassword)
    {
        if([self.confirmPassword.text isEqualToString:self.password.text])
        {
            self.saveChanges.enabled = YES;
            self.validPasswordLabel.text = @"";
            self.password.textColor = [UIColor blackColor];
            self.confirmPassword.textColor = [UIColor blackColor];
        }
        else
        {
            if(![self.confirmPassword.text isEqualToString:@""])
            {
                self.saveChanges.enabled = NO;
                self.validPasswordLabel.text = @"mismatched passwords";
                self.password.textColor = [UIColor redColor];
                self.confirmPassword.textColor = [UIColor redColor];
            }
        }
    }
}

- (IBAction)saveChangesClicked:(id)sender
{
    self.saveChanges.enabled = NO;
    self.uploadPicture.enabled = NO;
    [Account changePasswordWithOldPassword:self.oldPassword.text NewPassword:self.password.text ConfirmPassword:self.confirmPassword.text AccountView:self];
}

- (IBAction)addFriend:(id)sender {
    NSString *name = self.addFriendUsername.text;
    [[FriendsDataController instantiate] addFriend:name];
}

- (IBAction)takeCameraPhotoClicked:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeImage, nil];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker animated:YES completion:NULL];
        newMedia = YES;
    }
}

- (IBAction)uploadPictureClicked:(id)sender
{
    if ([self.popoverController isPopoverVisible])
    {
        [self.popoverController dismissPopoverAnimated:YES];
    } else
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            //picker.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeImage, nil];
            picker.allowsEditing = NO;
            
            self.popoverController = [[UIPopoverController alloc] initWithContentViewController:picker];
            
            popoverController.delegate = self;
            
            [self.popoverController presentPopoverFromRect:self.uploadPicture.bounds inView:self.uploadPicture permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            newMedia = NO;
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.popoverController dismissPopoverAnimated:true];
    
    //NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
    imageView.image = image;
    if (newMedia)
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:finishedSavingWithError:contextInfo:), nil);
    
    [Account changePhoto:image AccountView:self];
}

-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
            initWithTitle: @"Save failed"
            message: @"Failed to save image"\
            delegate: nil
            cancelButtonTitle:@"OK"
            otherButtonTitles:nil];
        [alert show];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
