# Custom Plates

This Script Utilizes:


1: [QBOX](https://github.com/Qbox-project) / [QBCore](https://github.com/qbcore-framework)


2: [ox_lib](https://github.com/overextended/ox_lib)

[Preview](https://youtu.be/hXGn1nmWppI)

## Join Our [Discord](https://discord.gg/xhdtB2JvbT) For More Info!

## If Using qb-inventory install this in qb-core/shared/items.lua

```
['newplate'] = {
    name = 'newplate',
    label = 'Custom Plate',
    weight = 200,
    type = 'item',
    image = 'plate.png',
    unique = false,
    useable = true,
    shouldClose = true,
    combinable = nil,
    description = 'Choose Your Own Number Plate'
},
```
## If Using ox-inventory then install this in ox_inventory/data/items.lua

```
	["newplate"] = {
		label = "Custom Plate",
		weight = 200,
		stack = true,
		close = true,
		description = "Choose Your Own Number Plate",
		client = {
			image = "plate.png",
		}
	},
```

## Now Install The Image Into your images directory 
