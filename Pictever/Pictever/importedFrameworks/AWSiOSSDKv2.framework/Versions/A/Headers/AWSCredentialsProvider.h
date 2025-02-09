/*
 * Copyright 2010-2014 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License").
 * You may not use this file except in compliance with the License.
 * A copy of the License is located at
 *
 *  http://aws.amazon.com/apache2.0
 *
 * or in the "license" file accompanying this file. This file is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

#import <Foundation/Foundation.h>
#import <AWSiOSSDKv2/AWSServiceEnum.h>

FOUNDATION_EXPORT NSString *const AWSCognitoIdentityIdChangedNotification;
FOUNDATION_EXPORT NSString *const AWSCognitoNotificationPreviousId;
FOUNDATION_EXPORT NSString *const AWSCognitoNotificationNewId;

FOUNDATION_EXPORT NSString *const AWSCognitoCredentialsProviderErrorDomain;
typedef NS_ENUM(NSInteger, AWSCognitoCredentialsProviderErrorType) {
    AWSCognitoCredentialsProviderErrorUnknown
};

typedef NS_ENUM(NSInteger, AWSCognitoLoginProviderKey) {
    AWSCognitoLoginProviderKeyUnknown,
    AWSCognitoLoginProviderKeyFacebook,
    AWSCognitoLoginProviderKeyGoogle,
    AWSCognitoLoginProviderKeyLoginWithAmazon,
};

@class BFTask;

@protocol AWSCredentialsProvider <NSObject>

@optional
@property (nonatomic, strong, readonly) NSString *accessKey;
@property (nonatomic, strong, readonly) NSString *secretKey;
@property (nonatomic, strong, readonly) NSString *sessionKey;
@property (nonatomic, strong, readonly) NSDate *expiration;

- (BFTask *)refresh;

@end

@interface AWSStaticCredentialsProvider : NSObject <AWSCredentialsProvider>

@property (nonatomic, readonly) NSString *accessKey;
@property (nonatomic, readonly) NSString *secretKey;

+ (instancetype)credentialsWithAccessKey:(NSString *)accessKey
                               secretKey:(NSString *)secretKey;
+ (instancetype)credentialsWithCredentialsFilename:(NSString *)credentialsFilename;

- (instancetype)initWithAccessKey:(NSString *)accessKey
                        secretKey:(NSString *)secretKey;

@end

@interface AWSAnonymousCreentialsProvider : NSObject <AWSCredentialsProvider>

@end

@interface AWSWebIdentityCredentialsProvider : NSObject <AWSCredentialsProvider>

@property (nonatomic, strong, readonly) NSString *accessKey;
@property (nonatomic, strong, readonly) NSString *secretKey;
@property (nonatomic, strong, readonly) NSString *sessionKey;
@property (nonatomic, strong, readonly) NSDate *expiration;

@property (nonatomic, strong) NSString *webIdentityToken;
@property (nonatomic, strong) NSString *roleArn;
@property (nonatomic, strong) NSString *provider;

+ (instancetype)credentialsWithRegionType:(AWSRegionType)regionType
                                 provider:(NSString *)provider
                         webIdentityToken:(NSString *)webIdentityToken
                                  roleArn:(NSString *)roleArn;

- (instancetype)initWithRegionType:(AWSRegionType)regionType
                          provider:(NSString *)provider
                  webIdentityToken:(NSString *)webIdentityToken
                           roleArn:(NSString *)roleArn;

- (BFTask *)refresh;

@end


@interface AWSCognitoCredentialsProvider : NSObject <AWSCredentialsProvider>

@property (nonatomic, strong, readonly) NSString *accessKey;
@property (nonatomic, strong, readonly) NSString *secretKey;
@property (nonatomic, strong, readonly) NSString *sessionKey;
@property (nonatomic, strong, readonly) NSDate *expiration;

@property (nonatomic, strong, readonly) NSString *identityId;
@property (nonatomic, strong, readonly) NSString *identityPoolId;

@property (nonatomic, strong) NSDictionary *logins;

+ (instancetype)credentialsWithRegionType:(AWSRegionType)regionType
                                accountId:(NSString *)accountId
                           identityPoolId:(NSString *)identityPoolId
                            unauthRoleArn:(NSString *)unauthRoleArn
                              authRoleArn:(NSString *)authRoleArn;

+ (instancetype)credentialsWithRegionType:(AWSRegionType)regionType
                                accountId:(NSString *)accountId
                           identityPoolId:(NSString *)identityPoolId
                            unauthRoleArn:(NSString *)unauthRoleArn
                              authRoleArn:(NSString *)authRoleArn
                                   logins:(NSDictionary *)logins;

+ (instancetype)credentialsWithRegionType:(AWSRegionType)regionType
                               identityId:(NSString *)identityId
                                accountId:(NSString *)accountId
                           identityPoolId:(NSString *)identityPoolId
                            unauthRoleArn:(NSString *)unauthRoleArn
                              authRoleArn:(NSString *)authRoleArn
                                   logins:(NSDictionary *)logins;

- (instancetype)initWithRegionType:(AWSRegionType)regionType
                        identityId:(NSString *)identityId
                         accountId:(NSString *)accountId
                    identityPoolId:(NSString *)identityPoolId
                     unauthRoleArn:(NSString *)unauthRoleArn
                       authRoleArn:(NSString *)authRoleArn
                            logins:(NSDictionary *)logins;

/**
 *  Refreshes the locally stored credentials. The SDK automatically calls this method when necessary, and you do not need to call this method manually.
 *
 *  @return <#return value description#>
 */
- (BFTask *)refresh;

- (BFTask *)getIdentityId;

- (void)clearKeychain;

@end