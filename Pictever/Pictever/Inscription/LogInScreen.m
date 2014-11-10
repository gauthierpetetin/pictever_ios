//
//  LogInScreen.m
//  Keo
//
//  Created by Gauthier Petetin on 14/03/2014.
//  Copyright (c) 2014 Gauthier Petetin. All rights reserved.
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////(GO TO APPDELEGATE.M FOR MORE INFO ABOUT THE GLOBAL VARIABLES)/////////////////////////////////

#import "LogInScreen.h"
#import "RegisterScreen.h"
#import "GPRequests.h"
#import <AWSiOSSDKv2/AWSMobileAnalytics.h>
#import <AWSiOSSDKv2/AWSCore.h>
#import "myConstants.h"


@interface LogInScreen ()

//@property (nonatomic, strong) NSMutableData *responseData2;


@end

@implementation LogInScreen

bool firstUseEver;


NSString * backgroundImage; //global

bool openingWindow;
NSString *storyboardName;

//size if the screen
CGFloat screenWidth;//global
CGFloat screenHeight;//global
CGFloat tabBarHeight;//global

NSString *adresseIp2;
NSString *myAppVersion;

NSUserDefaults *prefs;

CGSize keyboardSize;
CGRect rect;

UITextField *textFieldUsername;
UITextField *textFieldPassword1;


UILabel *myWelcomeLabel;
UILabel *monLabelPassword1;


UIButton *backButton2;


UIButton *logInButton;

NSString *username;//global
NSString *password;
NSString *password1;
NSString *hashPassword;//global
NSString *myCurrentPhoneNumber;//global

NSString *reponseLogIn;
NSString *myDeviceToken;
NSString *mytimeStamp;

bool logIn;
bool *connectionDidFinishLoadingOver;


int height;
int yInitial;
int xPassword;
int xButton;
int xUsername;
int yUsername;
int yEspace;
int elevation;

