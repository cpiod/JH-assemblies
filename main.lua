-- whizkid 1 necessary, cost 1 multitool
assembly_l1 = {
    { base = "knife", new = "exo_knife", A = 1, P = 1 },
    { base = "pistol", new = "exo_cpistol", A = 2 }, -- calibrated
    { base = "smg", new = "exo_ssmg", B = 2 }, -- storm
    { base = "hunter_rifle", new = "exo_toxi_rifle", P = 2 },
    { base = "auto_rifle", new = "exo_nailgun", B = 1, P = 1 },
    { base = "shotgun", new = "exo_cshotgun", A = 2 }, -- focused
    { base = "armor_green", new = "exo_armor_necrotic", B = 1, A = 1 }, -- any armor ?
}
for _,v in ipairs(assembly_l1) do
    v.mt = 1
end
-- TODO: add recipes with AMP

-- whizkid 2 necessary, cost 2 multitools and a relic
assembly_l2 = {
    { base = "exo_egls", new = "exo_egls" }, -- "reload" EGLS
    { base = "exo_mag_rifle", new = "exo_mag_rifle" }, -- "reload" railgun
    { base = "exo_mpistol", new = "exo_mpistol" }, -- "reload" mag pistol
    { base = "exo_nailgun", new = "exo_snailgun", P = 1 },
    { base = "rocket_launcher", new = "exo_micro_launcher", P = 1 },
    { base = "helmet_blue", new = "exo_helmet_blast", B = 2, P = 1 },
}
for _,v in ipairs(assembly_l2) do
    v.mt = 2
    v.relic = 1
end

-- whizkid 2 necessary, cost 2 multitools, the heart and 40 HP
assembly_l3 = {
    -- tier 1 -> tier 2, tier 2 -> tier 3 weapon of the same type, requires heart so cannot be cumulated with dark cathedral
    { base = "uni_revolver_love", new = "uni_pistol_hate" },
    { base = "uni_pistol_hate", new = "uni_pistol_death" },
-- TODO: complete
    { base = "pack_power", new = "powerup_backpack" }, -- maybe permanent_backpack ?
    { base = "pack_bulk", new = "adv_pack_sustain" },
    { base = "adv_pack_sustain", new = "exo_pack_nano" },
    { base = "pack_bulk", new = "exo_pack_onyx" },
    { base = "armor_red", new = "armor_cri", A = 1, B = 1, P = 1 },
    { base = "relic_major", new = "relic_medusa_eye" },
    { base = "relic_major", new = "relic_medusa_tentacle" },
}
for _,v in ipairs(assembly_l3) do
    v.mt = 2
    v.hp = 40
    v.heart = true
end

assembly_test = {
    { base = "base_weapon", new = "exo_mpistol", P = 1 },
    { base = "pistol", new = "exo_cpistol", P = 1 },
    { base = "armor_green", new = "exo_armor_ablative", P = 1, heart = true},
    { base = "helmet_green", new = "exo_helmet_blast", P = 1, heart = true },
}
for _,v in ipairs(assembly_test) do
    v.mt = 1
end

function can_pay(player, base, new)
    nova.log("Looking for assembly")
    for _,v in ipairs(assembly_test) do
        if base == v.base and new == v.new then -- found it
            -- can pay?
            return not ((v.mt and world:has_item( player, "kit_multitool" ) < v.mt) or
            (v.heart and world:has_item( player, "frozen_heart") == 0) or
            (v.relic and not world:get_slot( player, "relic" )) or
            (v.hp and player.health.current <= v.hp))
        end
    end
end

function pay_cost(player, item, new)
    local level = world:get_level()
    for _,v in ipairs(assembly_test) do
        if world:get_id(item) == v.base and new == v.new then -- found it
            -- pay
            if v.mt then
                world:remove_items(player, "kit_multitool", v.mt)
            end
            if v.heart then
                world:remove_items(player, "frozen_heart", 1)
            end
            if v.relic then
                local r = world:get_slot(player, "relic")
                level:drop_item(player, r)
                world:destroy(r)
            end
            if v.hp then
                level:apply_damage( player, player, v.hp, ivec2(), "internal" )
            end
        end
    end
end


function get_recipes(player, item)
    local mods        = core.blueprint_list_by_data_entry( "mod" )
    local result      = {}
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
        end
    end

    -- TODO handle trait level
    -- TODO handle other requirements (heart, relic, multitool, etc.)

    local mods = {"P","A","B","S","V","C","E","O","N"}
    local recipes = {}
    for _,v in ipairs(assembly_test) do
        if world:get_id(item) == v.base then
        -- TODO: be able to specify a sub-blueprint in base (like relic_major)
            local good = true
            -- check all requirements
            for _,mod in ipairs(mods) do
                if v[mod] and not (result[mod] and result[mod] >= v[mod]) then
                    good = false
                    break
                end
            end
            if good and can_pay(player, v.base, v.new) then
                table.insert(recipes, v)
            end
        end
    end

    return recipes
end

function run_assembly_ui( self, entity )
    local list = {}
    local max_len = 1
    local slots = {"1","2","3","4","armor","head","utility"}
    for _,slot in ipairs(slots) do
        local item = world:get_slot( entity, slot )
        if item then
            local recipes = get_recipes(entity, item)
            for _,recipe in ipairs(recipes) do
                local name = world:get_name(item).." {Y=>} "..world:get_text(recipe.new,"name")
                max_len = math.max( max_len, string.len( name ) )
                table.insert(list, {
                    name = name,
                    target = self,
                    parameter = item,
                    id = recipe.new,
                })
            end
        end
    end

    if #list == 0 then
        ui:set_hint( "{RNothing to assemble!}", 1001, 0 )
        return
    end

    table.insert( list, {
        name = ui:text("ui.lua.common.cancel"),
        target = self,
        cancel = true,
    })
    list.title = "What to assemble?"
    list.size  = coord( math.max( 30, max_len + 6 ), 0 )
    ui:terminal( entity, what, list )
end

-- TODO: requirement (whizkid ?)
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
            function ( self, player, level, param, id )
                if param then
                    local item = param
                    local new = world:resolve_hash( id )
                    pay_cost(player,item, new)
                    world:play_voice("vo_unique")
                    level:drop_item( player, item )
                    world:destroy(item)
                    -- TODO: apply manufacturer perk?
                    player:pickup( new, true )
                    return 99
                end
                return 0
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
                player:attach( "trait_assembly" )
                player:attach( "pack_power" )
                player:attach( "pack_power" )
                player:attach( "pack_power" )
                player:attach( "pack_bulk" )
                player:attach( "pack_bulk" )
                player:attach( "pack_accuracy" )
                player:attach( "pack_accuracy" )
                player:attach( "armor_green" )
                player:attach( "helmet_green" )
                player:attach( "frozen_heart" )
                player:attach( "pistol" )
                player:attach("relic_fiend_heart")
                player:attach( "kit_multitool", { stack = { amount = 3 } } )
            end
        ]],
    },
}
