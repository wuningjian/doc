1 AppDelegate启动游戏，状态切换GameState::INIT

2 GameState::INIT状态：
2.1 NetManager初始化(待扩展)
2.2 CspriteManager初始化(带扩展)
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
5.1 

状态管理：
GameStateMgr统筹状态代理
主要代理ChangeState(状态切换)、update(状态更新)、QuitCurState(退出状态)