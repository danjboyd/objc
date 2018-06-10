#include "PgStmt.h"
#include <Foundation/Foundation.h>
#include "PgConn.h"

@implementation PgStmt

-(id) initWithConn:(id) _conn query: (NSString*) _query
{
    self = [super init];
    if(self) {
        conn = _conn;
        query = _query;
    }
    return self;
}

-(NSString*) query
{
    return query;
}

-(BOOL) execute {
    res = PQexecParams([(PgConn *)conn pq_conn], 
                [query UTF8String],
                0,
                NULL,     //server auto-determines value types
                NULL,
                NULL,
                NULL,
                0         //result returned in text format (1 = binary format)
                );

    result_index = 0;
    if(PQresultStatus(res) == PGRES_TUPLES_OK) {
        num_rows = PQntuples(res);
        return YES;
    } else {
        return NO;
    }
}

-(BOOL) execute: (NSArray*) values
{
    num_params = [values count];
    const char * paramValues[num_params];
    for(int i = 0; i < num_params; i++) {
        id obj = [values objectAtIndex:i];
        if(![obj isKindOfClass:[NSString class]]) {
            if([obj respondsToSelector:@selector(stringValue)]) {
                obj = [obj stringValue];
            } else {
                NSLog(@"Error, parameter \"%@\" cannot be converted to a string.", obj);
                return NO;
            }
        }
        paramValues[i] = [obj UTF8String];
    }

    res = PQexecParams([(PgConn *)conn pq_conn], 
                [query UTF8String],
                num_params,
                NULL,     //server auto-determines value types
                paramValues,
                NULL,
                NULL,
                0         //result returned in text format (1 = binary format)
                );

    result_index = 0;
    if(PQresultStatus(res) == PGRES_TUPLES_OK) {
        num_rows = PQntuples(res);
        return YES;
    } else {
        return NO;
    }
}

-(NSDictionary*) fetchRow {
    if(PQresultStatus(res) != PGRES_TUPLES_OK) {
        return nil;
    }

    if(result_index >= num_rows || result_index < 0) {
        return nil;
    }

    int num_fields = PQnfields(res);

    NSMutableDictionary * row = [NSMutableDictionary dictionaryWithCapacity:num_fields];

    for(int i=0; i < num_fields; i++) {
        NSString * field_name = [NSString stringWithUTF8String:PQfname(res, i)];
        NSString * field_value = [NSString stringWithUTF8String:PQgetvalue(res, result_index, i)];
        [row setObject: field_value forKey: field_name];
    }

    result_index++;

    return row;
}

-(void) dealloc {
    PQclear(res);
    [super dealloc];
}

@end
