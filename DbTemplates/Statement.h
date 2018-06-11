#ifndef _STATEMENT_H_
#define _STATEMENT_H_

#include <Foundation/Foundation.h>

@protocol Statement

-(id) initWithConn:(id) _conn query: (NSString*) query;
-(BOOL) execute: (NSArray*) values;
-(BOOL) execute;
-(NSDictionary*) fetchRow;

@end 


#endif /* _STATEMENT_H_ */
