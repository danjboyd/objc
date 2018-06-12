#include "DatabaseFactory.h"
#include "DbTemplates.h"
#include "PgConn.h"
#include "MySQLConn.h"

@implementation DatabaseFactory

+(id <Database>) databaseWithTemplateName: (NSString*) templateName {
    DbTemplates * dbt = [[DbTemplates alloc] initWithConfigFileName: @"dbtemplates"];
    NSDictionary * templates = [dbt defsForKeyword: @"template"];
    [dbt release];
    NSDictionary * template = [templates objectForKey: templateName];
    if(template == nil) {
        [NSException raise:@"Template does not exist." format:@"Template \"%@\" does not exist.", templateName];
        return nil;
    }
    return [DatabaseFactory databaseWithTemplate: template];
}

+(id <Database>) databaseWithTemplate:(NSDictionary*) template {
    NSString * dsn = [template objectForKey:@"dsn"];
    if(dsn == nil) {
        NSLog(@"Error: dsn is nil");
        return nil;
    }

    //check to see if they've explicitly set a server type
    NSString * dbtype = [template objectForKey:@"dbtype"];
    #pragma GCC diagnostic ignored "-Wmaybe-uninitialized"
    id <Database> conn;
    if(dbtype == nil) {
        //determine dbtype from dsn
        if([dsn rangeOfString: @"sybase" options: NSCaseInsensitiveSearch].location != NSNotFound ||
               [dsn rangeOfString: @"odbc" options: NSCaseInsensitiveSearch].location != NSNotFound)
        {
            [NSException raise:@"Not Implemented" format:@"SQL Server (FreeTDS) not yet implemented."];
            return nil;
        }
        if([dsn rangeOfString: @"mysql" options: NSCaseInsensitiveSearch].location != NSNotFound)
        {
            dsn = [dsn stringByReplacingOccurrencesOfString: @"dbi:mysql:" 
                                                 withString: @"" 
                                                    options: NSCaseInsensitiveSearch
                                                      range: NSMakeRange(0, [dsn length])];
            //grab parameters from dsn
            NSArray * paramArray = [dsn splitWithRegex: @"\\s*;\\s*"];
            NSMutableDictionary * params = [NSMutableDictionary dictionaryWithCapacity: [paramArray count]];
            for(NSString * param in paramArray) {
                NSArray * components = [param splitWithRegex: @"\\s*=\\s*"];
                if([components count] == 2)
                    [params setObject: [components objectAtIndex: 1]
                               forKey: [components objectAtIndex: 0]];
            }

            conn = [[MySQLConn alloc] initWithHost: [params objectForKey: @"host"]
                                              user: [template objectForKey: @"user"]
                                          password: [template objectForKey: @"pass"]
                                          database: [params objectForKey: @"database"]
                                              port: [params objectForKey: @"port"]
                                       unix_socket: [params objectForKey: @"mysql_socket"]];
        }
        if([dsn rangeOfString: @"dbi:pg" options: NSCaseInsensitiveSearch].location != NSNotFound)
        {
            //postgresql -- convert to libpq dsn
            dsn = [dsn stringByReplacingOccurrencesOfString: @"dbi:pg:" 
                                                 withString: @"" 
                                                    options: NSCaseInsensitiveSearch
                                                      range: NSMakeRange(0, [dsn length])];
            //libpq separates arguments with spaces
            dsn = [dsn stringByReplacingOccurrencesOfString: @";" 
                                                 withString: @" "];
            conn = [[PgConn alloc] initWithDsn: dsn
                                      username: [template objectForKey: @"user"]
                                      password: [template objectForKey: @"pass"]];

        }
    }
    if(conn == nil) {
        [NSException raise:@"Unknown DB Type" format:@"Unable to determine dbtype."];
        return nil;
    } else if([conn connect]) {
        return conn;
    } else {
        [NSException raise: @"Database Connection Failed"
                    format: @"%@", [conn error]];
        [conn release];
        return nil;
    }
    #pragma GCC diagnostic pop
}

@end
