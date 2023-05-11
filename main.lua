
function get_exotic( item )
    local mods        = core.blueprint_list_by_data_entry( "mod" )
    local result      = {}
    local count       = 0
    local mod_data    = {}
	for _,m in ipairs( mods ) do
        mod_data[ m.id ] = m.data.mod
	end
    for c in ecs:children( item ) do
        local mid      = world:get_id( c )
        local mod_data = mod_data[ mid ]
        if mod_data then
            local letter     = mod_data.letter
            local level      = c.attributes.mod_level
            result[ letter ] = level
            count            = count + level
        end
    end
    result.count = count

    -- TODO a single item can participate in multiple recipes
    -- TODO handle trait level
    -- TODO handle other requirements (heart, relic, multitool, etc.)
    local assembly = {
        { base = "pistol", new = "exo_mpistol", P = 1 },
        { base = "armor_green", new = "exo_armor_ablative", P = 1},
        { base = "helmet_green", new = "exo_helmet_blast", P = 1 },
    }
    local mods = {"P","A","B","S","V","C","E","O","N"}
    for _,v in ipairs(assembly) do
        if world:get_id(item) == v.base then
            local good = true
            -- check all requirements
            for _,mod in ipairs(mods) do
                if v[mod] and not (result[mod] and result[mod] >= v[mod]) then
                    good = false
                    break
                end
            end
            if good then
                return v.new
            end
        end
    end

    return nil
end

function run_assembly_ui( self, entity )
    local list = {}
    local max_len = 1
    local slots = {"1","2","3","4","armor","head"}
    for _,slot in ipairs(slots) do
        local item = world:get_slot( entity, slot )
        if item then
            local exo = get_exotic(item)
            if exo then
                local name = world:get_name(item).." {!=>}  "..world:get_text(exo,"name")
                max_len = math.max( max_len, string.len( name ) )
                table.insert(list, {
                    name = name,
                    target = self,
                    parameter = {item = item, new = exo}
                })
            end
        end
    end


    if #list == 0 then
        ui:set_hint( "{RNothing to assemble!}", 1001, 0 )
        return
    end

    table.insert( list, {
        name = "Cancel",
        target = self,
        cancel = true,
    })
    list.title = "What to assemble?"
    list.size  = coord( math.max( 30, max_len + 6 ), 0 )
    ui:terminal( entity, nil, list )
end

-- TODO: requirement (whizkid ?)
-- TODO: vérifier si assembly possible ?
register_blueprint "trait_assembly"
{
    blueprint = "trait",
    text = {
        name   = "Assemble",
        desc   = "",
        full   = "",
        abbr   = "",
    },
    callbacks = {
        on_activate = [=[
            function(self,entity)
                return -1
            end
        ]=],

        on_use = [=[
            function( self, entity )
                if entity == world:get_player() then
                    run_assembly_ui( self, entity )
                    return -1
                else 
                    return -1
                end
            end
        ]=],
        on_activate = [=[
            function ( self, player, level, param )
                nova.log("ASSEMBLY - on activate called")
                if param then
                    item = param.item
                    exo = param.new
                    nova.log("item:"..item)
                    nova.log("exo:"..exo)
                    item = list[1].item
                    exo = list[1].new
                    world:play_voice("vo_unique")
                    -- ui:set_hint("Bye {!"..world:get_name(item).."}, hello {!"..world:get_text(exo,"name").."}!", 2001, 0)
                    level:drop_item( player, item )
                    world:destroy(item)
                    -- TODO: apply manufacturer perk?
                    player:pickup( exo, true )
                    return 99
                else
                    return 0
                end
            end
        ]=],
    },
    skill = {
        cooldown = 0,
        cost = 0
    },
}

register_blueprint "assembly_mod"
{
    text = {
        name   = "Angel of Assembly",
        desc   = "{!MEGA CHALLENGE PACK MOD}",
        rating = "MEDIUM",
        abbr   = "AoA",
        letter = "A",
    },
    challenge = {
        type      = "challenge",
    },
    callbacks = {
        on_create_player = [[
            function( self, player )
                -- player:attach( "runtime_assembly" )
                player:attach( "trait_assembly" )
                player:attach( "pack_power" )
                player:attach( "pack_power" )
                player:attach( "pack_power" )
                player:attach( "pack_bulk" )
                player:attach( "pack_bulk" )
                player:attach( "pack_bulk" )
                player:attach( "pack_accuracy" )
                player:attach( "pack_accuracy" )
                player:attach( "pack_accuracy" )
                player:attach( "armor_green" )
                player:attach( "helmet_green" )
                player:attach( "pistol" )
            end
        ]],
    },
}
