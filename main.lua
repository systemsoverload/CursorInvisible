TARGET_SPAWN_DELAY = 5

spawnCounter = TARGET_SPAWN_DELAY
alive = true

windowHeight = 1024
windowWidth = 768
MOAISim.openWindow ( "test", windowHeight, windowWidth )

viewport = MOAIViewport.new ()
viewport:setSize ( windowHeight, windowWidth )
viewport:setScale ( windowHeight, windowWidth )

layer = MOAILayer2D.new ()
layer:setViewport ( viewport )

textLayer = MOAILayer2D.new ()
textLayer:setViewport ( viewport )

layers = {}
table.insert(layers, layer)
table.insert(layers, textLayer)
MOAIRenderMgr.setRenderTable(layers)

bholeGfx = MOAIGfxQuad2D.new ()
bholeGfx:setTexture ( "assets/images/bhole.png" )
bholeGfx:setRect ( -20, -20, 20, 20 )

targetGfx = MOAIGfxQuad2D.new ()
targetGfx:setTexture ( "assets/images/target.png" )
targetGfx:setRect ( -96, -96, 96, 96 )

font =  MOAIFont.new ()
font:loadFromTTF ("assets/arialbd.ttf", "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789,.?! ", 22, 163 )

textbox = MOAITextBox.new ()
textbox:setFont ( font )
textbox:setRect ( -160, -80, 160, 80 )
textbox:setLoc ( 0, 0 ) 
textbox:setAlignment ( MOAITextBox.CENTER_JUSTIFY )
textbox:setYFlip ( true )
textLayer:insertProp ( textbox )

local bholes = {}

function setState ( prop, state, ... )

	if prop then
		if prop.finish then
			prop:finish ()
			prop.finish = nil
		end
		state ( prop, ... )
	end
end

function targetState ( prop, x, y )

	if alive == true then
		prop:setDeck ( targetGfx )
		prop:setLoc ( x, y )
		prop.state = targetState
		layer:insertProp ( prop )
	end

	bholes[prop] = true

	function prop:finish ()
		--Placeholder
	end
	
	function prop:main ()
		--Placeholder
	end
end

function handleMouse( down )
	if down then
		local x,y = MOAIInputMgr.device.pointer:getLoc()
		x, y = layer:wndToWorld ( x, y )
		alive = false
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

function main ()
	--Main game loop
	while alive == true do
		
		--Generate new randomly placed target 
		setState ( 
			MOAIProp2D.new()
			, targetState
			, math.random( 
				((windowWidth/2) - 96) * -1
				,((windowWidth/2) - 96)
			)
			, math.random( 
				((windowHeight/2) -96) * -1
				, (windowHeight / 2) - 96 
			)
		)

		--Throttle thread so you dont create a million targets
		for i = 1, 90 do
			spawnCounter = spawnCounter + 1
			coroutine.yield ()
		end
	end

	while alive == false do
		textbox:setString ( "Game Over" )
		textbox:spool ()
		alive = nil
	end
end

spawnThread = MOAIThread.new ()
spawnThread:run ( main )