#ifndef _PGCONN_H_
#define _PGCONN_H_

#include <Foundation/NSObject.h>
#include <libpq-fe.h>
//#include "PgStmt.h"
#include "Database.h"
#include "Statement.h"

@class Statement;

@interface PgConn : NSObject <Database> {
    NSString * dsn;
    NSString * username;
    NSString * password;
    PGconn * conn;
}

-(id) initWithDsn:(NSString*) _dsn username: (NSString*) _username password: (NSString*) _password;
-(BOOL) connect;
-(NSString*) error;
-(PGconn*) pq_conn;
-(Statement*) prepare:(NSString*) query;

@end

#endif /* _PGCONN_H_ */
