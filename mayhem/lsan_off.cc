// Leaks are not the bug class this port fuzzes for; disabled at build time (docs/rules/c.md).
extern "C" int __lsan_is_turned_off() { return 1; }
