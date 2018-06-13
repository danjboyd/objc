#include "PgConn.h"
#include <Foundation/Foundation.h>
#include "PgStmt.h"

@implementation PgConn

-(id) initWithDsn:(NSString*) _dsn username: (NSString*) _username password: (NSString*) _password
{
    self = [super init];
    if(self) {
        dsn = [_dsn retain];
        username = [_username retain];
        password = [_password retain];
    }

    return self;
}

-(BOOL) connect
{
   NSMutableString * connectString = [NSMutableString string];
   [connectString appendString: dsn];
   if(username != nil) {
       [connectString appendFormat:@" user=%@", username];
   }
   if(password != nil) {
       [connectString appendFormat:@" password=%@", username];
   }
   //NSLog(@"%@", connectString);

   conn = PQconnectdb([connectString UTF8String]);

   return PQstatus(conn) == CONNECTION_OK;
}

-(NSString*) error
{
    return [NSString stringWithUTF8String: PQerrorMessage(conn)];
}

-(void) dealloc {
    PQfinish(conn);
    [dsn release];
    [username release];
    [password release];
    [super dealloc];
}

-(PGconn*) pq_conn {
    return conn;
}

-(id <Statement>) prepare:(NSString*) query {
    return AUTORELEASE( [[PgStmt alloc] initWithConn: self query: query] );
}

@end
