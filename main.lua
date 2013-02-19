MOAISim.openWindow ( "test", 1024, 768 )

local viewport = MOAIViewport.new ()
viewport:setSize ( 1024, 768 )
viewport:setScale ( 1024, 768 )

local layer = MOAILayer2D.new ()
layer:setViewport ( viewport )

local layers = {}
table.insert(layers, layer)
MOAIRenderMgr.setRenderTable(layers)

function onDraw ( index, xOff, yOff, xFlip, yFlip )
	MOAIGfxDevice.setPenColor(1, 0.64, 0, 1)
	MOAIDraw.fillCircle(-150,-150,50, 50)
end

local scriptDeck = MOAIScriptDeck.new ()
scriptDeck:setRect (-150,-150,50,-50)
scriptDeck:setDrawCallback ( onDraw )

local prop = MOAIProp2D.new ()
prop:setDeck ( scriptDeck )
layer:insertProp ( prop )

function drawBhole ( x,y )
	MOAIGfxDevice.setPenColor(1, 1, 1, 1)
	MOAIDraw.fillCircle(x,y,15, 50)
end

function handleMouse( down )
	if down then

		local x,y = MOAIInputMgr.device.pointer:getLoc()
		print("mouse " .. x .. " " .. y )

		local bholeDeck = MOAIScriptDeck.new ()
		bholeDeck:setRect (x, y, x + 10, y + 10)
		bholeDeck:setDrawCallback ( drawBhole )

		local bholeProp = MOAIProp2D.new ()
		bholeProp:setDeck ( bholeDeck )
		layer:insertProp ( bholeProp )
	end
end
MOAIInputMgr.device.mouseLeft:setCallback(handleMouse)

function handleKeyboard(key,down)
	if down==true then
		if key == 27 then -- 'escape' key
			os.exit()
		end
	end
end
MOAIInputMgr.device.keyboard:setCallback(handleKeyboard)
