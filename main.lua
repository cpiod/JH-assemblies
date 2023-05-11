
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

    assembly = {
        { base = "pistol", new = "exo_mpistol", P = 1 },
        { base = "armor_green", new = "exo_armor_ablative", P = 1},
        { base = "helmet_green", new = "exo_helmet_blast", P = 1 },
    }
    mods = {"P","A","B","S","V","C","E","O","N"}
    for _,v in ipairs(assembly) do
        if world:get_id(item) == v.base then
            local good = true
            for _,mod in ipairs(mods) do
                if v[mod] and not (result[mod] and result[mod] >= v[mod]) then
                    good = false
                end
            end
            if good then
                return v.new
            end
        end
    end

    return nil
end


register_blueprint "trait_assembly"
{
    blueprint = "trait",
    text = {
        name   = "Assemble",
        desc   = "",
        full   = "",
        abbr   = "",
        denied = "{RNothing to assemble!}",
        assembly = "You assembled a ",
    },
    callbacks = {
        on_activate = [=[
            function(self,entity)
                return -1
            end
        ]=],
        on_use = [=[
            function ( self, player, level, target )
                slots = {"1","2","3","4","armor","head"}
                for _,slot in pairs(slots) do
                    item = world:get_slot( player, slot )
                    if item then
                        exo = get_exotic(item)
                        if exo then
                            world:play_voice("vo_unique")
                            ui:set_hint("Bye {!"..world:get_name(item).."}, hello {!"..world:get_text(exo,"name").."}!", 2001, 0)
                            level:drop_item( player, item )
                            world:destroy(item)
                            -- TODO: apply manufacturer perk?
                            player:pickup( exo, true )
                            return -1
                        end
                    end
                end
                ui:set_hint( self.text.denied, 1001, 0 )
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
