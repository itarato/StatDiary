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
#define STATDIARY_XMLRPC_GATEWAY @"http://l/statdiary/services/xmlrpc"
#endif

#ifdef LIVE_ENV
#define STATDIARY_XMLRPC_GATEWAY @"http://statdiary.info/services/xmlrpc"
#endif