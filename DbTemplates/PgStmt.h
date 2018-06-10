#ifndef _PGSTMT_H_
#define _PGSTMT_H_

#include <Foundation/NSObject.h>
#include <libpq-fe.h>

@interface PgStmt : NSObject {
    id conn;
    NSString * query;
    PGresult * res;
    int result_index;
    int num_params;
    int num_rows;
}

-(id) initWithConn:(id) _conn query: (NSString*) _query;
-(BOOL) execute: (NSArray*) values;
-(BOOL) execute;
-(NSDictionary*) fetchRow;

@end
#endif /* _PGSTMT_H_ */
