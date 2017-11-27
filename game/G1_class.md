UI界面相关

展示模型相关

战斗场景模型相关

战斗逻辑相关

系统相关

游戏对象基类
http://blog.csdn.net/wuming2016/article/details/60774896   -- 对象管理
http://blog.csdn.net/mooke/article/details/8882073		   -- 对象系统设计
http://blog.csdn.net/zhanghefu/article/details/25833535    -- aoi算法
obj
元素：
1.挂载场景
2.高度，世界坐标，相对坐标
3.方向（4/8方向）
4.模型可见
5.半透明状态
6.引擎相关的节点(cc.Node)
7.附加精灵（选中框，阴影，物品头上感叹号等等）
初始化操作:
1.初始化元素
2.创建节点
3.添加到渲染管理器中
主要方法：
1.获取根节点
2.获取对象类型（npc，主角，道具等等）
3.获取对象类型
4.帧更新
5.更新状态机
6.更新aoi
7.获取/更新位置，坐标，高度等等
8.添加动画
9.注册aoi watch，obj
10.监听aoi进入，离开对象

