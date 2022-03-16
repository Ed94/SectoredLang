

#define bit(_pos)	1 << _pos

enum SomeFlagDefs_BAD
{
	BFlag_1 = 0;
	// ...
};


enum SomeFlagDefs
{
	flag_1 = bit(0);
	flag_2 = bit(1);
	flag_3 = bit(2);
	flag_4 = bit(3);
	flag_5 = bit(4);
};


bit(BFlag_1);
flag_1

// inline Bit_MakeMask(int Flag)
// {
// 	return 
// }

typedef u32		
Bitfield;


inline Bit_IsSet(BitField field, BitField mask)
{
	return field & mask == mask;
}

#define Bit_IsSet(_FIELD, _MASK)	(_FIELD & _MASK == mask)
