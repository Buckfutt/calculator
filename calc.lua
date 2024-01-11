addon.name      = 'calc';
addon.author    = 'K0D3R';
addon.version   = '1.0';
addon.desc      = 'Displays an in-game calculator';

require('common');
local imgui = require('imgui');
local chat = require('chat');

local calculator = T{
	is_open = { true, },
	display = { "" },
};

function calculate()
	local func, err = load("return " .. calculator.display[1])
	if func then
		local success, result = pcall(func)
		if success then
			calculator.display[1] = tostring(result)
		else
			calculator.display[1] = "Error: " .. result
		end
	else
		calculator.display[1] = "Error: " .. err
	end
end

ashita.events.register('command', 'command_cb', function (e)
    -- Parse the command arguments..
    local args = e.command:args();
    if (#args == 0 or not args[1]:any('/calc')) then
        return;
    end

	if (#args >= 2 and args[2]:any('help') or #args == 1) then
        print(chat.header(addon.name):append(chat.message('/calc <expression>')));
        return;
    end

	calculator.display[1] = table.concat(args, "", 2);
	calculate()
	print(chat.header(addon.name):append(chat.message(calculator.display[1])))
end);

ashita.events.register('d3d_present', 'present_cb', function ()
    imgui.SetNextWindowBgAlpha(0.8);
    imgui.SetNextWindowSize({ 164, -1, }, ImGuiCond_Always);
	if (imgui.Begin('Calculator', calculator.is_open, bit.bor(ImGuiWindowFlags_AlwaysAutoResize, ImGuiWindowFlags_NoSavedSettings, ImGuiWindowFlags_NoFocusOnAppearing, ImGuiWindowFlags_NoNav))) then
		
		--Text Area--
		imgui.SetCursorPos({15,35})
		local displayText = calculator.display[1]:sub(1, 19) -- Limit to 19 characters
		imgui.Text(displayText)
		
		--Function Buttons--
		imgui.SetCursorPos{13,64}
		if imgui.Button("CE", { 66, 30 }) then
			calculator.display[1] = ""
		end
		
		imgui.SetCursorPos({85,64})
		if imgui.Button("<", { 30, 30 }) then
			calculator.display[1] = calculator.display[1]:sub(1, -2)
		end
		
		imgui.SetCursorPos({121,64})
		if imgui.Button("/", { 30, 30 }) then
			calculator.display[1] = calculator.display[1] .. "/"
		end
		
		imgui.SetCursorPos({121,100})
		if imgui.Button("*", { 30, 30 }) then
			calculator.display[1] = calculator.display[1] .. "*"
		end
		
		imgui.SetCursorPos({121,136})
		if imgui.Button("+", { 30, 30 }) then
			calculator.display[1] = calculator.display[1] .. "+"
		end

		imgui.SetCursorPos({121,172})
		if imgui.Button("-", { 30, 30 }) then
			calculator.display[1] = calculator.display[1] .. "-"
		end
		

		--Number Buttons--
		imgui.SetCursorPos({13,100})
		if imgui.Button("7", { 30, 30 }) then
			calculator.display[1] = calculator.display[1] .. "7"
		end

		imgui.SetCursorPos({49,100})
		if imgui.Button("8", { 30, 30 }) then
			calculator.display[1] = calculator.display[1] .. "8"
		end

		imgui.SetCursorPos({85,100})
		if imgui.Button("9", { 30, 30 }) then
			calculator.display[1] = calculator.display[1] .. "9"
		end

		imgui.SetCursorPos({13,136})
		if imgui.Button("4", { 30, 30 }) then
			calculator.display[1] = calculator.display[1] .. "4"
		end

		imgui.SetCursorPos({49,136})
		if imgui.Button("5", { 30, 30 }) then
			calculator.display[1] = calculator.display[1] .. "5"
		end

		imgui.SetCursorPos({85,136})
		if imgui.Button("6", { 30, 30 }) then
			calculator.display[1] = calculator.display[1] .. "6"
		end

		imgui.SetCursorPos({13,172})
		if imgui.Button("1", { 30, 30 }) then
			calculator.display[1] = calculator.display[1] .. "1"
		end

		imgui.SetCursorPos({49,172})
		if imgui.Button("2", { 30, 30 }) then
			calculator.display[1] = calculator.display[1] .. "2"
		end

		imgui.SetCursorPos({85,172})
		if imgui.Button("3", { 30, 30 }) then
			calculator.display[1] = calculator.display[1] .. "3"
		end

		imgui.SetCursorPos({13,208})
		if imgui.Button(".", { 30, 30 }) then
			calculator.display[1] = calculator.display[1] .. "."
		end
		
		imgui.SetCursorPos({49,208})
		if imgui.Button("0", { 30, 30 }) then
			calculator.display[1] = calculator.display[1] .. "0"
		end
		
		
		imgui.SetCursorPos({85,208})
		if imgui.Button("=", { 66, 30 }) then
			calculate()
		end
    end
    imgui.End();
end);