一.协议proto
1 各个ctrl调用RegisterProtocalCallback，注册协议回调事件
2 gamenet调用NetManager的RegisterProtocal注册协议，具体在msgHandler中的RegisterProtocal方法实行
2.1 msgHandler.h头文件定义了协议数据结构以及相应的属性
	数据结构：
	ProtoInfo-协议结构，包括协议号和协议字段列表
	FieldInfo-协议各字段信息，包括字段名、字段数据类型，如果是列表
	FieldInfoList-FieldInfo组成的list
	ProtocalInfoMap-ProtoInfo组成的无序索引表
	属性：
	MAX_MSG_LENGTH-最大消息长度
	_msgData，_msgLen，_writePos，_readPos
2.2 MsgHandler里面，ParseProtoField，ParseProtoList，ParseProtoItem方法，对lua传来的协议文件进行解析
	然后转化成ProtoInfo数据结构，存放到ProtocalInfoMap里面
