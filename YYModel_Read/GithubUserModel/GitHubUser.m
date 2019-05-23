//
//  GitHubUser.m
//  ModelBenchmark
//
//  Created by ibireme on 15/9/18.
//  Copyright (c) 2015 ibireme. All rights reserved.
//

#import "GitHubUser.h"
#import "DateFormatter.h"


@implementation GHUser

#define GHUSER_MANUALLY_SETTER_LIST \
SET_STR(_login, @"login"); \
SET_NUM(_userID, @"id"); \
SET_STR(_avatarURL, @"avatar_url"); \
SET_STR(_gravatarID, @"gravatar_id"); \
SET_STR(_url, @"url"); \
SET_STR(_htmlURL, @"html_url"); \
SET_STR(_followersURL, @"followers_url"); \
SET_STR(_followingURL, @"following_url"); \
SET_STR(_gistsURL, @"gists_url"); \
SET_STR(_starredURL,@"starred_url"); \
SET_STR(_subscriptionsURL, @"subscriptions_url"); \
SET_STR(_organizationsURL, @"organizations_url"); \
SET_STR(_reposURL, @"repos_url"); \
SET_STR(_eventsURL, @"events_url"); \
SET_STR(_receivedEventsURL, @"received_events_url"); \
SET_STR(_type, @"type"); \
SET_NUM(_siteAdmin, @"site_admin"); \
SET_STR(_name, @"name"); \
SET_STR(_company, @"company"); \
SET_STR(_blog, @"blog"); \
SET_STR(_location, @"location"); \
SET_STR(_email, @"email"); \
SET_STR(_hireable, @"hireable"); \
SET_STR(_bio, @"bio"); \
SET_NUM(_publicRepos, @"public_repos"); \
SET_NUM(_publicGists, @"public_gists"); \
SET_NUM(_followers, @"followers"); \
SET_NUM(_following, @"following");

- (instancetype)initWithJSONDictionary:(NSDictionary *)dic {
    self = [super init];
    if (![dic isKindOfClass:[NSDictionary class]]) return nil;
    
    NSString *str;
    NSNumber *num;
    
#define SET_STR(_IVAR_, _JSON_KEY_) \
    str = dic[_JSON_KEY_]; \
    if ([str isKindOfClass:[NSString class]]) _IVAR_ = str;
    
#define SET_NUM(_IVAR_, _JSON_KEY_) \
    num = dic[_JSON_KEY_]; \
    if ([num isKindOfClass:[NSNumber class]]) _IVAR_ = num.unsignedIntValue;
    
    GHUSER_MANUALLY_SETTER_LIST
    
#undef SET_STR
#undef SET_NUM
    return self;
}

- (NSDictionary *)convertToJSONDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
#define SET_STR(_IVAR_, _JSON_KEY_) \
    if (_IVAR_) dic[_JSON_KEY_] = _IVAR_;
    
#define SET_NUM(_IVAR_, _JSON_KEY_) \
    dic[_JSON_KEY_] = @(_IVAR_);
    
    GHUSER_MANUALLY_SETTER_LIST
    
#undef SET_STR
#undef SET_NUM
    return dic;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    if (!aCoder) return;
    
#define SET_STR(_IVAR_, _JSON_KEY_) \
    [aCoder encodeObject:_IVAR_ forKey:(__bridge NSString *)CFSTR(#_IVAR_)];
    
#define SET_NUM(_IVAR_, _JSON_KEY_) \
    [aCoder encodeObject:@(_IVAR_) forKey:(__bridge NSString *)CFSTR(#_IVAR_)];
    
    GHUSER_MANUALLY_SETTER_LIST
    
#undef SET_STR
#undef SET_NUM
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    if (!self) return nil;
    
#define SET_STR(_IVAR_, _JSON_KEY_) \
    _IVAR_ = [aDecoder decodeObjectForKey:(__bridge NSString *)CFSTR(#_IVAR_)];
    
#define SET_NUM(_IVAR_, _JSON_KEY_) \
    _IVAR_ = ((NSNumber *)[aDecoder decodeObjectForKey:(__bridge NSString *)CFSTR(#_IVAR_)]).unsignedIntValue;
    
    GHUSER_MANUALLY_SETTER_LIST
    
#undef SET_STR
#undef SET_NUM
    return self;
}

#undef GHUSER_MANUALLY_SETTER_LIST
@end





@implementation YYGHUser
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"userID" : @"id",
        @"avatarURL" : @"avatar_url",
        @"gravatarID" : @"gravatar_id",
        @"htmlURL" : @"html_url",
        @"followersURL" : @"followers_url",
        @"followingURL" : @"following_url",
        @"gistsURL" : @"gists_url",
        @"starredURL" : @"starred_url",
        @"subscriptionsURL" : @"subscriptions_url",
        @"organizationsURL" : @"organizations_url",
        @"reposURL" : @"repos_url",
        @"eventsURL" : @"events_url",
        @"receivedEventsURL" : @"received_events_url",
        @"siteAdmin" : @"site_admin",
        @"publicRepos" : @"public_repos",
        @"publicGists" : @"public_gists",
        @"createdAt" : @"created_at",
        @"updatedAt" : @"updated_at",
    };
}
- (void)encodeWithCoder:(NSCoder *)aCoder { [self yy_modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { return [self yy_modelInitWithCoder:aDecoder]; }
@end


