function ds(s)
    sleep(math.random(s, s+100))
end

function inv(itemid)
    for _, item in pairs(getInventory()) do
        if item.id == itemid then
            return item.amount
        end
    end
    return 0
end

function Log(a)
    logToConsole("`0[`#Dr.Rhy Universe`0][`1PnB`0] `5"..a)
end

function Logs(txt)
    sendVariant({[0] = "OnTextOverlay", [1] = txt})
end

function take(a)
    found = false
    for _, b in pairs(getWorldObject()) do
        if b.id == a then
            findPath(math.floor((b.pos.x + 10) / 32), math.floor(b.pos.y / 32))
            ds(782)
            if inv(a) == 200 then
                return true
            end
            found = true
        end
    end
    if not found then
        Log("`4No more objects with itemid: `1" .. a .. " `4found.")
        return false
    end
    return true
end

function drop(id)
    while inv(id) > 0 do
        sendPacketRaw(false, {type = 0, state = 48, x = getLocal().pos.x, y = getLocal().pos.y})
        ds(1)
        sendPacket(2, "action|drop\n|itemID|" .. id)
        ds(1300)
        if inv(id) ~= 0 then
            findPath(math.floor(getLocal().pos.x / 32 + 1), math.floor(getLocal().pos.y / 32))
            ds(700)
        end
    end
    return inv(id) == 0
end

function cek(world) 
    while true do 
        if string.find(world, "|") then 
            save = string.match(world, "([^|]+)") 
        else 
            save = world 
        end 
        if string.upper(getWorld().name) == string.upper(save) then 
            return true 
        end 
        ds(1074)
    end 
end 

AddHook("OnVarlist", "rhy_hook", function(v)
    if v[0] == "OnDialogRequest" then
        if v[1]:find("drop_item") then
            ca = v[1]:match("count||(%d+)")
            id = v[1]:match("itemID|(%d+)")
            sendPacket(2,"action|dialog_return\ndialog_name|drop_item\nitemID|"..id.."|\ncount|"..ca)
            Log("Dropped `1"..ca.." "..getItemByID(id).name)
            return true
        end
    elseif v[0] == "OnConsoleMessage" then
        return true
    end
    return false
end)

function wp(r)
    sendPacket(3, "action|join_request\nname|"..r.."\ninvitedWorld|0")
end

function main()
    while true do 
        if script_by == "Rhy Universe" and link_discord == "https://discord.com/invite/xVyUWvut2D" then
            if inv(item_id) < 200 then
                Logs("Taking..")
                wp(world1)
                if cek(world1) then 
                    ds(1500)
                    if not take(item_id) then
                        Log("`4Stopping script as no more items are found.")
                        return
                    end
                    ds(50)
                end
            elseif inv(item_id) == 200 then
                Logs("Moving..")
                wp(world2) 
                if cek(world2) then 
                    ds(1300)
                    if findPath(drop_x, drop_y) == false then
                        ds(700)
                        drop(item_id)
                        ds(1078)
                    end
                end
            end
        else
            Log("`4Wrong watermark")
            break
        end
    end
end

Log("Starting `1Move")
Log("Set `1Item `5to `1"..getItemByID(item_id).name)

main()
