
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
        {base="9mm pistol", new="exo_mpistol", P=1}
    }

    for _,v in pairs(assembly) do
        if item.text.name == v.base then
            local good = true
            -- TODO: check other mods
            if v.P and not (result["P"] and result["P"] >= v.P) then
                good = false
            end

            if good then
                return v.new
            end
        end
    end

    return nil
end


register_blueprint "runtime_assembly"
{
    flags = { EF_NOPICKUP },

    text = {
        assembly = "You assembled a new weapon!",
    },
    callbacks = {
        on_post_command = [[
            function ( self, player, cmt, tgt, time )
                local level = world:get_level()
                -- TODO: check armor as well
                local weapon = player:get_weapon()
                if weapon then
                    exo = get_exotic(weapon)
                    if exo then
                        ui:set_hint( self.text.assembly, 2001, 0 )
                        level:drop_item( player, weapon )
                        world:destroy(weapon)
                        player:pickup( exo, true )
                    end
                end
            end
        ]]
    }
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
                player:attach( "runtime_assembly" )
                player:attach( "pack_power" )
                player:attach( "pack_power" )
                player:attach( "pack_power" )
                player:attach( "pack_bulk" )
                player:attach( "pack_bulk" )
                player:attach( "pack_bulk" )
            end
        ]],
    },
}
