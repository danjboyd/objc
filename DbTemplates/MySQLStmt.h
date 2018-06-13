#ifndef _MYSQLSTMT_H_
#define _MYSQLSTMT_H_

#include <Foundation/NSObject.h>
#include <my_global.h>
#include <mysql.h>
#include "Statement.h"

@class MySQLConn;

@interface MySQLStmt : NSObject <Statement> {
    MySQLConn * conn;
    NSString * query;
    unsigned int result_index;
    unsigned int num_params;
    unsigned int num_rows;
    MYSQL_RES * res;
}

-(id) initWithConn:(id) _conn query: (NSString*) _query;
-(BOOL) execute: (NSArray*) values;
-(BOOL) execute;
-(NSDictionary*) fetchRow;

@end
#endif /* _MYSQLSTMT_H_ */
