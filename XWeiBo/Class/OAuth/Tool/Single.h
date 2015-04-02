//.h
#define single_interface(class) + (class *)shared##class;

// .m
#define  single_implementation(class) \
static class *_instance;\
\
+ (class *)shared##class\
\
{\
    if (_instance == nil) {\
        _instance = [[self alloc]init];\
    }\
    return  _instance;\
}\
\
+ (id)allocWithZone:(struct _NSZone *)zone\
{\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        _instance = [super allocWithZone:zone];\
    });\
    return _instance;\
}