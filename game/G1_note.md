琐碎注意事项：
1 高低位表示：玩家id，帮派id，经验等等可能很大超过2^32次方(应该是后端4字节保存数据)，用高低位表示，num=high*2^32+low