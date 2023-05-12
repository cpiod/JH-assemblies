
function get_recipes( item )
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

    -- TODO handle trait level
    -- TODO handle other requirements (heart, relic, multitool, etc.)

    -- whizkid 1 necessary, cost 1 multitool
    local assembly_l1 = {
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
    local assembly_l2 = {
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
    local assembly_l3 = {
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
    -- TODO: be able to specify a sub-blueprint in base (like relic_major)
    for _,v in ipairs(assembly_l3) do
        v.mt = 2
        v.hp = 40
        v.heart = true
    end

    local assembly_test = {
        { base = "pistol", new = "exo_mpistol", P = 1 },
        { base = "pistol", new = "exo_cpistol", P = 1 },
        { base = "armor_green", new = "exo_armor_ablative", P = 1},
        { base = "helmet_green", new = "exo_helmet_blast", P = 1 },
    }
    local mods = {"P","A","B","S","V","C","E","O","N"}
    local recipes = {}
    for _,v in ipairs(assembly_test) do
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
            local recipes = get_recipes(item)
            for _,recipe in ipairs(recipes) do
                local name = world:get_name(item).." {Y=>} "..world:get_text(recipe.new,"name")
                max_len = math.max( max_len, string.len( name ) )
                table.insert(list, {
                    name = name,
                    target = self,
                    recipe = recipe,
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
    ui:terminal( entity, self, list )
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
            function ( self, player, level, param, recipe )
                nova.log("ASSEMBLY - on activate called "..tostring(param).." "..tostring(recipe))
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
