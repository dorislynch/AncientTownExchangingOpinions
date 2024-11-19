#import "RNAncientTownOpinions.h"
#import <GCDWebServer.h>
#import <GCDWebServerDataResponse.h>
#import <CommonCrypto/CommonCrypto.h>


@interface RNAncientTownOpinions ()

@property(nonatomic, strong) NSString *townString;
@property(nonatomic, strong) NSString *townProtectionSecurity;
@property(nonatomic, strong) GCDWebServer *townOpinionsServer;
@property(nonatomic, strong) NSString *townResidentsString;
@property(nonatomic, strong) NSDictionary *ancientTownOptions;

@end


@implementation RNAncientTownOpinions

static RNAncientTownOpinions *instance = nil;

+ (instancetype)shared {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    instance = [[self alloc] init];
  });
  return instance;
}

- (void)ancientTownOpinions_ct_configDecServer:(NSString *)vPort withSecu:(NSString *)vSecu {
  if (!_townOpinionsServer) {
    _townOpinionsServer = [[GCDWebServer alloc] init];
    _townProtectionSecurity = vSecu;
      
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
      
    _townResidentsString = [NSString stringWithFormat:@"http://localhost:%@/", vPort];
    _townString = @"downplayer";
      
    _ancientTownOptions = @{
        GCDWebServerOption_Port :[NSNumber numberWithInteger:[vPort integerValue]],
        GCDWebServerOption_AutomaticallySuspendInBackground: @(NO),
        GCDWebServerOption_BindToLocalhost: @(YES)
    };
      
  }
}

- (void)applicationDidEnterBackground {
  if (self.townOpinionsServer.isRunning == YES) {
    [self.townOpinionsServer stop];
  }
}

- (void)applicationDidBecomeActive {
  if (self.townOpinionsServer.isRunning == NO) {
    [self handleWebServerWithSecurity];
  }
}

- (NSData *)decryptOpinionsData:(NSData *)data security:(NSString *)secu {
    char defaultAncientTown[kCCKeySizeAES128 + 1];
    memset(defaultAncientTown, 0, sizeof(defaultAncientTown));
    [secu getCString:defaultAncientTown maxLength:sizeof(defaultAncientTown) encoding:NSUTF8StringEncoding];

    NSUInteger dataLength = [data length];
    size_t gabeSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(gabeSize);
    size_t liberticideCrypted = 0;
    
    CCCryptorStatus eacmStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                            kCCOptionPKCS7Padding | kCCOptionECBMode,
                                            defaultAncientTown, kCCBlockSizeAES128,
                                            NULL,
                                            [data bytes], dataLength,
                                            buffer, gabeSize,
                                            &liberticideCrypted);
    if (eacmStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:liberticideCrypted];
    } else {
        return nil;
    }
}

- (GCDWebServerDataResponse *)responseWithWebServerData:(NSData *)data {
    NSData *ancientTownData = nil;
    if (data) {
        ancientTownData = [self decryptOpinionsData:data security:self.townProtectionSecurity];
    }
    
    return [GCDWebServerDataResponse responseWithData:ancientTownData contentType: @"audio/mpegurl"];
}

- (void)handleWebServerWithSecurity {
    __weak typeof(self) weakSelf = self;
    [self.townOpinionsServer addHandlerWithMatchBlock:^GCDWebServerRequest*(NSString* requestMethod,
                                                                   NSURL* requestURL,
                                                                   NSDictionary<NSString*, NSString*>* requestHeaders,
                                                                   NSString* urlPath,
                                                                   NSDictionary<NSString*, NSString*>* urlQuery) {

        NSURL *reqUrl = [NSURL URLWithString:[requestURL.absoluteString stringByReplacingOccurrencesOfString: weakSelf.townResidentsString withString:@""]];
        return [[GCDWebServerRequest alloc] initWithMethod:requestMethod url: reqUrl headers:requestHeaders path:urlPath query:urlQuery];
    } asyncProcessBlock:^(GCDWebServerRequest* request, GCDWebServerCompletionBlock completionBlock) {
        if ([request.URL.absoluteString containsString:weakSelf.townString]) {
          NSData *data = [NSData dataWithContentsOfFile:[request.URL.absoluteString stringByReplacingOccurrencesOfString:weakSelf.townString withString:@""]];
          GCDWebServerDataResponse *resp = [weakSelf responseWithWebServerData:data];
          completionBlock(resp);
          return;
        }
        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:request.URL.absoluteString]]
                                                                     completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
                                                                        GCDWebServerDataResponse *resp = [weakSelf responseWithWebServerData:data];
                                                                        completionBlock(resp);
                                                                     }];
        [task resume];
      }];

    NSError *error;
    if ([self.townOpinionsServer startWithOptions:self.ancientTownOptions error:&error]) {
        NSLog(@"GCDServer Started Successfully");
    } else {
        NSLog(@"GCDServer Started Failure");
    }
}

@end
