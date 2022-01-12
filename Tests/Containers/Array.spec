DArray
{
	tt AllocatorArg proc exe : if AllocatorType == undefined { macro : Allocator; };

	GrowFormula exe:
		// ret +(8, *(2, x))
		ret 
		2 * _capacity + 8;
	;

	Init exe InitReserve(self, GrowFormula(0), AllocatorArg);

	InitCopy :
		stack : other : _other.GetHeader();

		tt if AllocatorType == undefined : 
			macro Allocator { other->Allocator }
		;

		InitReserve(self, other->Capacity, Allocator);

		Format.WithData(self.Data, other->Data, other->Length);

		self.Length = other->Length;
	;

	InitReserve
	{
		tt if AllocatorType == undefined :
		heap : allocator = _Allocator;
		;
		
		DA_ptr type : ptr word;
		
		stack : 
		rPtr   : ptr DA_ptr;
		header : ptr Header;
		;
		
		exe :
			rPtr   = cast<ptr DA_ptr>(_self)
			header = heap.allocate Header;

			header.Capacity = _capacity;
			header.Data     = heap.allocate [Capacity] _Type;
			header.Length   = 0;

			rPtr.val = cast <DA_ptr>(posof(header.Length));
		;
	}

	Append(_obj : Type)
	{
		stack header : ptr Header = _self.GetHeader();

		if header->Capacity < (header->Count + 1) : 
			_self.Grow();

		_self.Data[_self.Count] = _obj;
		_self.Count++;
	}

	GetHeader exe 
	ret cast<ptr Header>(
		offsetof(_self.Length) - offsetof(Header.Capacity)
	);

	AppendAt(_obj : Type, _index : uw)
	{

	}

	Append(_objs : [] Type, _amount : uw)
	{

	}

	AppendAt(_objs : [] Type, _amount : uw, _index : uw)
	{

	}

	Free
	{
		stack header : ptr Header = GetHeader(_self);

		exe :
			heap.deallocate header;
		;
	}

	Grow :

	;

	SetCapacity :

	;
}
