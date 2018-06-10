#include <stdio.h>
#include <Foundation/Foundation.h>
#include <stdlib.h>
#include <libpq-fe.h>
#include "PgConn.h"
#include "PgStmt.h"
#include "DbTemplates.h"

int main() {
    NSAutoreleasePool * pool = [NSAutoreleasePool new];

    DbTemplates * t = [[DbTemplates alloc] initWithConfigFileName: @"dbtemplates"];

    NSDictionary * templates = [t defsForKeyword:@"template"];
    NSLog(@"%@", templates);

    [t release];

    [pool drain];
}

int main2() {
    NSAutoreleasePool * pool = [NSAutoreleasePool new];

    PgConn * pg = [[PgConn alloc] initWithDsn:@"host=localhost dbname=wrd_postgis"
                                     username:@"danboyd"
                                     password:nil];

    if([pg connect]) {
        printf("YES!\n");
    } else {
        NSLog(@"Connection Unsuccessful: %@", [pg error]);
    }

    PgStmt * stmt = [pg prepare: @"SELECT unitname FROM public.\"BurlesonUnitPlan\" WHERE formation = $1"];

    if([stmt execute: [NSArray arrayWithObjects: @"Eagle Ford", nil]]) {
        NSDictionary * row;
        while((row = [stmt fetchRow]) != nil) {
            NSLog(@"%@", row);
        }
    } else {
        NSLog(@"%@", [pg error]);
    }

    [stmt release];
    [pg release];

    [pool drain];
    return 1;
}

//PGconn * conn = NULL;
//PGresult * res = NULL;
//
//
//void terminate(int code) {
//    if(code != 0)
//        fprintf(stderr, "%s\n", PQerrorMessage(conn));
//
//    if(res != NULL)
//        PQclear(res);
//
//    if(conn != NULL)
//        PQfinish(conn);
//
//    exit(code);
//}
//
//int main () {
//    NSAutoreleasePool * pool;
//    pool = [NSAutoreleasePool new];
//
//    NSLog(@"Hello World!");
//    int libpq_ver = PQlibVersion();
//
//    printf("Version of libpq: %d\n", libpq_ver);
//
//    conn = PQconnectdb("user=danboyd host=127.0.0.1 dbname=wrd_postgis");
//    if(PQstatus(conn) != CONNECTION_OK)
//        terminate(1);
//
//
//
//    PQfinish(conn);
//
//
//    RELEASE(pool);
//    return 0;
//
//}