UIActivityIndicatorView *loginSpinner;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:backgroundImage]];
    
    logIn = false;
    
    
    connectionDidFinishLoadingOver = false;
    yInitial=130;
    xPassword=190;
    xUsername=250;
    yEspace=50;
    //xButton=100;
    xButton=250;
    yUsername=30;
    
    
    rect = self.view.frame;
    height = rect.size.height;

    
    //-------------Create tap gesture recognizer---------------------
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondToTapGesture2:)];
    tapRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapRecognizer];

    
    
    //--------------------CREATION OF CONTROLS---------------------
    
    //-------------------creation of title label
    CGRect rectLabUsername = CGRectMake(0.5*screenWidth-(0.5*xUsername),50,xUsername,60);
    myWelcomeLabel = [[UILabel alloc] initWithFrame: rectLabUsername];
    [myWelcomeLabel setTextAlignment:NSTextAlignmentCenter];
    [myWelcomeLabel setFont:[UIFont systemFontOfSize:30]];
    myWelcomeLabel.text = @"Log In to Pictever!";
    
    //----------------Creation of textField Username
    CGRect rectTFUsername = CGRectMake(0.5*screenWidth-(0.5*xUsername),yInitial,xUsername,yUsername); // Définition d'un rectangle
    textFieldUsername = [[UITextField alloc] initWithFrame:rectTFUsername];
    textFieldUsername.textAlignment = NSTextAlignmentCenter;
    textFieldUsername.borderStyle = UITextBorderStyleLine;
    textFieldUsername.delegate=self;
    textFieldUsername.backgroundColor = [UIColor whiteColor];
    textFieldUsername.placeholder = @"Enter your email";
    textFieldUsername.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textFieldUsername.borderStyle = UITextBorderStyleRoundedRect;
     
    //------------------Creation of textField Password1
    CGRect rectTFPassword1 = CGRectMake(0.5*screenWidth-(0.5*xUsername),yInitial+yUsername,xUsername,yUsername);; // Définition d'un rectangle
    textFieldPassword1 = [[UITextField alloc] initWithFrame:rectTFPassword1];
    textFieldPassword1.textAlignment = NSTextAlignmentCenter;
    textFieldPassword1.borderStyle = UITextBorderStyleLine;
    textFieldPassword1.delegate=self;
    textFieldPassword1.backgroundColor = [UIColor whiteColor];
    textFieldPassword1.placeholder = @"Enter your password";
    textFieldPassword1.borderStyle = UITextBorderStyleRoundedRect;
    textFieldPassword1.secureTextEntry = YES;
    
    
    //----------------------Creation du button LOG IN
    logInButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    logInButton.frame = CGRectMake(0.5*screenWidth-(0.5*xButton),yInitial+yUsername+yUsername+20,xButton,yUsername);
    logInButton.backgroundColor = [UIColor whiteColor];
    logInButton.layer.cornerRadius = 10; // arrondir les
    logInButton.clipsToBounds = YES;     // angles du bouton
    [logInButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [logInButton setTitle:@"Log In" forState:UIControlStateNormal];
    [logInButton.titleLabel setFont:[UIFont fontWithName:@"System-Bold" size:15]];
    [[logInButton layer] setBorderWidth:1.0f];
    [logInButton addTarget:self
                    action:@selector(myActionLogIn:)
          forControlEvents:UIControlEventTouchUpInside];
    
    //-----------------Creation of back button
    backButton2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backButton2.frame = CGRectMake(5,screenHeight-45,70,30);
    backButton2.backgroundColor = [UIColor clearColor];
    [backButton2 setTitle:@"Back" forState:UIControlStateNormal];
    [backButton2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backButton2.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [backButton2 addTarget:self
                   action:@selector(backPressed2)
         forControlEvents:UIControlEventTouchUpInside];
    
    //-----------------Creation of loading spinner---------
    loginSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loginSpinner.center = CGPointMake(0.5*screenWidth+105,yInitial+yUsername+0.5*yUsername+50);
    loginSpinner.color = [UIColor blackColor];
    loginSpinner.hidesWhenStopped = YES;
    
    [self.view addSubview: backButton2];
    [self.view addSubview: myWelcomeLabel];
    [self.view addSubview: textFieldUsername];
    [self.view addSubview: textFieldPassword1];
    [self.view addSubview: logInButton];
    [textFieldUsername becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(setUsernameByNotif) name:@"setUsername" object: nil];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    logInButton.enabled = YES;
    logInButton.highlighted = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [loginSpinner stopAnimating];
    [loginSpinner removeFromSuperview];
}

//----------set username when user comes from Register screen ------------------------

-(void)setUsernameByNotif{
    APLLog(@"setUsername");
    textFieldUsername.text=username;
}


//---------------hide keyboard when user taps the screen---------

- (IBAction)respondToTapGesture2:(UITapGestureRecognizer *)recognizer {
    [textFieldPassword1 resignFirstResponder];
    [textFieldUsername resignFirstResponder];
}


//----------------return pressed--------------------------

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textFieldUsername.isFirstResponder){
        [textFieldPassword1 becomeFirstResponder];
    }
    else{
        [textFieldPassword1 resignFirstResponder];
        [textFieldUsername resignFirstResponder];
    }
    
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-----------------go back to welcome screen ------------------------------

-(void) backPressed2{

    [self dismissViewControllerAnimated:YES completion:nil];
}


//-------------------user presses login button-----------------------------------

