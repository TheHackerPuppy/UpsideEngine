-- THIS IS AN AUTOGENERATED FILE. DO NOT EDIT THIS FILE DIRECTLY.
export type table = {}
export type Dictionary<k, v> = {}
export type Array<v> = {}
export type ChromaticAberrationConnection = {}

export type Raycast2dResult = {
	Object: PhysicalObject,
	Position: UDim2,
	Distance: Vector2,
	Normal: UDim2,
}

export type Raycast2dParams = {
	FilterType: string,
	From: Vector2,
	List: Array<BaseObject>,
	To: any,
}

export type ClassData = {
	name: string,
	constructor: Dictionary<string, () -> any>,
	methods: Dictionary<string, () -> any>,
	private: Dictionary<string, any>,
	readonly: Dictionary<string, any>,
	rules: Dictionary<string, any>,
}

export type BaseClass = {
	Id: string,
	ClassName: string,
	Name: string,
	SetName: (name: string) -> (),
	IsA: (self: BaseClass, className: string) -> boolean,
	new: (...any) -> BaseClass,
	Clone: (...any) -> BaseClass,
	Extend: (self: BaseClass, className: string, classStructure: table) -> BaseClass,
	Destroy: () -> (),
}
