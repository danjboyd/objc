#ifndef _MYSQLCONN_H_
#define _MYSQLCONN_H_

#include <Foundation/NSObject.h>
#include "Database.h"
#include <my_global.h>
#include <mysql.h>

@interface MySQLConn : NSObject <Database> {
    NSString * _host;
    NSString * _username;
    NSString * _password;
    NSString * _database;
    unsigned int _port;
    NSString * _unix_socket;
    MYSQL * conn;
}

-(id) initWithHost: (NSString*) host user: (NSString*) user password: (NSString*) password
        database: (NSString*) database port: (NSString *) port unix_socket: (NSString*) unix_socket;

-(BOOL) connect;
-(NSString*) error;
-(MYSQL*) mysql_conn;
-(id <Statement>) prepare:(NSString*) query;

@end

#endif /* _MYSQLCONN_H_ */
