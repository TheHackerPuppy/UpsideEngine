# [Extended from EventEmitter](EventEmitter.md) NetworkingService 
This class is to replicate objects to other clients, for example the player character
	 
# Properties

## [table](table.md) Players 
A dictionary with the replicated objects by the clients
		 
```lua
{ }
```
## [boolean](boolean.md) DestroyObjectsOnLeave
Defines if the replicated objects by other clients should be destroyed when they leaves
	


# Methods

## [NetworkingService](NetworkingService.md) Constructor() 
 
## [void](void.md) Replicate(`object: BaseObject`) 
 Replicates an object to other clients

## [RBXScriptConnection](Connection.md	) ReplicateOnChange(`object: BaseObject`) 
 Replicates an object and each change on it, and returns the connections that detect each change of the object
	

# Events
|<div style="width:20%; max-size: 20%">Name</div>|<div style="width:80%; max-size: 80%">Description</div>|
|---|---|
|ReplicationRequest|Params -> [Request](Request.md) <br>Fired when a request is received by the client<br>|