- (IBAction)myActionLogIn:(id)sender {
    if([textFieldUsername.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:@"Please enter your username first!" delegate:self
                              cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        textFieldPassword1.text=@"";
    }
    else if ([textFieldPassword1.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:@"Please enter your password first!" delegate:self
                              cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    else{
        username = textFieldUsername.text;
        password1 = textFieldPassword1.text;
        
        //self.responseData2 = [NSMutableData data];
        
        hashPassword = [GPRequests sha256HashFor:password1];
        
        [self localAsynchronousLoginWithEmail:username withHashPass:hashPassword for:self];
        
        //NSInteger logInAnswer = [GPRequests loginWithEmail:username withPassWord:hashPassword for:self];
        
        /*
        if(logInAnswer != 200){
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:@"Wrong identifier or password" delegate:self
                                  cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
        else{
            logIn = true;
            
            //---------saves user info--------------

            [prefs setBool:logIn forKey:@"logIn"];
            [prefs setObject:username forKey:@"username"];
            [prefs setObject:hashPassword forKey:@"password"];
            
            NSString *newLogInTimeStamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
            [prefs setObject:newLogInTimeStamp forKey:@"timeStamp"];
 
            //--------------Switch screen to phone number------
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
            UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"phoneScreen"];
            vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:vc animated:YES completion:nil];
        }*/
    }
}

-(void)localAsynchronousLoginWithEmail:(NSString *) userN withHashPass:(NSString *)hashP for:(id)sender{
    
    if ([GPRequests connected]){
        logInButton.enabled = NO;
        logInButton.highlighted = YES;
        [self.view addSubview:loginSpinner];
        [loginSpinner startAnimating];
        
        // 1
        NSURL *loginUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",adresseIp2,my_loginRequestName]];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
        
        // 2
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:loginUrl];
        request.HTTPMethod = @"POST";
        
        // 3
        
        
        NSString *postString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",@"email=",userN,@"&password=",hashP,@"&reg_id=",myDeviceToken,@"&os=ios",@"&app_version=",myAppVersion];
        APLLog([NSString stringWithFormat:@" local asynchronous login session post: %@",postString]);
        NSData* data = [postString dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError *error = nil;
        
        if (!error) {
            // 4
            APLLog(@"local login session: %@", loginUrl);
            NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request
                                                                       fromData:data completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
                                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                                               logInButton.enabled=YES;
                                                                               logInButton.highlighted=NO;
                                                                               [loginSpinner stopAnimating];
                                                                               [loginSpinner removeFromSuperview];
                                                                           });
                                                                           if(error != nil){
                                                                               APLLog(@"New login Error: [%@]", [error description]);
                                                                               
                                                                           }
                                                                           else{
                                                                               NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                                                               NSInteger sessionErrorCode = [httpResponse statusCode];
                                                                               [self localLoginSucceeded:data withErrorCode:sessionErrorCode from:sender];
                                                                           }
                                                                       }];
            
            // 5
            [uploadTask resume];
        }
    }
}

-(void)localLoginSucceeded:(NSData *)data withErrorCode:(NSInteger)sessionErrorCode from:(id)sender{
    APLLog(@"local login session did receive response with error code: %i",sessionErrorCode);
    if(sessionErrorCode != 200){
        if(sessionErrorCode == 401){
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Login error"
                                      message:@"Wrong password" delegate:self
                                      cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
                textFieldPassword1.text = @"";
            });
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Error"
                                      message:@"Wrong identifier or password" delegate:self
                                      cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
                
            });
        }
    }
    else{
        firstUseEver = true;
        logIn = true;
        
        //---------saves user info--------------
        
        [prefs setBool:logIn forKey:@"logIn"];
        [prefs setObject:username forKey:@"username"];
        [prefs setObject:hashPassword forKey:@"password"];
        
        //-----------update timestamp-------------------------------
        NSString *newLogInTimeStamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
        mytimeStamp = newLogInTimeStamp;
        [prefs setObject:newLogInTimeStamp forKey:my_prefs_timestamp_key];
        
        
        //--------------Switch screen to phone number------
        dispatch_async(dispatch_get_main_queue(), ^{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
            UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"phoneScreen"];
            vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:vc animated:YES completion:nil];
        });
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        logInButton.enabled=YES;
        logInButton.highlighted=NO;
        [loginSpinner stopAnimating];
        [loginSpinner removeFromSuperview];
    });
}




@end



