include "MySQLStmt.h"


-(id) initWithConn:(id) _conn query: (NSString*) _query {
    self = [super init];
    if(self) {
        conn = _conn;
        query = [_query retain];
    }
    return self;}

-(BOOL) execute: (NSArray*) values {
    
}

-(BOOL) execute {
    if(mysql_query([conn mysql_conn], [_query UTF8String])) {
        //if this returns true, then an error occurred
        [NSException raise: @"MySQL Error" format: @"%@", [conn error]];
        return NO;
    }
    res = mysql_store_result([conn mysql_conn]);
    if(!res) {
        [NSException raise: @"MySQL couldn't get results set." format: @"%@", [conn error]];
        return NO;
    }

    return YES;

}

-(NSDictionary*) fetchRow {

}

