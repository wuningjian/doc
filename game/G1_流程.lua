=====================C++ 逻辑=====================
1 AppDelegate启动游戏，状态切换GameState::INIT

2 GameState::INIT状态：
2.1 NetManager初始化(待扩展)
2.2 CspriteManager初始化(待扩展)
2.3 场景初始化
2.3 等待ditchid，等待资源初始化完成
2.4 game mode==dev 就输入IP，否则就进入 2.5
2.5 跳转SHOW_LOGO状态

3 GameState::SHOW_LOGO状态:
3.1 播放logo list里面的图片
3.2 跳转GET_SERVER_CONFIG状态

4 GameState::GET_SERVER_CONFIG状态
4.1 初始化loadingview 资源，app版本信息展示
4.2 发送http请求，获取服务器列表
4.3 获取成功则把列表存入config里面，获取不成功则问玩家是否重新请求，返回 4.2（update循环）
4.4 初始化所有资源-跳转INIT_RES状态 检查比对资源-CHECK_RES状态

5 GameState::INIT_RES状态
5.1 创建新的初始化资源线程，资源解压，解密，保存写入(sql操作)
5.2 解压加载完了就跳转去CHECK_RES状态

6 GameState::CHECK_RES状态
6.1 请求版本信息
6.2 获取成功版本有效就就跳转UPDATE_RES状态，否则跳转LOAD_RES状态

7 GameState::UPDATE_RES状态
7.1 请求文件列表
7.2 对比文件列表中新旧文件md5，不相同则加入下载线程，后台下载
7.3 全部处理完文件列表，玩家同意下载则跳转LOAD_RES状态，不同意就退出游戏

8 GameState::LOAD_RES状态
8.1 初始化Lua引擎
8.2 注册C++ to Lua所有基本模块
8.3 把main.lua压入lua引擎的堆栈中方便调用
8.4 更新LoadingView的加载进度条
8.5 Update执行main.lua的PreLoad方法加载(require)config，proto，ctrl，通用资源，创角资源
8.6 完成加载，跳转PLAY_GAME状态
8.7 执行Lua垃圾回收

9 GameState::PLAY_GAME状态
9.1 停止垃圾回收
9.2 执行main.lua的Start(RenderUnit创建场景，所有ctrl.New，gameLoop/gameNet.Start)
9.3 更新状态时执行main.lua的Update方法
9.4 至此开始，游戏主要逻辑由lua接管

附：
状态管理：
GameStateMgr统筹状态代理
GameStateMgr在AppDelegate里添加进scheduleUpdate队列
主要代理ChangeState(状态切换)、update(状态更新)、QuitCurState(退出状态)

=====================Lua 逻辑====================
1 main.lua->Start() Update()
2 RenderUnit创建主场景，设置场景层，UI层，飘字层等
3 初始化所有ctrl
4 GameLoop开始-各种状态切换（各个状态详细看GameLoop->init()）
5 GameNet 注册所有协议（详见网络连接）

GamePlay
1.登录成功GameLoop进入login_success状态，然后请求人物数据(包括场景和位置)
2.GameLoop进入loading状态，根据人物数据开始初始化场景
2.1.scene执行LoadScene方法，开始加载地图
