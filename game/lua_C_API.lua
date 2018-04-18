-- tolua++
tolua++库是一个专门处理LUA脚本的第三方库，可以很好的完成LUA访问C++类及成员函数的功能

在讲代码之前，我要说Lua的一些特点，这些特点有利于你在复杂的代码调用中，清晰的掌握中间的来龙去脉。
实际上，你能常常用到的lua的API，不过超过10个，再复杂的逻辑。
基本上也是这么多API组成的。至于它们是什么，下面的文章会介绍。
另外一个重要之重要的概念，就是栈。
Lua与别的语言交互以及交换数据，是通过栈完成的。
其实简单的解释一下，你可以把栈想象成一个箱子，你要给他数据，就要按顺序一个个的把数据放进去，
当然，Lua执行完毕，可能会有结果返回给你，那么Lua还会利用你的箱子，一个个的继续放下去。
而你取出返回数据呢，要从箱子顶上取出，如果你想要获得你的输入参数呢？
那也很简单，按照顶上返回数据的个数，再按顺序一个个的取出，就行了。
不过这里提醒大家，关于栈的位置，永远是相对的，比如-1代表的是当前栈顶，-2代表的是当前栈顶下一个数据的位置。
栈是数据交换的地方，一定要有一些栈的概念。

lua调用C++方法时，会向栈依次压入usedata，参数1，参数2... 
在c++里面响应该次调用，应该先 
1判断usedata是否符合对应model -- tolua_isusertype(tolua_S, 1, "cc.NetManager", 0, &tolua_err))
2从usedata拿回对应的c++模块   -- cobj = (NetManager*)tolua_tousertype(tolua_S, 1, 0);
3向c++模块传入栈里面的参数1，参数2等等
4向栈返回true or false告知lua返回结果(或者压入其他数据告知返回结果string, int等等)

-- lua用到的 C API
lua_State
typedef struct lua_State lua_State;
一个不透明的结构，它保存了整个 Lua 解释器的状态。 
Lua 库是完全可重入的： 它没有任何全局变量。 
（译注：从 C 语法上来说，也不尽然。例如，在 table 的实现中 用了一个静态全局变量 dummynode_ ，但这在正确使用时并不影响可重入性。 
只是万一你错误链接了 lua 库，不小心在同一进程空间中存在两份 lua 库实现的代码的话， 多份 dummynode_ 不同的地址会导致一些问题。） 
所有的信息都保存在这个结构中。
这个状态机的指针必须作为第一个参数传递给每一个库函数。 lua_newstate 是一个例外， 这个函数会从头创建一个 Lua 状态机。

lua_getglobal
void lua_getglobal (lua_State *L, const char *name);
把全局变量 name 里的值压入堆栈。

lua_istable
int lua_istable (lua_State *L, int index);
当给定索引的值是一个 table 时，返回 1 ，否则返回 0 。

lua_pop
void lua_pop (lua_State *L, int n);
从堆栈中弹出 n 个元素。

lua_gettop
int lua_gettop (lua_State *L);
返回栈顶元素的索引。 因为索引是从 1 开始编号的，所以这个结果等于堆栈上的元素个数（因此返回 0 表示堆栈为空）。

lua_getmetatable
int lua_getmetatable (lua_State *L, int index);
把给定索引指向的值的元表压入堆栈。 如果索引无效，或是这个值没有元表， 函数将返回 0 并且不会向栈上压任何东西。

lua_isnil
int lua_isnil (lua_State *L, int index);
当给定索引的值是 nil 时，返回 1 ，否则返回 0 。

lua_newuserdata
void *lua_newuserdata (lua_State *L, size_t size);
这个函数分配分配一块指定大小的内存块， 把内存块地址作为一个完整的 userdata 压入堆栈，并返回这个地址。
userdata 代表 Lua 中的 C 值。 完整的 userdata 代表一块内存。 
它是一个对象（就像 table 那样的对象）： 你必须创建它，它有着自己的元表，而且它在被回收时，可以被监测到。 
一个完整的 userdata 只和它自己相等（在等于的原生作用下）。
当 Lua 通过 gc 元方法回收一个完整的 userdata 时， Lua 调用这个元方法并把 userdata 标记为已终止。 
等到这个 userdata 再次被收集的时候，Lua 会释放掉相关的内存。

lua_settable
void lua_settable (lua_State *L, int index);
作一个等价于 t[k] = v 的操作， 这里 t 是一个给定有效索引 index 处的值， v 指栈顶的值， 而 k 是栈顶之下的那个值。
这个函数会把键和值都从堆栈中弹出。 和在 Lua 中一样，这个函数可能触发 "newindex" 事件的元方法 （参见 §2.8）。

lua_rawset
void lua_rawset (lua_State *L, int index);
类似于 lua_settable， 但是是作一个直接赋值（不触发元方法）。

luaL_getmetatable
int luaL_getmetatable (lua_State *L, const char *tname);
Pushes onto the stack the metatable associated with name tname in the registry (see luaL_newmetatable) (nil if there is no metatable associated with that name). 
Returns the type of the pushed value.

lua_rawget
void lua_rawget (lua_State *L, int index);
类似于 lua_gettable， 但是作一次直接访问（不触发元方法）。

lua_gettable
void lua_gettable (lua_State *L, int index);
把 t[k] 值压入堆栈， 这里的 t 是指有效索引 index 指向的值， 而 k 则是栈顶放的值。
这个函数会弹出堆栈上的 key （把结果放在栈上相同位置）。 在 Lua 中，这个函数可能触发对应 "index" 事件的元方法 （参见 §2.8）。

lua_pushlightuserdata
void lua_pushlightuserdata (lua_State *L, void *p);
把一个 light userdata 压栈。
userdata 在 Lua 中表示一个 C 值。 light userdata 表示一个指针。 
它是一个像数字一样的值： 你不需要专门创建它，它也没有独立的 metatable ， 而且也不会被收集（因为从来不需要创建）。 
只要表示的 C 地址相同，两个 light userdata 就相等。

lua_touserdata
void *lua_touserdata (lua_State *L, int index);
如果给定索引处的值是一个完整的 userdata ，函数返回内存块的地址。 
如果值是一个 light userdata ，那么就返回它表示的指针。 否则，返回 NULL 。