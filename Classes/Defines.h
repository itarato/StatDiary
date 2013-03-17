/*
 *  Defines.h
 *  StatDiary
 *
 *  Created by Peter Arato on 6/9/11.
 *  Copyright 2011 Pronovix. All rights reserved.
 *
 */

// Production killswitch.
#define IS_LIVE 1
#define IS_LOG 0

#if IS_LIVE
    // Live production settings.
    #define STATDIARY_XMLRPC_BASEPATH @"http://statdiary.info/"
#else
    // Development settings.
    #define STATDIARY_XMLRPC_BASEPATH @"http://192.168.0.14/sd7/"
#endif

#if IS_LOG
    // Logging.
    #define STATLOG(...) NSLog(__VA_ARGS__)
    #define STAT_REQUEST_LOG(req, resp, func) NSLog(@"\nRequest: %@\nResponse: %@\nIs failed: %@\nFrom: %s\n", [req method], [resp object], ([resp isFault] ? @"yes" : @"no"), func)
    #define STAT_REQUEST_LOG_EROR(req, err, func) NSLog(@"\nRequest error!\nRequest: %@\nError: %@\nFrom: %s\n", [req method], err, func)
#else
    // Not to log.
    #define STATLOG(...)
    #define STAT_REQUEST_LOG(req, resp, func)
    #define STAT_REQUEST_LOG_EROR(req, err, func)
#endif

#define STATDIARY_XMLRPC_GATEWAY STATDIARY_XMLRPC_BASEPATH "/services/xmlrpc"

// Dictionary keys for account details.
#define LOGGED_IN_USERNAME @"keepMeLoggedInUserName"
#define LOGGED_IN_PASSWORD @"keepMeLoggedInPassword"
