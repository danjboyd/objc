include $(GNUSTEP_MAKEFILES)/common.make

ADDITIONAL_TOOL_LIBS = -lpq
ADDITIONAL_FLAGS += -std=gnu99


TOOL_NAME = Test
Test_LIB_DIRS = -L/usr/lib/x86_64-linux-gnu
Test_INCLUDE_DIRS = -I/usr/include/postgresql
Test_HEADERS = PgConn.h PgStmt.h DbTemplates.h
Test_OBJC_FILES = test.m PgConn.m PgStmt.m DbTemplates.m

include $(GNUSTEP_MAKEFILES)/tool.make


