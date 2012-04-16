/*
 *  Defines.h
 *  StatDiary
 *
 *  Created by Peter Arato on 6/9/11.
 *  Copyright 2011 Pronovix. All rights reserved.
 *
 */


#define DEV_ENV
//#define LIVE_ENV

#ifdef DEV_ENV
#define STATDIARY_XMLRPC_GATEWAY @"http://192.168.1.26/statdiary/services/xmlrpc"
#define STATDIARY_XMLRPC_BASEPATH @"http://192.168.1.26/statdiary/"
#endif

#ifdef LIVE_ENV
#define STATDIARY_XMLRPC_GATEWAY @"http://statdiary.info/services/xmlrpc"
#define STATDIARY_XMLRPC_BASEPATH @"http://statdiary.info/"
#endif

// Dictionary keys for account details.
#define LOGGED_IN_USERNAME @"keepMeLoggedInUserName"
#define LOGGED_IN_PASSWORD @"keepMeLoggedInPassword"
