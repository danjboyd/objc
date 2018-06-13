#include "MySQLConn.h"

const char * maybe_utf8_string(NSString * str) {
    if (str == nil)
        return NULL;
    return [str UTF8String];
}

@implementation MySQLConn

-(id) initWithHost: (NSString*) host user: (NSString*) user password: (NSString*) password
        database: (NSString*) database port: (NSString *) port unix_socket: (NSString*) unix_socket;
{
    self = [super init];
    if(self) {
        _host = host;
        _username = user;
        _password = password;
        _database = database;
        _port = port == nil ? 0 : [port intValue];
        _unix_socket = unix_socket;
    }

    return self;
}

-(BOOL) connect {
    //NSLog(@"MySQL client version: %s", mysql_get_client_info());

    //NSLog(@"%@, %@, %@, %@, %d, %@", _host, _username, _password, _database, _port, _unix_socket);

    conn = mysql_init(NULL);

    if(conn == NULL) {
        [NSException raise: @"Unable to initialize MySQL connection object." format: @"%s", [self error]];
        return NO;
    }

    if(mysql_real_connect(conn, maybe_utf8_string(_host),
                maybe_utf8_string(_username),
                maybe_utf8_string(_password),
                maybe_utf8_string(_database),
                _port,
                maybe_utf8_string(_unix_socket),
                0) == NULL)
    {
        [NSException raise: @"Unable to connect to MySQL server." format: @"%@", [self error]];
        mysql_close(conn);
        return NO;
    }
    return YES;
}

-(MYSQL*) mysql_conn {
    return conn;
}

-(void) dealloc {
    mysql_close(conn);
    [super dealloc];
}

-(NSString*) error {
    return [NSString stringWithUTF8String: mysql_error(conn)];
}

-(id <Statement>) prepare:(NSString*) query {
    return AUTORELEASE ( [[MySQLStmt alloc] initWithConn: self query: query] );
}



@end
